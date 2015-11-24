void drawSeirpenski(PVector a, PVector b, PVector c, int itr, int depth) {
  if(itr < depth) {
    PVector midLeft = b.copy();
    midLeft.sub(a);
    midLeft.div(2);
    midLeft.add(a);

    PVector midRight = b.copy();
    midRight.sub(c);
    midRight.div(2);
    midRight.add(c);

    PVector midBottom = c.copy();
    midBottom.sub(a);
    midBottom.div(2);
    midBottom.add(a);

    drawSeirpenski(midLeft, b, midRight, itr+1, depth);
    drawSeirpenski(a, midLeft, midBottom, itr+1, depth);
    drawSeirpenski(midBottom, midRight, c, itr+1, depth);
  }
  if(itr == depth) {
    fill(0);
    beginShape();
    vertex(a.x, a.y);
    vertex(b.x, b.y);
    vertex(c.x, c.y);
    endShape();
  }
}

void setup() {
  size(500, 500);
}

void draw() {
  background(255);
  PVector a = new PVector(width/2, 100);
  PVector b = new PVector(width/2 - 200, 400);
  PVector c = new PVector(width/2 + 200, 400);
  drawSeirpenski(a, b, c, 1, 7);
}