import java.util.HashMap;
import java.util.Map;

class Turtle {
  private float len;
  private float theta;
  
  public Turtle(float len, float theta) {
    this.len = len;
    this.theta = theta;
  }

  public void process(String str) {
    for(int i = 0; i < str.length(); ++i) {
      process(str.charAt(i));
    }
  }

  private void process(char c) {
    if(c == 'F') {
      line(0, 0, len, 0);
      translate(len, 0);
    }
    else if(c == 'G') {
      translate(len, 0);
    }
    else if(c == '+') {
      rotate(theta+noise(frameCount/1000.0));
    }
    else if(c == '-') {
      rotate(-theta-noise(frameCount/1000.0));
    }
    else if(c == '[') {
      pushMatrix();
    }
    else if(c == ']') {
      popMatrix();
    }
    else {
      throw new IllegalArgumentException("Unrecognized instruction: " + c);
    }
  }
}

public String generate(String init, int iterations, Map<Character, String> rules) {
  StringBuilder sb = new StringBuilder(init);
  for(int i = 0; i < iterations; ++i) {
    StringBuilder next = new StringBuilder();
    for(int j = 0; j < sb.length(); ++j) {
      Character c = sb.charAt(j);
      String rep = rules.get(c);
      if(rep != null) {
        next.append(rep);
      }
      else {
        next.append(c);
      }
    }
    sb = next;
  }
  return sb.toString();
}

Turtle turtle = new Turtle(10, radians(10));
String instructions = "";

void setup() {
  size(500, 500);
  Map<Character, String> rules = new HashMap<Character, String>();
  rules.put('F', "FF+[+F-F-F]-[-F+F+F]");
  instructions = generate("F", 4, rules);
  println(instructions);
}

void draw() {
  background(255);
  translate(width/2, height);
  rotate(-radians(90));
  turtle.process(instructions);
}