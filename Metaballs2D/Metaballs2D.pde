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
  private float radius = 0;
  private float maxRadius;
  private float rVel;

  public Metaball randomize() {
      position = new PVector(.40+random(.1), .40 + random(.1));
      velocity = new PVector(random(.002)-.001, random(.002)-.001);
      acceleration = new PVector(random(.0002)-.0001, random(.0002)-.0001);
      maxRadius = random(.10) + .05;
      radius = 0;
      rVel = random(0.001);
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
    if(radius < maxRadius) {
      radius += rVel;
    }
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
      if(ball.outOfBounds(-2, -2, 2, 2)) {
        ball.randomize();
      }
    }
  }
}

final int NUM_METABALLS = 5;
MetaballSimulation sim = null;
boolean recording = false;
final String RECORD_PATH = "renders/metaballs2d######.gif";

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
  if(recording) {
    saveFrame(RECORD_PATH);
  }
}

void keyPressed() {
  if(key == 'r') {
    recording = !recording;
  }
}