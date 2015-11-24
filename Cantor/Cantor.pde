import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;

class CantorLine {
  PVector start, end;
  
  public CantorLine(PVector start, PVector end) {
    this.start = start;
    this.end = end;
  }
  
  public CantorLine() {
    start = new PVector();
    end = new PVector();
  }

  public void display() {
    line(start.x, start.y, end.x, end.y);
  }
}

List<List<CantorLine>> rows = new ArrayList<List<CantorLine>>();
List<CantorLine> segments = new ArrayList<CantorLine>();
final int STEPS = 10;
final int GAP = 30;

List<CantorLine> generate(List<CantorLine> segments, int gap) {
  List<CantorLine> next = new ArrayList<CantorLine>();

  for(CantorLine segment : segments) {
    CantorLine a = new CantorLine();
    a.start.x = segment.start.x;
    a.start.y = segment.start.y + gap;
    a.end.x = segment.start.x + (segment.end.x - segment.start.x) / 3.0;
    a.end.y = segment.start.y + gap;
    next.add(a);

    CantorLine b = new CantorLine();
    b.start.x = segment.start.x + 2 * (segment.end.x - segment.start.x) / 3.0;
    b.start.y = segment.start.y + gap;
    b.end.x = segment.end.x;
    b.end.y = segment.start.y + gap;
    next.add(b);
  }

  return next;
}

void setup() {
  size(500, 500);
  CantorLine initiator = new CantorLine(new PVector(100, 100), new PVector(400, 100));
  segments.add(initiator);
  for(int i = 0; i < STEPS; ++i) {
    rows.add(segments);
    segments = generate(segments, 20);
  }
}

void draw() {
  background(255);
  int weight = 8;
  for(List<CantorLine> row : rows) {
    strokeWeight(max(1, weight--));
    for(CantorLine segment : row) {
      segment.display();
    }
  }
}