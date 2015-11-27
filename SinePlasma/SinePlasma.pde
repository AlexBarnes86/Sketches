float plasma(float u, float v, float spacing) {
  float s = u * 2*PI;
  float t = v * 2*PI;
  return 0.5 + 0.5*sin(s*spacing) + 0.5*sin(t*spacing);
}

int SPACING = 5;

void setup() {
  size(500, 500);
}

void draw() {
  loadPixels();
  for(int h = 0; h < height; ++h) {
    for(int w = 0; w < width; ++w) {
      float u = w * 1.0/width;
      float v = h * 1.0/height;
      float value = plasma(u, v, SPACING);
      pixels[h*width+w] = color(map(value, 0, 1, 0, 255));
    }
  }
  updatePixels();
}