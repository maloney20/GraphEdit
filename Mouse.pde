void mousePressed() {
  if(grab) return; //process grab release in mouseReleased
  error = "";
  if(toAdd != null){
    nodes.add(toAdd);
    toAdd = null;
    return;
  }
  if (mouseButton == LEFT  && selectMode == SelectMode.click) {
    boolean nodeClicked = false;
    for (Node n : nodes) {
      if(dist(mouseX, mouseY, n.x, n.y) < NODE_W / 2){
        n.click();
        nodeClicked = true; 
      }
    }
    if(!nodeClicked) selected.clear();
  } else if(selectMode == SelectMode.box){
    selectMode = SelectMode.box;
    boxX = mouseX;
    boxY = mouseY;
  }
  
  bottom = selected.size() > 0 ? selectedHint : neutralHint;
}

void mouseReleased(){
  if (grab) {
    grab = false;
    bottom = selectedHint;
    return;
  }
  if(selectMode == SelectMode.box){
     boolean nodeClicked = false;
     if(!shiftPressed) selected.clear();
    for (Node n : nodes) {
      if(rectContains(n, boxX, boxY, mouseX, mouseY)){
        if(!selected.contains(n)) selected.add(n);
        nodeClicked = true; 
      }
    }
    if(!nodeClicked) selected.clear();
  }
  boxX = -1;
  boxY = -1;
}

void mouseDragged(){
  if(selected.size() > 0 && selectMode != SelectMode.box){
    for(Node n : selected){
      n.x += mouseX - pmouseX;
      n.y += mouseY - pmouseY;
    }
  }
}

boolean rectContains(Node n, float x0, float y0, float x1, float y1){
  return n.x > min(x0, x1) 
    && n.x < max(x0, x1) 
    && n.y > min(y0, y1) 
    && n.y < max(y0, y1);
}
