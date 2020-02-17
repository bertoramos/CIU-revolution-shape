
Curve currentCurve;

void startDraw() {
  currentCurve = new Curve();
  background(0);
  stroke(255);
  line(width/2, 0, width/2, height);
  
  image(enter, 10, 5, 40, 40);
  textSize(20); 
  fill(255);
  text("Change to 3D View", 60, 30, 0);
  
  alpha = 0;
  beta = 0;
  gamma = 0;
}

void newPoint(float mousex, float mousey) {
  Point new_point = new Point(mousex, mousey, 0);
  
  // Vértice de perfil
  stroke(255);
  strokeWeight(3);
  PShape ppoint = createShape(POINT, new_point.x, new_point.y);
  shape(ppoint);
  strokeWeight(1);
  
  // Linea entre ultimo vertice y nuevo vertice
  if(currentCurve.nVertex() > 0) {
    Point last = currentCurve.getLastVertex();
    PShape path = createShape(LINE, last.x, last.y, new_point.x, new_point.y);
    shape(path);
  }
  
  currentCurve.addPoint(new_point);
}

PShape createRevShape(int threshold) {
  // Conjunto con todos los perfiles
  Shape shape = buildShape(currentCurve, threshold);
  return shape.createMesh();
}
