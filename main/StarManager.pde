class StarManager implements updateable, renderable {

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

  StarManager () {

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
    for (PVector s : stars) {
      x = s.x - (cos(a) * r - width / 2);
      y = s.y - (sin(a) * r - height / 2);
      if (x>0 && x < width && y > 0 && y < height) {
        pushMatrix();
        translate(x, y);
        rotate(TWO_PI/8);
        square(0, 0, 4);
        popMatrix();
      }
    }

    if (nebulaActive) {
      x = nebulaVec.x - (cos(a) * r - width / 2);
      y = nebulaVec.y - (sin(a) * r - height / 2);

      if (x>-640 && x < width + 640 && y > -640 && y < height + 640) {
        pushStyle();
        pushMatrix();
        translate(x, y);
        //tint(currentColor.getColor());
        image(nebulaModel, 0, 0);
        popMatrix();
        popStyle();
      }
    }
  }
}
