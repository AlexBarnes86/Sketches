int caSize = 500;
boolean [] current;
boolean [] lookup;

String to01(boolean bool) {
  return bool ? "1" : "0";
}

boolean [] ruleNumberTranslate (int ruleNumber) {
  StringBuilder str = new StringBuilder(Integer.toString(ruleNumber, 2));
  while(str.length() < 8) {
    str.insert(0, "0");
  }
  str.reverse();
  boolean [] lut = new boolean[8];
  for(int i = 0; i < str.length(); ++i) {
    lut[i] = str.charAt(i) == '1';
  }
  return lut;
}

boolean compute(boolean left, boolean center, boolean right) {
  int index = Integer.parseInt(to01(left) + to01(center) + to01(right), 2);
  return lookup[index];
}

int step = 0;

void setup() {
  size(500, 500);
  frameRate(60);
  noStroke();
  fill(0);
  background(255);
  
  resetCA(30);
}

void draw() {
  float blockSize = width * 1.0 / caSize;
  if(step * blockSize >= height) {
    step = 0;
    background(255);
  }
  translate(0, step * blockSize);
  step++;
  for(int i = 0; i < caSize; ++i) {
    if(current[i]) {
      rect(i*blockSize, 0, blockSize, blockSize);
    }
  }
  
  current = generate(current);
}

void resetCA(int ruleNum) {
  lookup = ruleNumberTranslate(ruleNum);
  step = 0;
  current = new boolean[caSize];
  current[caSize/2] = true;
}

boolean [] generate(boolean[] current) {
  boolean [] next = new boolean[current.length];
  next[0] = next[next.length - 1] = false;
  for(int i = 1; i < current.length - 1; ++i) {
    next[i] = compute(current[i - 1], current[i], current[i+1]);
    //println(to01(current[i-1]) + to01(current[i]) + to01(current[i+1]) + " => " + to01(next[i]));
  }
  return next;
}

void mousePressed() {
  int ruleNum = (int)random(0, 256);
  println(ruleNum);
  resetCA(ruleNum);
  background(255);
}