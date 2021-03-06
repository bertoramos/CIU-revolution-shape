
class Point {
  
  public final float x, y, z;
  
  Point(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public Point rotarEnY(float alpha) {
    float x1, y1, z1;
    x1 = x*cos(alpha) - z*sin(alpha);
    y1 = y;
    z1 = x*sin(alpha) + z*cos(alpha);
    return new Point(x1, y1, z1);
  }
}

class Curve {
  
  private ArrayList<Point> points;
  
  public Curve() {
    points = new ArrayList<Point>();
  }
  
  public void removeLastVertex() {
    if(points.size() > 0) points.remove(points.size()-1);
  }
  
  public void addPoint(Point p) {
    points.add(p);
  }
  
  public Point get(int i) {
    return points.get(i);
  }
  public int nVertex() {
    return points.size();
  }
  
  public Curve rotar(float alpha) {
    Curve perfil = new Curve();
    for(int i = 0; i < points.size(); i++) {
      Point p1 = points.get(i);
      perfil.addPoint(p1.rotarEnY(alpha));
    }
    return perfil;
  }
  
  public void draw() {
    for(int i = 0; i < this.points.size(); i++) {
      stroke(255);
      strokeWeight(3);
      PShape ppoint = createShape(POINT, points.get(i).x, points.get(i).y);
      shape(ppoint);
    }
    
    strokeWeight(1);
    for(int i = 0; i < this.points.size()-1; i++) {
      Point p1 = this.get(i);
      Point p2 = this.get(i+1);
      PShape path = createShape(LINE, p1.x, p1.y, p2.x, p2.y);
      shape(path);
    }
    
  }
  
}

class Shape {
  
  private ArrayList<Curve> shape;
  
  Shape() {
    this.shape = new ArrayList<Curve>();
  }
  
  public void addCurve(Curve c) {
    shape.add(c);
  }
  
  public PShape createMesh() {
    PShape pshape = createShape();
    pshape.beginShape(TRIANGLE_STRIP);
    pshape.noFill();
    
    // Zig-zag
    for(int i = 0; i < shape.size()-1; i++) {
      if(i % 2 == 0) { // De arriba hacia abajo
        for(int j = 0; j < shape.get(i).nVertex(); j++) {
          Point p0 = shape.get(i).get(j);
          Point p1 = shape.get(i+1).get(j);
          pshape.vertex(p0.x, p0.y, p0.z);
          pshape.vertex(p1.x, p1.y, p1.z);
        }
      } else { // De abajo hacia arriba
        for(int j = shape.get(i).nVertex()-1; j >= 0; j--) {
          Point p0 = shape.get(i).get(j);
          Point p1 = shape.get(i+1).get(j);
          pshape.vertex(p0.x, p0.y, p0.z);
          pshape.vertex(p1.x, p1.y, p1.z);
        }
      }
    }
    
    // Ultimo perfil con el primero
    int i = shape.size()-1;
    if(i % 2 == 0) { // De arriba hacia abajo
      for(int j = 0; j < shape.get(i).nVertex(); j++) {
        Point p0 = shape.get(i).get(j);
        Point p1 = shape.get(0).get(j);
        pshape.vertex(p0.x, p0.y, p0.z);
        pshape.vertex(p1.x, p1.y, p1.z);
      }
    } else { // De abajo hacia arriba
      for(int j = shape.get(i).nVertex()-1; j >= 0; j--) {
        Point p0 = shape.get(i).get(j);
        Point p1 = shape.get(0).get(j);
        pshape.vertex(p0.x, p0.y, p0.z);
        pshape.vertex(p1.x, p1.y, p1.z);
      }
    }
    pshape.endShape(CLOSE);
    
    return pshape;
  }
  
}

Shape buildShape(Curve c, int threshold) {
  Shape shape = new Shape();
  
  float step = (2*PI)/threshold;
  float an = 0;
  for(int i = 0; i < threshold; i++) {
    an += step;
    shape.addCurve(c.rotar(an));
  }
  return shape;
}
