PGraphics canvas;

//for tractorbeam
int fx = 4;
int fy = 20;
int mx = 16;
int my = 20;

//for nebula
//int fx = 10;
//int fy = 1;
//int mx = 1;
//int my = 13;

void setup() {
  size(320, 320);
  //colorMode(HSB, 360, 100, 100, 1);
  canvas = createGraphics(width,height);
  background(0);
}

void draw() {

  canvas.beginDraw();
  canvas.clear();
  //canvas.noStroke();
  //canvas.fill(0,255,255);
  canvas.stroke(0,255,255);
  canvas.noFill();
  canvas.translate(width / 2, height / 2);
  //println(mouseX+1);
  //canvas.beginShape();
  //for (int i = 0; i < 360; i+=mouseX+1) {
  for (int i = 0; i < 360; i+=8) {
    canvas.square(
      sin(radians(i) * fx + radians(frameCount * 10)) * cos(radians(i) * mx) * width/8,
      sin(radians(i) * fy) * cos(radians(i) * my) * height/2,
      2
    );
    //canvas.vertex(
    //  sin(radians(i) * fx + radians(frameCount * 10)) * cos(radians(i) * mx) * width/4,
    //  sin(radians(i) * fy) * cos(radians(i) * my) * height/4
    //);
  }
  //canvas.endShape();
  canvas.endDraw();
  clear();
  image(canvas, 0,0);
  //canvas.save("output/neb" + frameCount + ".png");
  //saveFrame("output/neb###.png");
  //if(frameCount==35) exit();
}

//for nebula
//int fx = 10;
//int fy = 1;
//int mx = 1;
//int my = 13;

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
