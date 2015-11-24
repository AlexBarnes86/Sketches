void setup() {
  size(500, 500);
  ellipseMode(CENTER);
  fill(0, 0);
  smooth();
}

float t = 0;
void draw() {
  fill(0, 100);
  noStroke();
  rect(0, 0, width, height);
  stroke(0);
  fill(0, 0);
  pushMatrix();
  translate(width/2,height/2);
  t = (t + 0.5);
  rotate(radians(t));
  float r = noise(frameCount/100.0)*256;
  float g = noise(100 + frameCount/100.0)*256;
  float b = noise(1000 + frameCount/100.0)*256;
  stroke(r, g, b);
  drawCircle(0, 0, 300, 0);
  popMatrix();
}

void drawCircle(float x, float y, float r, int i) {
  if(i < 5) {
    float r2 = r*noise(frameCount/100.0);
    drawCircle(x-r2, y, r2, i + 1);
    drawCircle(x+r2, y, r2, i + 1);
    
    drawCircle(x, y-r2, r2, i + 1);
    drawCircle(x, y+r2, r2, i + 1);
    
  }
  if(i >= 2)
    ellipse(x, y, r, r);
}