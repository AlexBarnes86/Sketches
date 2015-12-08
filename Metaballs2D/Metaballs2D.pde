class Range {
  private float a, b;
  
  public Range(float a, float b) {
    this.a = a;
    this.b = b;
  }

  public float low() {
    return a < b ? a : b;
  }
  
  public float high() {
    return a > b ? a : b;
  }
}

class Metaball {
  private color colour;
  private PVector position;
  private PVector velocity;
  private PVector acceleration;
  private float radius;
  
  public Metaball randomize() {
      position = new PVector(.45+random(.1), .45 + random(.1));
      velocity = new PVector(random(.02)-.01, random(.02)-.01);
      acceleration = new PVector(random(.0002)-.0001, random(.0002)-.0001);
      radius = random(.05) + .02;
      colour = color((int)random(255), (int)random(255), (int)random(255));
      return this;
  }

  public Metaball() {
    this.position = new PVector();
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.radius = 0;
  }
  
  public Metaball(PVector position, PVector velocity, PVector acceleration, float radius) {
    this.position = position;
    this.velocity = velocity;
    this.acceleration = acceleration;
    this.radius = radius;
  }

  float eval(float x, float y) {
    if(x == position.x && y == position.y) {
      //return something guaranteed to be outside the iso threshold, but not so large that we have to worry about integer overflow
      return 1000;
    }
    float dx = x - position.x;
    float dy = y - position.y;
    float dx2 = dx*dx;
    float dy2 = dy*dy;
    return (radius / sqrt(dx2 + dy2));
  }
  
  boolean outOfBounds(float sx, float sy, float ex, float ey) {
    return position.x + radius < sx || position.y + radius < sy ||
      position.x - radius > ex || position.y + radius > ey;
  }
  
  void update() {
    this.velocity.add(acceleration);
    this.position.add(velocity);
  }
  
  color getColor() {
    return colour;
  }
}

class MetaballSimulation {
  private Range isoSurfaceThreshold = new Range(0.95, 1.05);
  private Metaball[] balls;
  
  public MetaballSimulation(int numMetaballs) {
    balls = new Metaball[numMetaballs];
    for(int i = 0; i < balls.length; ++i) {
      balls[i] = new Metaball().randomize();
    }
  }
  
  public MetaballSimulation(Metaball[] balls) {
    this.balls = balls;
  }

  public void draw(color [] buffer, int w, int h) {
    for(int y = 0; y < height; y++) { 
      for(int x = 0; x < width; x++) { 
        // Reset the summation 
        float sum = 0;
        float r = 0, g = 0, b = 0;
        // Iterate through every Metaball in the world
        for(Metaball ball : balls) {
          float strength = ball.eval(x*1.0/w, y*1.0/h);
          sum += strength;
          color c = ball.getColor();
          r += strength * red(c);
          g += strength * green(c);
          b += strength * blue(c);
        }
        // Decide whether to draw a pixel
        if(sum >= isoSurfaceThreshold.low() && sum <= isoSurfaceThreshold.high()) { 
          buffer[y*w+x] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
        }
      }
    }
  }
  
  public void update() {
    for(Metaball ball : balls) {
      ball.update();
      if(ball.outOfBounds(0, 0, 1, 1)) {
        ball.randomize();
      }
    }
  }
}

final int NUM_METABALLS = 5;
MetaballSimulation sim = null;

void setup() {
  size(500, 500);
  sim = new MetaballSimulation(NUM_METABALLS);
}

void draw() {
  background(0);
  loadPixels();
  sim.draw(pixels, width, height);
  updatePixels();
  sim.update();
}