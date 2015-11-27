float x = 0, y = 0;
int radiusX = 50, radiusY = 100;
float angleX = 100, angleY = 0;
float speedX = 0.065;
float speedY = 0.04;
float dx = 0, dy = 0;
float angle = 0;
float centerX, centerY;
int steps = 0;
int MAX_POINTS = 800;
PVector [] points = new PVector[MAX_POINTS];

void setup() {
  size(500, 500);
  centerX = width / 2;
  centerY = height / 2;
}

void draw() {
  background(255);
  drawArrow(x, y);
  x = centerX + radiusX * cos(angleX);
  y = centerY + radiusY * sin(angleY);
  angleX += speedX;
  angleY += speedY;
  points[steps%MAX_POINTS] = new PVector(x, y);
  drawTrail(points);
  steps++;
}

void drawArrow(float x, float y) {
  pushMatrix();
  translate(x, y);
  rotate(angle);
  line(-20, 0, 20, 0);
  line(20, 0, 10, 10);
  line(20, 0, 10, -10);
  popMatrix();
}

void drawTrail(PVector [] trail) {
  int ct = min(steps, trail.length);
  int start = steps < trail.length ? 0 : (steps + ct + 1) % ct;
  for(int i = 0; i < ct - 1; ++i) {
    int s = (i + start) % ct;
    int e = (i + start + 1) % ct;
    line(trail[s].x, trail[s].y, trail[e].x, trail[e].y);
  }
}

void mouseMoved() {
  dx = mouseX - x;
  dy = mouseY - y;
  angle = (float)Math.atan2(dy, dx);
}