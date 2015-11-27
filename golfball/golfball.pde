import shapes3d.Ellipsoid;
import shapes3d.Shape3D;

float pit(float u, float v) {
  float r = 0.5;
  float s = u - .5;
  float t = v - .5;
  float d = sqrt(s*s+t*t);
  if(d < r) {
    return r - d;
  }
  return 1;
}

float golfball(float u, float v, int nx, int ny) {
  float pitSizeU = (1.0)/nx;
  float pitSizeV = (1.0)/ny;

  float s = u % pitSizeU;
  float t = v % pitSizeV;

  return pit(s/pitSizeU, t/pitSizeV);
}

PGraphics pg = null;
Ellipsoid sphere;
  
void setup() {
  size(500, 500, P3D);
  noStroke();
  strokeWeight(0);

  pg = createGraphics(500, 500);
  pg.beginDraw();
  pg.loadPixels();
  for(int h = 0; h < height; ++h) {
    for(int w = 0; w < width; ++w) {
      float v = map(golfball(w*1.0/width, h*1.0/height, 10, 10), 0, 1, 200, 255);
      pg.pixels[h*width + w] = color(v);
    }
  }
  pg.updatePixels();
  pg.endDraw();
  
  sphere = new Ellipsoid(this, 20, 20);
  sphere.setTexture(pg.get());
  sphere.drawMode(Shape3D.TEXTURE);
}

void draw() {
  background(0);
  translate(width/2, height/2);
  rotateZ(radians(frameCount));
  rotateX(radians(frameCount/2));
  sphere.draw();
}