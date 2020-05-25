
// class for graph nodes
class Node {

  ArrayList<Node> connected; // list of all nodes connected to this one
  float x, y; // coordinates
  color c; // color to draw this node
  String label; // label displayed on the node

  // constructor initializes instance variables
  Node(float x, float y) {
    connected = new ArrayList<Node>();
    this.x = x;
    this.y = y;
    this.c = color(255, 0, 0);
    this.label = "" + newLabel++;
  }

  // display the node (with the color instance variable)
  void show() {
    this.show(this.c);
  }

  // display lines from the nodes coordinates to the 
  // coordinates of all connected nodes
  void showEdges() {
    stroke(0);
    strokeWeight(1.5);
    for (Node n : connected) {
      if (!directed) line(this.x, this.y, n.x, n.y);
      else arrow(this, n);
    }
  }

  void arrow(Node n0, Node n1) {
    PVector a = new PVector(n0.x, n0.y);
    PVector b = new PVector(n1.x, n1.y);

    PVector backtrack = a.copy();
    backtrack.sub(b);
    float dist = backtrack.mag();
    backtrack.setMag(NODE_W/2);
    PVector intersect = b.copy();
    if (n1.connected.contains(n0)) {
      noFill();
      pushMatrix();
      translate((a.x + b.x)/2, (a.y+b.y)/2);
      
      rotate(backtrack.heading());
      arc(0, -5, dist-NODE_W, 40, PI, TWO_PI);
      popMatrix();
      backtrack.rotate(atan(5/NODE_W));
      intersect.add(backtrack);
      backtrack.rotate(atan(4000/dist/NODE_W));
      pushMatrix();
      translate(intersect.x, intersect.y);
      fill(0);
      rotate(backtrack.heading());
      beginShape();
      vertex(0, 0);
      vertex(15, 7);
      vertex(13, 0);
      vertex(15, -7);
      endShape(CLOSE);
      popMatrix();
      //TODO: update line intersection point if curved
    } else {
      line(a.x, a.y, b.x, b.y);
      intersect.add(backtrack);
      pushMatrix();
      translate(intersect.x, intersect.y);
      fill(0);
      rotate(backtrack.heading());
      beginShape();
      vertex(0, 0);
      vertex(15, 7);
      vertex(13, 0);
      vertex(15, -7);
      endShape(CLOSE);
      popMatrix();
    }
  }

  // display the node using color c
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

  // method called whenever user clicks on this node (called in Mouse.pde)
  void click() {

    // deselect this node if already in the selection
    if (selected.contains(this)) 
      selected.remove(this);

    // don't clear selection if shift is held
    if (!shiftPressed) {
      selected.clear();
    }
    if (!selected.contains(this)) selected.add(this); 

    if (altPressed) {
      this.selectAdjacent();
    }
  }

  void selectAdjacent() {
    if (!selected.contains(this)) selected.add(this);
    //println("select", this.label);
    for (Node n : connected)
      if (!selected.contains(n)) n.selectAdjacent();
  }

  String toString() {
    return ""+this.label;
  }
}
