import java.util.Iterator;

class Point {
  public float x, y;
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

ArrayList<Point> cloud = new ArrayList<Point>();
boolean[][] crystal;
int mx, my;
int INIT_CLOUD_SIZE = 10_000;

void setup() {
  size(500, 500);
  frameRate(200);
  mx = width/2;
  my = height/2;
  for(int i = 0; i < INIT_CLOUD_SIZE; ++i) {
    float p = random(1) * width/2;
    float t = random(0, TWO_PI);
    cloud.add(new Point((int)(cos(t)*p+mx), (int)(sin(t)*p+my)));
  }
  
  crystal = new boolean[500][500];
  crystal[height/2][width/2] = true;

  smooth();
  noStroke();
}

int ct = 0;

void draw() {
  loadPixels();
  
  fill(255, 50);
  rect(0, 0, width, height);

  fill(255, 0, 0);
  Iterator<Point> itr = cloud.iterator();
  while(itr.hasNext()) {
    Point p = itr.next();
    float nx = min(width-1, max(0, p.x + random(-2, 2)));
    float ny = min(height-1, max(0, p.y + random(-2, 2)));

    if(random(1) > 0.75 && sqrt(pow(nx-mx, 2) + pow(ny-my, 2)) > sqrt(pow(p.x-mx, 2) + pow(p.y-my, 2))) {
     continue;
    }

    int cx = (int)nx;
    int cy = (int)ny;

    if(crystal[cy][cx]) {
      itr.remove();
      crystal[(int)p.y][(int)p.x] = true;
    }
    else {
      p.x = nx;
      p.y = ny;
      rect(p.x, p.y, 1, 1);
    }
  }
  
  fill(0, 0, 255);
  for(int r = 0; r < height; r++) {
    for(int c = 0; c < width; c++) {
      if(crystal[r][c]) {
        rect(c, r, 1, 1);
      }
    }
  }
  
  if(ct++ % 10 == 0) {
    saveFrame("screenshots/crystal-#######.gif");
  }
}