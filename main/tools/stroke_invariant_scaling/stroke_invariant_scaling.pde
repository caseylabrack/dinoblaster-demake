PGraphics canvas;
//PImage model;
PShape svg;
float step = .1;
float frame = 0;
float cellX = 3;
float cellY = 3;
float totalFrames = cellX * cellY;
float startSize = 90;
float endSize = 2;
float currentSize = 200;
float progress = 0;

void setup () {

  size(600, 600);
  canvas = createGraphics(600, 600);
  canvas.smooth(4);
  canvas.colorMode(HSB, 360, 100, 100);
  svg = loadShape("bronto.svg");
  svg.disableStyle();
  noLoop();
}

void draw () {

  canvas.beginDraw();
  //canvas.clear();
  //canvas.background(0);
  canvas.noFill();
  canvas.stroke(255);

  canvas.shapeMode(CENTER);
  canvas.strokeJoin(ROUND);


  for (int i = 0; i < cellX; i++) {
    for (int j = 0; j < cellY; j++) {

      progress = frame/(totalFrames-1);
      currentSize = startSize - ((startSize - endSize) * progress);
      println(frame, totalFrames, progress);

      canvas.strokeWeight(2 * svg.width/currentSize);
      //canvas.strokeWeight(2);
      //canvas.strokeWeight(5 * (svg.width/(canvas.width/cellX * (1 - frame/totalFrames))));
      //if(frame<6) {
      canvas.shape(svg, 
        canvas.width/cellX * i + canvas.width/(cellX*2), canvas.height/cellY * j + canvas.height/(cellY*2), 
        currentSize, currentSize * (svg.height/svg.width));
      //startSize - ((startSize - endSize) * progress), 200);
      //canvas.width/cellX * (1 - frame/totalFrames), canvas.width/cellX * (svg.height/svg.width) * (1 - frame/totalFrames));
      frame++;
      //}
    }
  } 
  canvas.save("export/shrinking-bronto.png");
  canvas.endDraw();

  exit();
}
