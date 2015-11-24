import java.util.List;
import java.util.ArrayList;

class KochLine {
  private PVector start, end;
  
  public KochLine(PVector start, PVector end) {
    this.start = start;
    this.end = end;
  }
  
  private PVector genA() {
    return start.copy();
  }
  
  private PVector genB() {
    PVector v = PVector.sub(end, start).div(3.0);
    return start.copy().add(v);
  }
  
  private PVector genC() {
    PVector a = start.copy();
    PVector v = PVector.sub(end, start);
    v.div(3.0);
    a.add(v);
    v.rotate(-radians(60));
    a.add(v);
    return a;
  }
  
  private PVector genD() {
    PVector v = PVector.sub(end, start);
    v.mult(2/3.0);
    return v.add(start);
  }
  
  private PVector genE() {
    return end.copy();
  }
  
  List<KochLine> generate() {
    List<KochLine> generation = new ArrayList<KochLine>();
    PVector a = genA();
    PVector b = genB();
    PVector c = genC();
    PVector d = genD();
    PVector e = genE();
    
    generation.add(new KochLine(a, b));
    generation.add(new KochLine(b, c));
    generation.add(new KochLine(c, d));
    generation.add(new KochLine(d, e));

    return generation;
  }
  
  public void display() {
    line(start.x, start.y, end.x, end.y);
  }
}

class KochCurve {
  private List<KochLine> curve;
  
  public KochCurve() {
    PVector start = new PVector(0, 0);
    PVector end = new PVector(1, 0);
    KochLine segment = new KochLine(start, end);
    curve = new ArrayList<KochLine>();
    curve.add(segment);
  }

  public void generate() {
    List<KochLine> next = new ArrayList<KochLine>();
    for(KochLine segment : curve) {
      next.addAll(segment.generate());
    }
    curve = next;
  }
  
  public void display() {
    for(KochLine segment : curve) {
      segment.display();
    }
  }
}

int maxGenerations = 1;
boolean needUpdate = true;

void setup() {
  size(500, 500);
}

void draw() {
  if(!needUpdate) {
    return;
  }
  needUpdate = false;

  background(255);
  KochCurve curve = new KochCurve();
  pushMatrix();
  
  for(int i = 0; i < maxGenerations; ++i) {
    curve.generate();
  }
  
  pushMatrix();
  
  translate(100, 100);
  
  scale(300);
  strokeWeight(1/300.0);
  
  curve.display();

  translate(1, 0);
  rotate(radians(120));
  curve.display();

  translate(1, 0);
  rotate(radians(120));
  curve.display();

  popMatrix();
}

void mouseClicked() {
  maxGenerations = (maxGenerations) % 5 + 1;
  needUpdate = true;
}