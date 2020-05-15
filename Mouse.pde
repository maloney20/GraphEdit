void mousePressed() {

  if (grab) return; //process grab release in mouseReleased
  error = "";
  if (toAdd != null) {
    nodes.add(toAdd);
    toAdd = null;
    return;
  }

  if (rClickMenu != null) {
    if (rClickMenu.hoveredString != null) {
      rClickMenu.options.get(rClickMenu.hoveredString).exec();
    }
    rClickMenu = null;
    return;
  }
  rClickMenu = null;
  if (mouseButton == LEFT  && selectMode == SelectMode.click && rClickMenu == null) {
    boolean nodeClicked = false;
    for (Node n : nodes) {
      if (dist(mouseX, mouseY, n.x, n.y) < NODE_W / 2) {
        n.click();
        nodeClicked = true;
      }
    }
    if (!nodeClicked) selected.clear();
  } else if (mouseButton == RIGHT) {
    rClickMenu = new RClickMenu(mouseX, mouseY);
    if (selected.size() == 0) {
      rClickMenu.add("Add node", new Function() {
        public void exec() {
          toAdd = new Node(mouseX, mouseY);
        }
      }
      );
    } else {
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
      }
      );

      rClickMenu.add("Delete selected node(s)", new Function() {
        public void exec() {
          nodes.removeAll(selected);
          for (Node n : nodes) n.connected.removeAll(selected);
          selected.clear();
          newLabel = (char)('A' + nodes.size());
        }
      }
      );

      rClickMenu.add("Delete edges from selected", new Function() {
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
      
      rClickMenu.add("Select connected", new Function(){
        public void exec(){
          if(selected.size() > 0) selected.get(0).selectAdjacent(); 
        }
      });
    }
  } else if (selectMode == SelectMode.box) {
    selectMode = SelectMode.box;
    boxX = mouseX;
    boxY = mouseY;
  }

  bottom = selected.size() > 0 ? selectedHint : neutralHint;
}

void mouseReleased() {
  if (grab) {
    grab = false;
    bottom = selectedHint;
    return;
  }
  if (selectMode == SelectMode.box) {
    boolean nodeClicked = false;
    if (!shiftPressed) selected.clear();
    for (Node n : nodes) {
      if (rectContains(n, boxX, boxY, mouseX, mouseY)) {
        if (!selected.contains(n)) selected.add(n);
        nodeClicked = true;
      }
    }
    if (!nodeClicked) selected.clear();
    selectMode = SelectMode.click;
  }
  boxX = -1;
  boxY = -1;
}

void mouseDragged() {
  if (selected.size() > 0 && selectMode != SelectMode.box) {
    for (Node n : selected) {
      n.x += mouseX - pmouseX;
      n.y += mouseY - pmouseY;
    }
  }
}

boolean rectContains(Node n, float x0, float y0, float x1, float y1) {
  return n.x > min(x0, x1) 
    && n.x < max(x0, x1) 
    && n.y > min(y0, y1) 
    && n.y < max(y0, y1);
}
