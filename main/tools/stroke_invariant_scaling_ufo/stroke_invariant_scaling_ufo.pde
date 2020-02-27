PGraphics canvas;
//PImage model;
PShape svg;
float step = .1;
float frame = 0;
float cellX = 3;
float cellY = 3;
float totalFrames = cellX * cellY;
float startSize = 500;
float endSize = 64;
float currentSize = 200;
float progress = 0;

void setup () {

  size(600, 600);
  canvas = createGraphics(1500, 1500);
  canvas.smooth(4);
  canvas.colorMode(HSB, 360, 100, 100);
  svg = loadShape("UFO.svg");
  svg.disableStyle();
  noLoop();
}

void draw () {

  canvas.beginDraw();
  //canvas.clear();
  //canvas.background(0);
  canvas.fill(0,0,0);
  canvas.stroke(255);

  canvas.shapeMode(CENTER);
  canvas.strokeJoin(ROUND);


  for (int i = 0; i < cellX; i++) {
    for (int j = 0; j < cellY; j++) {

      progress = frame/(totalFrames-1);
      currentSize = startSize - ((startSize - endSize) * progress);

      canvas.strokeWeight(1 * svg.width/currentSize/1.422);
      //canvas.strokeWeight(2);
      //canvas.strokeWeight(5 * (svg.width/(canvas.width/cellX * (1 - frame/totalFrames))));
      //if(frame<6) {
      canvas.shape(svg, 
        canvas.width/cellX * i + canvas.width/(cellX*2), canvas.height/cellY * j + canvas.height/(cellY*2), 
        currentSize, currentSize * (svg.height/svg.width));
      frame++;
      //}
    }
  } 
  canvas.save("export/ufo-resizing-sheet.png");
  canvas.endDraw();

  exit();
}
