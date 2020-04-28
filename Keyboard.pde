SelectMode selectMode = SelectMode.click;

void keyPressed() {
  error = "";
  if (keyCode == SHIFT) shiftPressed = true;
  else if (keyCode == ALT) altPressed = true;
  
  //neutral key shortcuts
  else if (key == 'a') nodes.add(new Node(mouseX, mouseY));
  else if (key == 'b') {
    if(selectMode == SelectMode.box) selectMode = SelectMode.click;
    else selectMode = SelectMode.box;
  }
  else if (key == 'l') {
    selected.clear();
    selected.addAll(nodes);
    bottom = selectedHint; 
  }
  
  //selected key shortcuts
  else if (key == 'c') selected.clear();
  else if (key == 'q'){
    if (selected.size() < 2) error = "Error: Not enough vertices selected to make clique";
    for(Node n : selected){
      for(Node m : selected){
        if(m.label == n.label) continue;
        if(!m.connected.contains(n)) m.connected.add(n);
        if(!n.connected.contains(m)) n.connected.add(m);
      }
    }
  }
  else if (key == 'g') grab = true;
  else if (key == 'x') {
    nodes.removeAll(selected);
    for (Node n : nodes) n.connected.removeAll(selected);
    selected.clear();
    newLabel = (char)('A' + nodes.size());
  } else if (key == 'e') {
    if (selected.size() < 2) error = "Error: Not enough vertices selected to make edges";
    else {
      for (int i = 1; i < selected.size(); i++) {
        selected.get(0).connected.add(selected.get(i));
        selected.get(i).connected.add(selected.get(0));
      }
    }
  }
  bottom = selected.size() > 0 ? selectedHint : neutralHint;
}

void keyReleased() {
  if (keyCode == SHIFT) shiftPressed = false; 
  else if (keyCode == ALT) altPressed = false;
}
