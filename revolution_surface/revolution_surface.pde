
PImage enter;

boolean drawing;
PShape shape;

void setup() {
  size(600, 600, P3D);
  enter = loadImage("enter.svg.png");

  drawing = true;
  startDraw();
  textInput();
}

void keyPressed() {
  if(keyCode == '\n' && !drawing) { // Redraw
    // clear all
    //translate(-mouseX, -mouseY); // reset translation
    drawing = true;
    startDraw();
  } else if(keyCode == '\n' && drawing) { // End drawing
    drawing = false;
    shape = createRevShape(umbral);
  }
  // Text
  if(drawing) {
    updateText();
  }
  
}

void mousePressed() {
  if(drawing) {
    translate(width/2, height/2);
    newPoint(mouseX - (width/2), mouseY - (height/2));
  }
}


final String drawMessage = "Press enter to start drawing";
final String showMessage = "Press enter to show 3D shape";

void draw() {
  if(!drawing) {
    background(255);
    translate(mouseX, mouseY);
    shape(shape);
    
    translate(-mouseX, -mouseY);
    image(enter, 10, 5, 40, 40);
    textSize(20); 
    fill(0);
    text("Change to Draw View", 60, 30, 0);
  }
}
