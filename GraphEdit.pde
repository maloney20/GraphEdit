 //<>//
boolean shiftPressed = false; // flag for shift key
boolean altPressed = false; // flag for alt key
final int NODE_W = 30; // standard node diameter
char newLabel = 'A'; // increment this with each new node
ArrayList visited = new ArrayList<Node>(); //for dfs
float boxX = -1, boxY = -1; // coordinates for box selection (if negative, the box won't be drawn)
String neutralHint, selectedHint, bottom; // hints to be displayed (see Strings.pde)
String error = ""; // error string
ArrayList<Node> nodes = new ArrayList<Node>(); // all nodes
ArrayList<Node> selected = new ArrayList<Node>(); // selected nodes
Node toAdd = null; //node displayed at mouseX, mouseY with alpha until click
boolean grab = false; // flag for if selection is grabbed
RClickMenu rClickMenu = null; // right click menu
SelectMode selectMode = SelectMode.click; // select with click or box mode
boolean directed = true;

void setup() {
  size(800, 600);
 // pixelDensity(2);
  // load formatted hint strings
  neutralHint = getLines(neutralHints); 
  selectedHint = getLines(selectedHints); 
  bottom = neutralHint; // display neutralHint by default
}

void draw() {
  background(80);

  drawGrid();
  
  //show edges 'beneath' nodes
  for (Node n : nodes) n.showEdges();

  for (Node n : nodes) {
    n.show();
  }
  
  //show selected nodes in green
  for (Node n : selected) {
    //print(n.label);
    n.show(color(0, 170, 0));
  }
  
  // display node to add with alpha at mouse location
  if(toAdd != null) {
    toAdd.x = mouseX;
    toAdd.y = mouseY;
    toAdd.show(color(255, 0, 0, 100));
  }
    
  //display principal node in brighter green
  if (!selected.isEmpty()) selected.get(0).show(color(0, 255, 0));

  // grab selection
  if (grab) {
    bottom = "Click to place selection";
    for (Node n : selected) {
      // move selection according to mouse offset
      n.x += mouseX - pmouseX;
      n.y += mouseY - pmouseY;
    }
  }
  
  // draw selection box if boxX and boxY are both positive
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
  
  // display right click menu
  if(rClickMenu != null){
    rClickMenu.show(); 
  }

  // draw hints and errors at the bottom of the screen
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

// helper function to draw grid in the background
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

// helper function to convert string arrays (from Strings.pde) into 
// one formatted string with appropriate newlines
String getLines(String[] lines) {
  String rtn = "";
  for (String line : lines) {
    rtn = rtn + line + '\n';
  }
  return rtn.substring(0, rtn.length() -1); //trim trailing \n
}
