import java.util.List;
import java.util.ArrayList;

String to01(boolean bool) {
  return bool ? "1" : "0";
}

interface LifeRule {
  boolean process(boolean[][] pattern);
}

class Life {
  private int size;
  private int step;
  private boolean[][] board;
  private LifeRule rule;

  public Life(int size, LifeRule rule) {
    this.size = size;
    this.rule = rule;
    board = new boolean[size][size];
  }
  
  public void randomize() {
    for(int r = 0; r < size; ++r) {
      for(int c = 0; c < size; ++c) {
        board[r][c] = random(0, 2) >= 1;
      }
    }
  }
  
  public void display() {
    float blockSize = width * 1.0 / size;
    for(int r = 0; r < board.length; ++r) {
      for(int c = 0; c < board[r].length; ++c) {
        if(board[r][c]) {
          rect(c*blockSize, r*blockSize, blockSize, blockSize);
        }
      }
    }
  }
  
  private boolean[][] patternAt(int r, int c) {
    boolean [][] pattern = new boolean[3][3];
    for(int i = -1; i <= 1; ++i) {
      for(int j = -1; j <= 1; ++j) {
        pattern[i+1][j+1] = board[abs(r+i) % size][abs(c+j) % size];
      }
    }

    return pattern;
  }
  
  public void next() {
    boolean [][] nextBoard = new boolean[size][size];

    for(int r = 0; r < size; ++r) {
      for(int c = 0; c < size; ++c) {
        nextBoard[r][c] = rule.process(patternAt(r, c));
      }
    }
    
    board = nextBoard;

    step++;
  }
}

Life life = null;

void setup() {
  size(500, 500);
  frameRate(10);
  noStroke();
  fill(0);
  life = new Life(250, new LifeRule() {
    public boolean process(boolean [][] pattern) {
      int neighbors = 0;
      for(int r = 0; r < pattern.length; ++r) {
        for(int c = 0; c < pattern[r].length; ++c) {
          if(!(r == 1 && c == 1) && pattern[r][c]) {
            neighbors++;
          }
        }
      }
      
      if(neighbors < 2 || neighbors > 3) {
        return false;
        //return random(1) > .9999;
      }
      if(neighbors == 3) {
        return true;
        //return random(1) < .9999;
      }

      return pattern[1][1];
    }
  });
  life.randomize();
}

void draw() {
  background(255);
  life.display();
  life.next();
}