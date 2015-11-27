float theta = PI/6;

void branch(float len) {
  line(0, 0, 0, -len);
  translate(0, -len);
  
  len *= 2.0/3;
  
  if(len >= 2) {
    pushMatrix();
    rotate(theta+noise(frameCount/1000.0));
    branch(len);
    popMatrix();
    
    pushMatrix();
    rotate(-theta-noise((frameCount+100)/1000.0));
    branch(len);
    popMatrix();
  }
}

void setup() {
  size(500, 500);
  background(255);
}

void draw() {
  background(255);
  translate(width/2, height);
  branch(100);
}

void mouseMoved() {
  theta = map(mouseX, 0, width, -PI/2, PI/2);
}