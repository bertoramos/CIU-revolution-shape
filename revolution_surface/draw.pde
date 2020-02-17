
Curve currentCurve;

void startDraw() {
  currentCurve = new Curve();
  alpha = 0;
  beta = 0;
  gamma = 0;
  
  drawCanvas();
  
}

void newPoint(float mousex, float mousey) {
  Point new_point = new Point(mousex, mousey, 0);
  currentCurve.addPoint(new_point);
}

void drawCanvas() {
  
  background(0);
  stroke(255);
  line(width/2, 0, width/2, height);
  
  image(enter, 10, 5, 40, 40);
  textSize(20); 
  fill(255);
  text("Change to 3D View", 60, 30, 0);
    
}

PShape createRevShape(int threshold) {
  // Conjunto con todos los perfiles
  Shape shape = buildShape(currentCurve, threshold);
  return shape.createMesh();
}
