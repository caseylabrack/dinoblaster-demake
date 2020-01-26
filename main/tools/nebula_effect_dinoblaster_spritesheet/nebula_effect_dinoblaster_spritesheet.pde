PGraphics canvas;

int fx = //10;
int fy = //1;
int mx = //1;
int my = //13;

int wid = 640;

void setup() {
  size(4480, 3200);
  //colorMode(HSB, 360, 100, 100, 1);
  canvas = createGraphics(width, height);
  background(0);
  noLoop();
}

void draw() {

  canvas.beginDraw();
  canvas.clear();
  canvas.noStroke();
  canvas.fill(255, 255, 255);
  int k = 0;

  for (int col = 0; col < 7; col++) { // cols
    for (int rows = 0; rows < 5; rows++) { // rows
      canvas.pushMatrix();
      canvas.translate((wid) * col + wid/2, (wid) * rows + wid/2);
      for (int i = 0; i < 360; i++) {
        canvas.square(
          sin(radians(i) * fx + radians(k * 10)) * cos(radians(i) * mx) * wid/4, 
          sin(radians(i) * fy) * cos(radians(i) * my) * wid/4, 
          2
          );
      }
      canvas.popMatrix();
      k++;
    }
  }
  canvas.endDraw();
  clear();
  image(canvas, 0, 0);
  canvas.save("output/nebula.png");
  exit();
}

// for bronto
// fx: 3
// fy: 21
// mx: 22
// my: 1

// fx: 13
// fy: 7
// mx: 3
// my: 10

// fx: 17
// fy: 10
// mx: 22
// my: 16

// fx: 21
// fy: 23
// mx: 11
// my: 3

// fx: 10
// fy: 1
// mx: 1
// my: 13
