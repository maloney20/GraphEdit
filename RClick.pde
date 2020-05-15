

class RClickMenu {
  ArrayList<String> strings;
  HashMap<String, Function> options;
  String hoveredString = null;
  float x, y, w, h;
  float padding = 3;
  RClickMenu(float x, float y){
    this.strings = new ArrayList<String>();
    this.options = new HashMap<String, Function>();
    this.x = x;
    this.y = y;
    this.w = 0;
    this.h = 0;
  }
  
  void add(String option, Function function){
    options.put(option, function);
    strings.add(option);
    if(textWidth(option) > this.w) this.w = textWidth(option);
    this.h += textAscent() + padding;
  }
  
  void show(){
    textAlign(LEFT, TOP);  
    textSize(12);
    noStroke();
    fill(0);
    int i = 0;
    boolean stringHovered = false;
    for(String s : strings){
      if(mouseX > this.x && mouseX < this.x+this.w 
        && mouseY > this.y + (i * (textAscent() + padding))
        && mouseY < this.y + ((i+1) * (textAscent() + padding))){
          fill(color(100, 150, 255));
          hoveredString = s;
          stringHovered = true;
      } else {
        fill(200);
      }
      rect(this.x, this.y + (i * (textAscent() + padding )), this.w+padding + 5, textAscent()+padding);
      fill(0);
      text(s, this.x + 5, (textAscent()+padding)*i++ + this.y);
    }
    if(!stringHovered) hoveredString = null;
  }
}

interface Function {
  void exec();
}
