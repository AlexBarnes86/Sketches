void setup() {
  size(500, 500);
  fill(0, 0);
  stroke(0);
  smooth();
}

void draw() {
  background(255);
  drawFork(width/2, height, 150, 0);
}

void drawFork(int x, int y, int w, int i) {
  if(w > 1) {
    drawFork(x - w, y - w, w / 2, i + 1);
    drawFork(x + w, y - w, w / 2, i + 1);
  }
  line(x-w, y-w, x, y);
  line(x, y, x+w, y-w);
}