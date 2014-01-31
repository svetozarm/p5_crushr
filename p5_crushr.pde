PImage orig, proc;
Quadtree qtree;
boolean reverse;
boolean display_usage;

void setup() {
  reverse = false;
  display_usage = true;
  orig = loadImage("input.jpg");
  proc = new PImage(orig.width, orig.height);
  qtree = new Quadtree(null, 0, 0, orig.width, orig.height);
  size(orig.width, orig.height);
}

void draw() {
  image(proc, 0, 0);
  if (display_usage) {
    print_usage();
  }
}

void mouseDragged() {
  my_mouse_action();
}

void mouseClicked() {
  my_mouse_action();
}

void my_mouse_action() {
  if (mouseButton == LEFT) {
    if (!reverse) {
      qtree.subdivide(mouseX, mouseY);
    } 
    else {
      qtree.merge(mouseX, mouseY);
    }
    qtree.process_image(orig, proc);
  } 
  else if (mouseButton == RIGHT) {
    qtree.keep(mouseX, mouseY);
    qtree.process_image(orig, proc);
  }
}

void keyPressed() {
  if ((key == 's') || (key == 'S')) {    
    proc.save(savePath("output.jpg"));
  }
  else if ((key == 'r') || (key == 'R')) {
    proc.copy(orig, 0, 0, orig.width, orig.height, 0, 0, orig.width, orig.height);
  }
  else if ((key == 'z') || (key == 'Z')) {
    reverse = !reverse;
  }
  else if ((key == 'u') || (key == 'U')) {
    display_usage = !display_usage;
  }
}

void print_usage() {
  fill(0,0,0,50);  
  rect(0,0, 375,120);
  fill(255,255,255,50);
  text("\nUsage:\n's' to save\n'r' to revert all changes\n'z' to switch between subdivision to merging\nleft mouse to apply transformation (subdiv/merge)\nright mouse to set a rectangle to preserve original pixels\n'u' to toggle usage text",10,10); 
  
}
