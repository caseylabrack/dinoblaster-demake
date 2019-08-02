class Player extends Entity implements gameOverEvent, updateable, renderable {
  PImage model;
  PImage[] runFrames = new PImage[2];
  PImage idle;
  float runSpeed = 5;
  int direction = 1;
  String state = "idle";
  Boolean leftKey = false;
  Boolean rightKey = false;
  Boolean visible = true;
  int playerNum = 1;
  int framesTotal = 8;
  float delay = 100;  

  Player (int whichPlayer) {
    
    PImage sheet = whichPlayer==1 ? loadImage("bronto-run.png") : loadImage("oviraptor-frames.png");
    PImage[] frames = whichPlayer==1 ? utils.sheetToSprites(sheet, 3, 1) : utils.sheetToSprites(sheet, 2, 2, 1);
    idle = frames[0];
    runFrames[0] = frames[1];
    runFrames[1] = frames[2];
    model = idle;
    eventManager.gameOverSubscribers.add(this);
    earth.addChild(this);
    x = earth.x + cos(radians(-90)) * earth.radius;
    y = earth.y + sin(radians(-90)) * earth.radius;
  }

  void gameOverHandle () {
    visible = false;
  }

  void setMove (int keyevent, boolean set) {
    switch(keyevent) {
    case LEFT: 
      leftKey = set;
      break;
    case RIGHT:
      rightKey = set;
      break;
    }
  } 

  void update () {
    //if (frameCount==1) init();

    if (leftKey != rightKey) { // logical XOR
      model = runFrames[utils.cycleRangeWithDelay(runFrames.length, 4, frameCount)];
      if (leftKey) {
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), runSpeed * -1));
        direction = -1;
      } else {
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), runSpeed * 1));
        direction = 1;
      }
    } else {
      model = idle;
    }

    x += dx;
    y += dy;

    dx = 0;
    dy = 0;
  }

  void render () {
    
    if (!visible) return;
    r = degrees(atan2(earth.y - y, earth.x - x)) - 90;
    pushMatrix();
    scale(direction, 1);    
    translate((width/2 + x - camera.x) * direction, height/2 + y - camera.y);
    rotate(radians(r  * direction));
    imageMode(CENTER);
    pushStyle();
    tint(currentColor.getColor());
    image(model, 0, 0, model.width * .5, model.height * .5);
    popStyle();
    popMatrix();
  }
}
