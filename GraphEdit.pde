boolean shiftPressed = false; //<>//
boolean altPressed = false;
final int NODE_W = 30;
char newLabel = 'A';
ArrayList visited = new ArrayList<Node>(); //for dfs
float boxX = -1, boxY = -1;
String neutralHint, selectedHint, bottom;
String error = "";
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Node> selected = new ArrayList<Node>();
Node toAdd = null;
boolean grab = false;

void setup() {
  size(800, 600);
  pixelDensity(2);
  neutralHint = getLines(neutralHints);
  selectedHint = getLines(selectedHints);
  bottom = neutralHint;
}

void draw() {
  background(80);

  drawGrid();

  for (Node n : nodes) n.showEdges();

  for (Node n : nodes) {
    n.show();
  }
  for (Node n : selected) {
    //print(n.label);
    n.show(color(0, 200, 0));
  }
  
  if(toAdd != null) {
    toAdd.x = mouseX;
    toAdd.y = mouseY;
    toAdd.show(color(255, 0, 0, 100));
  }
    
  
  if (!selected.isEmpty()) selected.get(0).show(color(0, 255, 0));
  // println();
  if (grab) {
    bottom = "Click to place selection";
    for (Node n : selected) {
      n.x += mouseX - pmouseX;
      n.y += mouseY - pmouseY;
    }
  }

  if (selectMode == SelectMode.box) {
    cursor(CROSS); 
    if (boxX > 0 && boxY > 0) {
      stroke(200);
      noFill();
      rectMode(CORNERS);
      rect(boxX, boxY, mouseX, mouseY);
    }
  } else {
    cursor(ARROW); 
  }

  
  textAlign(LEFT);
  textSize(8);
  fill(255);
  text(mouseX + ", " + mouseY, 20, 20);
  textSize(12);
  int numLines = 1;
  for (int i = 0; i < bottom.length(); i++)
    if (bottom.charAt(i) == '\n') numLines++;  
  text(bottom, 20, height - 20*numLines);
  
  textAlign(RIGHT);
  
  fill(255, 0, 0);
  text(error, width-20, height-20);
  
}

void drawGrid() {
  stroke(0, 80);
  for (int i = 0; i < width; i+= 20) {
    strokeWeight(i%100 == 0 ? 1 : 0.7);
    line(i, 0, i, height);
  }
  for (int i = 0; i < height; i+= 20) {
    strokeWeight(i%100 == 0 ? 1 : 0.7);
    line(0, i, width, i);
  }
}

String getLines(String[] lines) {
  String rtn = "";
  for (String line : lines) {
    rtn = rtn + line + '\n';
  }
  return rtn.substring(0, rtn.length() -1); //trim trailing \n
}
