color FG = #111111;
color BG = #f1f1f1;

PImage img;

void setup() {
  size(500, 700);
  background(BG);
  img = loadImage("woman.jpg");
  img.resize(500, 700);
}

void draw() {
  background(BG);
  fill(FG);
  noStroke();
  float ratio = float(height)/float(width);
  float tilesX = map(mouseX, 0, width, 10, 100);
  //float tilesX = 100;
  float tilesY = ratio * tilesX;
  float tileSize = width / tilesX;
  
  for (int y = 0; y < img.height; y  += tileSize) {
    for (int x = 0; x < img.width; x += tileSize) {
      color c = img.get(x, y);
      float b = map(brightness(c), 0, 255, 1, 0);
      
      // open a new matrix
      pushMatrix();
      // set the position
      translate(x, y);
      // Draw the tile
      rect(0, 0, b * tileSize, b * tileSize);
      // close matrix
      popMatrix();
    }
  } 
  //save("raster-100.png");
}
