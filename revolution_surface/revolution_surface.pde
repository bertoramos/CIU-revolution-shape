
PImage enter;

boolean drawing;
PShape shape;


// ***** TEMP *****
import gifAnimation.*;
GifMaker gif;
// ***** TEMP *****

float alpha = 0;
float beta = 0;
float gamma = 0;

void setup() {
  size(600, 600, P3D);
  enter = loadImage("enter.svg.png");

  drawing = true;
  startDraw();
  textInput();
  
  // ***** TEMP *****
  gif = new GifMaker(this, "out.gif");
  gif.setRepeat(0);
  // ***** TEMP *****
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
  
  if(!drawing) {
    if(keyCode == LEFT)  alpha += 0.1;
    else if(keyCode == RIGHT) alpha -= 0.1;
    if(keyCode == 'a' || keyCode == 'A')  beta += 0.1;
    else if(keyCode == 's' || keyCode == 'S') beta -= 0.1;
    if(keyCode == UP)  gamma += 0.1;
    else if(keyCode == DOWN) gamma -= 0.1;
  }
  
  // ***** TEMP *****
  if(keyCode == BACKSPACE) gif.finish();
  // ***** TEMP *****
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
    background(0);
    pushMatrix();
    translate(mouseX, mouseY);
    rotateX(gamma);
    rotateY(beta);
    rotateZ(alpha);
    shape(shape);
    popMatrix();
    
    String msg = "";
    msg += "Rotate X: ▲▼\n";
    msg += "Rotate Y: A S\n";
    msg += "Rotate Z: ◄►\n";
    
    textSize(15);
    text(msg, 0, height-60);
    
    image(enter, 10, 5, 40, 40);
    textSize(20); 
    fill(255);
    text("Change to Draw View", 60, 30, 0);
  }
  
  // ***** TEMP *****
  gif.addFrame();
  // ***** TEMP *****
}
