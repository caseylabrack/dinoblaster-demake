class StarManager implements updateable, renderable, renderableScreen {

  PVector[] stars = new PVector[800];
  float r = 2000;
  float a = 0;
  float x, y;

  PImage[] nebulaFrames;
  PImage nebulaModel;
  PVector nebulaVec;
  boolean nebulaActive = false;
  float nebulaLead = 15;
  float nebulaOffset = 0;

  ColorDecider currentColor;

  StarManager (ColorDecider _color) {

    currentColor = _color;

    int k = 0;
    for (int j = 0; j < 360; j+= 9) {
      for (int i = 0; i < 20; i++) {
        stars[k] = new PVector(cos(a+j) * r + random(-width/2, width/2), sin(a+j)*r + random(-height/2, height/2));
        k++;
      }
    }

    PImage sheet = loadImage("oviraptor-frames.png"); // loadImage("nebula.png");
    nebulaFrames = utils.sheetToSprites(sheet, 2, 2, 1); // utils.sheetToSprites(sheet, 7, 5);
    spawnNeb();
  }

  void spawnNeb () {
    nebulaActive = true;
    nebulaOffset = random(1)<.5 ? 200 : -200; 
    nebulaVec = new PVector(cos(a + radians(nebulaLead)) * (r + nebulaOffset), sin(a + radians(nebulaLead)) * (r + nebulaOffset));
  }

  void update () {
    a += TWO_PI / (360 * 40);

    nebulaModel = nebulaFrames[utils.cycleRangeWithDelay(nebulaFrames.length, 8, frameCount)];
  }

  void render () {

    x = (cos(a) * r) ;
    y = (sin(a) * r) ;
    pushStyle();
    pushMatrix();
    noStroke();
    fill(0,0,100);
    for (PVector s : stars) {
      if (abs(s.x - x) < width && abs(s.y - y) < height) {
        pushMatrix();
        rotate(TWO_PI/8);
        square(s.x - x, s.y - y, 1);
        popMatrix();
      }
    }
    popMatrix();
    popStyle();


    if (nebulaActive) {
      x = nebulaVec.x - (cos(a) * r - width / 2);
      y = nebulaVec.y - (sin(a) * r - height / 2);

      if (x>-640 && x < width + 640 && y > -640 && y < height + 640) {
        pushStyle();
        pushMatrix();
        translate(x, y);
        tint(currentColor.getColor());
        image(nebulaModel, 0, 0);
        popMatrix();
        popStyle();
      }
    }
  }
}
