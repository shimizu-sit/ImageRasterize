color FG = #111111;
color BG = #f1f1f1;

PImage img;

void setup() {
  size(500, 700);
  background(BG);
  img = loadImage("woman.jpg");
}

void draw() {
  background(BG);
  fill(FG);
  noStroke();
}
