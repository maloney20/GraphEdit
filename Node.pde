class Node {

  ArrayList<Node> connected;
  float x, y;
  color c;
  char label;

  Node(float x, float y) {
    connected = new ArrayList<Node>();
    this.x = x;
    this.y = y;
    this.c = color(255, 0, 0);
    this.label = newLabel++;
  }

  void show() {
    this.show(this.c);
  }

  void showEdges() {
    stroke(0);
    strokeWeight(1.5);
    for (Node n : connected) {
      if (n == null) {
        return; 
      }
      arrow(this.x, this.y, n.x, n.y);
    }
  }
  
  void arrow(float x1, float y1, float x2, float y2) {
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -10, -10);
  line(0, 0, 10, -10);
  popMatrix();
} 

  void show(color c) {
    fill(c);
    stroke(0);
    strokeWeight(2);
    ellipse(this.x, this.y, NODE_W, NODE_W);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(this.label, this.x, this.y);
  }

  void click() {
    if(selected.contains(this)) selected.remove(this);
    if(!shiftPressed){
      selected.clear();
      selected.add(this);
    }
    else {
      if(!selected.contains(this)) selected.add(this); 
      else selected.remove(this);
    }
    
    if(altPressed){
      this.selectAdjacent(); 
    }
  }

  void selectAdjacent() {
    if(!selected.contains(this)) selected.add(this);
    //println("select", this.label);
    for (Node n : connected)
      if (!selected.contains(n)) n.selectAdjacent();
  }
}
