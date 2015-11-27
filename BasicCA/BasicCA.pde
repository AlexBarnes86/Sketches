import java.util.List;
import java.util.ArrayList;

int caSize = 250;
boolean [] lookup;
int step = 0;
List<List<Boolean>> rows = new ArrayList<List<Boolean>>(caSize);

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

void setup() {
  size(500, 500);
  frameRate(60);
  noStroke();
  fill(0);
  background(255);
  resetCA(30, false);
}

void draw() {
  background(255);
  float blockSize = width * 1.0 / caSize;
  List<Boolean> curRow = null;
  for(int r = 0; r < rows.size(); ++r) {
    curRow = rows.get(r);
    for(int c = 0; c < curRow.size(); ++c) {
      if(curRow.get(c)) {
        rect(c*blockSize, r*blockSize, blockSize, blockSize);
      }
    }
  }
  
  rows.add(generate(curRow));
  if(rows.size() > caSize) {
    rows.remove(0);
  }

  step++;
}

void resetCA(int ruleNum, boolean randAssign) {
  rows = new ArrayList<List<Boolean>>(caSize);
  lookup = ruleNumberTranslate(ruleNum);
  step = 0;
  List<Boolean> current = new ArrayList<Boolean>(caSize);
  
  if(randAssign) {
    for(int i = 0; i < caSize; ++i) {
      current.add(new Boolean(random(0, 2) >= 1));
    }
  }
  else {
    for(int i = 0; i < caSize; ++i) {
      current.add(new Boolean(i == caSize/2));
    }
  }
  rows.add(current);
}

List<Boolean> generate(List<Boolean> current) {
  List<Boolean> next = new ArrayList<Boolean>(current.size());
  next.add(false);
  for(int i = 1; i < current.size() - 1; ++i) {
    next.add(compute(current.get(i - 1), current.get(i), current.get(i+1)));
    //println(to01(current[i-1]) + to01(current[i]) + to01(current[i+1]) + " => " + to01(next[i]));
  }
  next.add(false);
  return next;
}

void mousePressed() {
  int ruleNum = (int)random(0, 256);
  println(ruleNum);
  resetCA(ruleNum, mouseButton == RIGHT);
  background(255);
}