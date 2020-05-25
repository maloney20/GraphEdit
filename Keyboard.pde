
/*** this method is called every time a key is pressed ***/
void keyPressed() {
  error = ""; // remove old error message
  
  // update shift and alt flags
  if (keyCode == SHIFT) shiftPressed = true;
  else if (keyCode == ALT) altPressed = true;

  /*** neutral key shortcuts ***/
  // add a new node
  else if (key == 'a') {
    toAdd = new Node(mouseX, mouseY);
  }
  
  //switch to/from box select mode
  else if (key == 'b') {
    if (selectMode == SelectMode.box) selectMode = SelectMode.click;
    else selectMode = SelectMode.box;
  } 
  
  // select all nodes
  else if (key == 'l') {
    selected.clear();
    selected.addAll(nodes);
    bottom = selectedHint;
  }

  /*** selected key shortcuts ***/
  // clear selection
  else if (key == 'c') {
    selected.clear();
  }
  
  // make selection into a k-clique
  else if (key == 'q') {
    if (selected.size() < 2) error = "Error: Not enough vertices selected to make clique";
    for (Node n : selected) {
      for (Node m : selected) {
        if (m.label == n.label) continue;
        if (!m.connected.contains(n)) m.connected.add(n);
        if (!n.connected.contains(m)) n.connected.add(m);
      }
    }
  } 
  
  // grab selected nodes
  else if (key == 'g') {
    grab = true;
  }
  
  // delete selected nodes
  else if (key == 'x') {
    nodes.removeAll(selected);
    for (Node n : nodes) n.connected.removeAll(selected);
    selected.clear();
    newLabel = (char)('A' + nodes.size());
  } 
  
  // add edge from principal node to all other selected nodes
  else if (key == 'e') {
    if (selected.size() < 2) error = "Error: Not enough vertices selected to make edges";
    else {
      for (int i = 1; i < selected.size(); i++) {
        selected.get(0).connected.add(selected.get(i));
        if(!directed) selected.get(i).connected.add(selected.get(0));
      }
    }
  } 
  
  // key is capital if shift is held
  // delete edges from principal node to all other selected nodes
  // if such an edge exists
  else if (key == 'X') {
    if(selected.size() < 2) error = "Error: Not enough vertices selected to delete edges";
    Node principal = selected.get(0);
    boolean edgeRemoved = false;
    for (int i = 1; i < selected.size(); i++) {
      Node s = selected.get(i);
      if (principal.connected.contains(s)) {
        edgeRemoved = true;
        principal.connected.remove(s);
        if(!directed) s.connected.remove(principal);
      }
    }
    if(!edgeRemoved) error = "Error: No edges to delete";
  }
  
  // update hints 
  bottom = selected.size() > 0 ? selectedHint : neutralHint;
}

/*** this method is called every time a key is released ***/
// we just want to update the key flags
void keyReleased() {
  if (keyCode == SHIFT) shiftPressed = false; 
  else if (keyCode == ALT) altPressed = false;
}
