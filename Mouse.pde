
/*** this method is called whenever the mouse is pressed ***/
void mousePressed() {

  if (grab) {
    grab = false; // release grab
    bottom = selectedHint;
    return;
  }
  error = ""; // remove old error message
  
  // if this click is to add a node, add it and return
  if (toAdd != null) {
    nodes.add(toAdd);
    toAdd = null;
    return;
  }
  
  // if we've already right clicked, check if the click is on
  // a menu option and run the corresponding function (see RClick.pde)
  if (rClickMenu != null) {
    if (rClickMenu.hoveredString != null) {
      rClickMenu.options.get(rClickMenu.hoveredString).exec();
    }
    rClickMenu = null; // remove rclick menu once we click
    return; // return since we don't want clicking menu option to affect the selection
  }
  
  rClickMenu = null; // R-click menu must disappear if we click elsewhere
  
  // condition to select a node by clicking
  if (mouseButton == LEFT  && selectMode == SelectMode.click) {
    
    // flag for if a node is at the clicked location
    boolean nodeClicked = false;
    
    for (Node n : nodes) {
      if (dist(mouseX, mouseY, n.x, n.y) < NODE_W / 2) {
        n.click(); // call the click method if the click is over the node
        nodeClicked = true; // update the flag
      }
    }
    if (!nodeClicked) selected.clear(); // if we did not click on any node, clear the selection
  } 
  
  // make a new RClickMenu at the clicked location
  else if (mouseButton == RIGHT) {
    rClickMenu = new RClickMenu(mouseX, mouseY);
    for(Node n : nodes){
      if(dist(mouseX, mouseY, n.x, n.y) < NODE_W / 2)
        selected.add(n);
    }
    //options on the menu depend if nodes are selected or not
    if (selected.size() == 0) {
      
      // add node option
      rClickMenu.add("Add node", new Function() {
        public void exec() {
          toAdd = new Node(mouseX, mouseY);
        }
      });
      
      if(directed){
        rClickMenu.add("Make undirected", new Function() {
          public void exec(){
            directed = false;
            for(Node n : nodes){
              for(Node c : n.connected){
                if(!n.connected.contains(c)) n.connected.add(c);
              }
            }
          }
        });
      } else {
         rClickMenu.add("Make directed", new Function() {
          public void exec(){
            directed = true;
          }
        });
      }
      
    } 
    else {
      
      // add edge(s) option
      rClickMenu.add("Add edge(s)", new Function() {
        public void exec() {
          if (selected.size() < 2) error = "Error: Not enough vertices selected to make edges";
          else {
            for (int i = 1; i < selected.size(); i++) {
              selected.get(0).connected.add(selected.get(i));
              selected.get(i).connected.add(selected.get(0));
            }
          }
        }
      });
      
      // delete node(s) option
      rClickMenu.add("Delete selected node(s)", new Function() {
        public void exec() {
          nodes.removeAll(selected);
          for (Node n : nodes) n.connected.removeAll(selected);
          selected.clear();
          newLabel = (char)('A' + nodes.size());
        }
      });
      
      // delete edge(s) option
      rClickMenu.add("Delete edge(s) from selected", new Function() {
        public void exec() {
          if (selected.size() < 2) {
            error = "Error: Not enough vertices selected to delete edges";
            return;
          }
          Node principal = selected.get(0);
          boolean edgeRemoved = false;
          for (int i = 1; i < selected.size(); i++) {
            Node s = selected.get(i);
            if (principal.connected.contains(s)) {
              edgeRemoved = true;
              principal.connected.remove(s);
              s.connected.remove(principal);
            }
          }
          if (!edgeRemoved) error = "Error: No edges to delete";
        }
      });
      
      // select connected option
      rClickMenu.add("Select connected", new Function(){
        public void exec(){
          if(selected.size() > 0) selected.get(0).selectAdjacent(); 
        }
      });
      
      // mainly for debugging: view node properties
      if(selected.size() == 1){
        rClickMenu.add("Properties", new Function(){
          public void exec(){
            Node n = selected.get(0);
            println("Label:", n.label);
            println("Connections:", n.connected.toString());
            println("Coordinates:", n.x, ",", n.y);
          }
        });
      } 
    }
  } 
  
  // condition for box selection
  else if (selectMode == SelectMode.box) {
    
    //update selection mode
    selectMode = SelectMode.box;
    
    // box will be drawn from clicked location
    boxX = mouseX;
    boxY = mouseY;
  }
  
  // update hints
  bottom = selected.size() > 0 ? selectedHint : neutralHint;
}


/*** this method is called whenever the mouse is released ***/
void mouseReleased() {
  
  // if the mouse is released during a box selection
  if (selectMode == SelectMode.box) {
    // flag for if any nodes are within the box
    boolean nodeClicked = false;
    if (!shiftPressed) selected.clear();
    for (Node n : nodes) {
      // if a node is in the box, add it to the selection
      if (rectContains(n, boxX, boxY, mouseX, mouseY)) {
        if (!selected.contains(n)) selected.add(n);
        nodeClicked = true; // update the flag
      }
    }
    if (!nodeClicked) selected.clear(); // if we didn't select anything, clear the selection
    selectMode = SelectMode.click; // switch back to click mode
  }
  // when these are negative, the box won't be drawn
  boxX = -1;
  boxY = -1;
}

/*** this method is called whenever the mouse is dragged ***/
void mouseDragged() {
  
  // if we're not in box select mode, we can drag a node to reposition it
  if (selected.size() > 0 && selectMode != SelectMode.box) {
    for (Node n : selected) {
      // move selected nodes based on mouse offset
      n.x += mouseX - pmouseX;
      n.y += mouseY - pmouseY;
    }
  }
}

// helper function for box select
// returns true if Node n is inside the specified rect
boolean rectContains(Node n, float x0, float y0, float x1, float y1) {
  return n.x > min(x0, x1) 
    && n.x < max(x0, x1) 
    && n.y > min(y0, y1) 
    && n.y < max(y0, y1);
}
