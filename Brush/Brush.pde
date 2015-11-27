import shapes3d.Toroid;
import shapes3d.Shape3D;
import java.util.List;
import java.util.ArrayList;

abstract class PaintBrush {
  protected float scale;
  protected float opacity;
  
  public PaintBrush() {
    this.scale = 1;
    this.opacity = 1;
  }
  
  public void setScale(float scale) {
   this.scale = scale;
  }
  
  public void setOpactiy(float opacity) {
   this.opacity = opacity;
  }
  
  //public abstract void display(float x, float y);
  public abstract void display(PGraphics buffer, float x, float y);
}

class ImageBrush extends PaintBrush {
 private PImage image;
  
 public void display(float x, float y) {
 }
  
 public void display(PGraphics buffer, float x, float y) {
 }
}

class ShapeBrush extends PaintBrush {
 private color colour;
 private List<PVector> verticies;
  
 public ShapeBrush(color colour, List<PVector> verticies) {
   this.colour = colour;
   this.verticies = verticies;
 }

 public void display(PGraphics buffer, float x, float y) {
   buffer.pushMatrix();
   buffer.noStroke();
   buffer.fill(colour);
   buffer.beginShape();
   buffer.translate(x, y);
   for(PVector vertex : verticies) {
      buffer.vertex(scale*vertex.x, scale*vertex.y);
   }
   buffer.endShape();
   buffer.popMatrix();
 }
}

PaintBrush currentBrush = randomBrush();
PGraphics buffer;
Toroid toroid = new Toroid(this, 10, 20);

void setup() {
 size(500, 500, P3D);
 buffer = createGraphics(width, height, P3D);  
}

void draw() {
 background(0);
 scale(.1, .1);
 image(buffer, 0, 0);
 scale(10, 10);
 
 toroid.setTexture(buffer.get());
 pushMatrix();
 translate(width/2, height/2, 100);
 rotateX(radians(frameCount));
 toroid.setRadius(10, 10, 50);
 toroid.drawMode(Shape3D.TEXTURE);
 toroid.draw();
 popMatrix();

 currentBrush.display(g, mouseX, mouseY);
}

PaintBrush randomBrush() {
 List<PVector> pts = new ArrayList<PVector>();
 pts.add(new PVector(random(1), random(1)));
 pts.add(new PVector(random(1), random(1)));
 pts.add(new PVector(random(1), random(1)));
 color colour = color(random(255), random(255), random(255));
 ShapeBrush brush = new ShapeBrush(colour, pts);
 brush.setScale(random(3, 100));
 return brush;
}

void mousePressed() {
 if(mouseButton == LEFT) {
   buffer.beginDraw();
   currentBrush.display(buffer, mouseX, mouseY);
   buffer.endDraw();
 }
 if(mouseButton == RIGHT) {
   currentBrush = randomBrush();
 }
}

void mouseDragged() {
  if(mouseButton == LEFT) {
   buffer.beginDraw();
   currentBrush.display(buffer, mouseX, mouseY);
   buffer.endDraw();
  }
}