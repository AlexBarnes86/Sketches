import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;

class Fan {
  private int segments;
  private int resolution;

  private float radius;
  private PImage [] textures;
  private Body body;

  public void draw() {
    float angleStep = 2*PI / segments;
    float resolutionStep = angleStep / resolution;
    float angle = 0;

    Vec2 pos = box2d.getBodyPixelCoord(body);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(body.getAngle());
    noStroke();
    textureMode(NORMAL);
    for(int i = 0; i < segments; ++i) {
      beginShape();
      texture(textures[i%textures.length]);
      vertex(0, 0, 0.5, 0.5);
      for(int j = 0; j < resolution; ++j) {
        float cAngle = cos(angle), sAngle = sin(angle);
        vertex(radius*cAngle, radius*sAngle, 0.5+cAngle/2, 0.5+sAngle/2);
        angle += resolutionStep;
      }
      vertex(radius*cos(angle), radius*sin(angle), 0.5+cos(angle)/2, 0.5+sin(angle)/2);
      vertex(0, 0, 0.5, 0.5);
      endShape();
    }
    popMatrix();
  }
  
  public Fan(float radius, int segments, PImage [] textures, Body body) {
    this.radius = radius;
    this.segments = segments;
    this.textures = textures;
    this.body = body;
    this.resolution = 360/segments;
  }
}

Fan [] fans;
Body [] fanBody;

PImage createColorTexture(color colour) {
  PImage img = createImage(1, 1, RGB);
  img.loadPixels();
  img.pixels[0] = colour;
  img.updatePixels();
  return img;
}

PImage createPerlinTexture(int w, int h, float offsetX, float offsetY, float scale, color colour) {
  PImage img = createImage(w, h, RGB);
  img.loadPixels();
  for(int row = 0; row < h; ++row) {
    for(int col = 0; col < w; ++col) {
      float noiseVal = min(1.0, 0.5+noise(row/scale+offsetX, col/scale+offsetY));
      int r = int(red(colour)*noiseVal);
      int g = int(green(colour)*noiseVal);
      int b = int(blue(colour)*noiseVal);
      img.pixels[row*w+col] = color(r, g, b);
    }
  }
  img.updatePixels();
  return img;
}

void setup() {
  size(640, 360, P2D);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);

  initFans();
}

void initFans() {
  PImage [] textures = new PImage[2];
  textures[0] = createPerlinTexture(100, 100, random(100), random(100), 10, color(255, 0, 0));
  textures[1] = createPerlinTexture(100, 100, random(100), random(100), 10, color(0, 0, 255));

  fans = new Fan[2];
  fanBody = new Body[2];

  BodyDef bd = new BodyDef();
  bd.type = BodyType.DYNAMIC;
  bd.setAngularVelocity(0.5);
  bd.position = new Vec2(0, 0);
  fanBody[0] = box2d.world.createBody(bd);
  fans[0] = new Fan(1000, 20, textures, fanBody[0]);
  
  textures = new PImage[2];
  textures[0] = createPerlinTexture(100, 100, random(100), random(100), 20, color(255, 255, 0));
  textures[1] = createPerlinTexture(100, 100, random(100), random(100), 20, color(0, 255, 0));
  
  bd.type = BodyType.DYNAMIC;
  bd.setAngularVelocity(-0.49);
  bd.position = new Vec2(-5, -5);
  fanBody[1] = box2d.world.createBody(bd);
  fans[1] = new Fan(150, 20, textures, fanBody[1]);
}

boolean recording = false;
void draw() {
  background(255);
  for(Fan fan : fans) {
    fan.draw();
  }
  if(recording) {
    saveFrame("renders/fan######.gif");
  }
  box2d.step();
}

void keyPressed() {
  if(key == 'r') {
    recording = !recording;
  }
}

void mousePressed() {
  initFans();
}