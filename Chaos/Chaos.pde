import java.util.List;
import java.util.ArrayList;
import g4p_controls.*;

int NPOINTS = 10000;
int DEPTH = 20;
float SCALE = 1.0;
boolean record = false;

class ChaosFunction {
  public float a, b, c, d, e, f;

  public ChaosFunction(float [] values) {
    setValues(values);
  }

  public ChaosFunction(float a, float b, float c, float d, float e, float f) {
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    this.e = e;
    this.f = f;
  }
  
  public PVector compute(PVector v) {
    return new PVector(a*v.x + b*v.y + c, d*v.x + e*v.y + f);
  }
  
  public String toString() {
    return String.format("a: %f, b: %f, c: %f, d: %f, e: %f, f: %f", a, b, c, d, e, f);
  }
  
  public float[] getValues() {
    return new float [] {a, b, c, d, e, f};
  }
  
  public void setValues(float [] values) {
    a = values[0];
    b = values[1];
    c = values[2];
    d = values[3];
    e = values[4];
    f = values[5];
  }
}

class ChaosGame {
  private List<ChaosFunction> funcs;

  public ChaosGame(List<ChaosFunction> funcs) {
    this.funcs = funcs;
  }
  
  public void draw(int points, int depth) {
    noStroke();
    List<PVector> pts = new ArrayList<PVector>();
    float maxX = 0, maxY = 0;
    float totalX = 0, totalY = 0;

    for(int i = 0; i < points; ++i) {
      PVector p = new PVector(random(0, width), random(0, height));
      for(int d = 0; d < depth; ++d) {
        ChaosFunction func = funcs.get(int(random(funcs.size())));
        p = func.compute(p);
      }
      totalX += p.x;
      totalY += p.y;
      if(maxX < p.x) {
        maxX = p.x;
      }
      if(maxY < p.y) {
        maxY = p.y;
      }
      pts.add(p);
    }
    
    float scaleX = width*SCALE / (totalX / NPOINTS);
    float scaleY = height*SCALE / (totalY / NPOINTS);
    float scale = min(scaleX, scaleY);
    for(PVector p : pts) {
      rect(p.x*scale, p.y*scale, 1, 1);
    }
  }
  
  public List<ChaosFunction> getFunctions() {
    return funcs;
  }
  
  public String toString() {
    StringBuilder sb = new StringBuilder();
    for(ChaosFunction f : funcs) {
      sb.append(f + "\n");
    }
    return sb.toString();
  }
}

List<ChaosFunction> sierpinski() {
  List<ChaosFunction> funcs = new ArrayList<ChaosFunction>();
  funcs.add(new ChaosFunction(0.5, 0, 0, 0, 0.5, 0));
  funcs.add(new ChaosFunction(0.5, 0, 0.5, 0, 0.5, 0));
  funcs.add(new ChaosFunction(0.5, 0, 0, 0, 0.5, 0.5));
  return funcs;
}

ChaosFunction randomChaosFunction() {
  float f = random(0.5);
  return new ChaosFunction(f/random(1)+0.0001, 0, f*f, 0, f/random(1)+0.0001, f*f);
}

//List<ChaosFunction> randomIFS() {
//  List<ChaosFunction> funcs = new ArrayList<ChaosFunction>();
//  for(int i = 0; i < 3; ++i) {
//    funcs.add(randomChaosFunction());
//  }
//  return funcs;
//}

class ControlWindow {
  PApplet parent;
  GWindow window;
  public float initValues[];
  public GCustomSlider[] sliders;
  
  GCustomSlider createSlider(int i) {
    GCustomSlider slider = new GCustomSlider(window, 20, 100+i*40, 400, 40, null);
    slider.setShowDecor(false, false, false, true);
    slider.setNbrTicks(10000);
    slider.setLimits(0, 1);
    return slider;
  }
  
  public ControlWindow(PApplet parent, ChaosFunction function) {
    this.parent = parent;
    this.initValues = function.getValues();
  }
  
  public void init() {
    this.window = GWindow.getWindow(parent, "Control", int(random(0, 500))+100, int(random(0, 500)) + 100, 500, 500, JAVA2D);
    sliders = new GCustomSlider[6];

    for(int i = 0; i < sliders.length; ++i) {
      sliders[i] = createSlider(i);
      sliders[i].setNumberFormat(G4P.DECIMAL, 6);
      sliders[i].setValue(initValues[i]);
    }
  }
  
  public float[] getValues() {
    float [] values = new float[6];
    for(int i = 0; i < values.length; ++i) {
      values[i] = sliders[i].getValueF();
    }
    return values;
  }
  
  public void close() {
    this.window.forceClose();
  }
}

ChaosGame game = null;
List<ControlWindow> controlWindows = new ArrayList<ControlWindow>();
boolean ready = false;

void updateGame() {
  List<ChaosFunction> functions = new ArrayList<ChaosFunction>();

  for(ControlWindow window : controlWindows) {
    float [] values = window.getValues();
    functions.add(new ChaosFunction(values));
  }
  game = new ChaosGame(functions);
  println(game);
}
    
public void handleSliderEvents(GValueControl slider, GEvent event) {
  if(ready) {
    updateGame();
  }
}

void setup() {
  println("Controls: d/D: depth(" + DEPTH + "), p/P: points(" + NPOINTS + "), f/F: functions");
  size(500, 500);
  fill(0);

  game = new ChaosGame(sierpinski());
  for(ChaosFunction func : game.getFunctions()) {
    ControlWindow window = new ControlWindow(this, func); 
    controlWindows.add(window);
    window.init();
  }
  ready = true;
}

void draw() {
  background(255);
  game.draw(NPOINTS, DEPTH);
  if(record) {
    saveFrame("renders/chaos#####.tif");
  }
}

void keyPressed() {
  if(key == ESC) {
    exit();
  }

  if(key == 'd') {
    DEPTH++;
    println("Depth: " + DEPTH);
  }
  else if (key == 'D') {
    DEPTH--;
    println("Depth: " + DEPTH);
  }
  else if (key == 'p') {
    NPOINTS += 100;
    println("Points: " + NPOINTS);
  }
  else if (key == 'P') {
    NPOINTS -= 100;
    println("Points: " + NPOINTS);
  } 
  else if(key == 'f') {
   ready = false;
   ControlWindow window = new ControlWindow(this, randomChaosFunction());
   window.init();
   controlWindows.add(window);
   
   ready = true;
  }
  else if(key == 'F') {
   ready = false;
   ControlWindow window = controlWindows.get(controlWindows.size()-1);
   window.close();
   controlWindows.remove(controlWindows.size()-1);
   ready = true;
  }
  else if (key == 's') {
    SCALE += 0.01;
    println("Scale: " + SCALE);
  }
  else if(key == 'S') {
    SCALE -= 0.01;
    println("Scale: " + SCALE);
  }
  else if(key == 'r') {
    record = !record;
  }
  else {
    println("Unrecognized key pressed: " + key);
  }
}