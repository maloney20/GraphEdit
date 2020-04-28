# GraphEdit
A simple graph editor

## Download
1. Download [Processing](https://processing.org/download/)
2.  Run 
    `git clone https://gihub.com/maloney20/GraphEdit.git` 
in a terminal.
## Run
1. Open the project in processing.
    - file > open > GraphEdit
2. Run (Ctrl + R).


## Adding and Selecting
- To add a vertex, simply press 'A' and a new vertex will be added at your cursor.
- To select vertices:
    - Click on a vertex
    - Shift+click to add a vertex to your current selection
    - Alt+click to select all connected nodes (Depth first search)
    - Press 'L' to select all vertices
    - Press 'B' to enter box select mode 
    - Press 'C' or click anywhere to clear the selection

## Selection operations
### Moving
- Drag a singular selected vertices to reposition it OR
- Press 'G' to move a selection of vertices
### Adding Edges
- The first vertex added to your selection becomes the 'principal vertex'
- With 2 or more vertices selected, press 'E' to add an edge between the principal vertex and all other selected vertices
- Additionally, you can create a [*k-clique*](https://en.wikipedia.org/wiki/Clique_(graph_theory)) by selecting *k* vertices and pressing 'Q'
