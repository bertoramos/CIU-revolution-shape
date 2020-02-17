
int umbral, max;
float xloc, yloc, txtSize;

void textInput() {
  umbral = 50;
  max = 500;
  xloc = 0;
  yloc = height-20;
  txtSize = 20;
  
  textSize(txtSize/2);
  text(" [-50 ◄ ► +50]\n [+1 ▲ ▼ -1]", xloc, yloc-40);
  textSize(txtSize);
  text("Accuracy: " + umbral, xloc, yloc);
}

void updateText() {
  
  if(keyCode == UP) {
    if(umbral < max) umbral += 1;
  } else if(keyCode == DOWN) {
    if(umbral > 1) umbral -= 1;
  } else if(keyCode == LEFT) {
    umbral -= 50;
    if(umbral <= 0) umbral = 1;
  } else if(keyCode == RIGHT) {
    umbral += 50;
    if(umbral > max) umbral = max-1;
  }
  
}

void drawAccuracyValue() {
  stroke(255);
  fill(255);
  textSize(txtSize/2);
  text(" [-50 ◄ ► +50]\n [+1 ▲ ▼ -1]", xloc, yloc-40);
  textSize(txtSize);
  text("Accuracy: " + umbral, xloc, yloc);
}
