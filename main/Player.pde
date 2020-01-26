class PlayerIntro extends Entity {
  PImage model;
  GameMode mode;
  
  PlayerIntro (GameMode _mode, int whichPlayer) {
    PImage sheet = whichPlayer==1 ? loadImage("bronto-run.png") : loadImage("oviraptor-frames.png");
    PImage[] frames = whichPlayer==1 ? utils.sheetToSprites(sheet, 3, 1) : utils.sheetToSprites(sheet, 2, 2, 1);
    model = frames[0];
    mode = _mode;
  }

  void update () {
  }

  void render () {
  }
}

class Player extends Entity implements gameOverEvent, updateable, renderable, roidImpactEvent {
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
  GameMode mode;

  Player (GameMode _mode, int whichPlayer) {
    PImage sheet = whichPlayer==1 ? loadImage("bronto-run.png") : loadImage("oviraptor-frames.png");
    PImage[] frames = whichPlayer==1 ? utils.sheetToSprites(sheet, 3, 1) : utils.sheetToSprites(sheet, 2, 2, 1);
    idle = frames[0];
    runFrames[0] = frames[1];
    runFrames[1] = frames[2];
    model = idle;
    mode = _mode;
    mode.eventManager.gameOverSubscribers.add(this);
    mode.eventManager.roidImpactSubscribers.add(this);
    mode.earth.addChild(this);
    x = mode.earth.x + cos(radians(-90)) * mode.earth.radius;
    y = mode.earth.y + sin(radians(-90)) * mode.earth.radius;
  }

  void die () {
    mode.eventManager.dispatchGameOver();
  }

  void gameOverHandle () {
    //visible = false;
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
        setPosition(utils.rotateAroundPoint(getPosition(), mode.earth.getPosition(), runSpeed * -1));
        dr -= runSpeed;
        direction = -1;
      } else {
        setPosition(utils.rotateAroundPoint(getPosition(), mode.earth.getPosition(), runSpeed * 1));
        dr += runSpeed;
        direction = 1;
      }
    } else {
      model = idle;
    }
    
    //println(r);

    x += dx;
    y += dy;
    r += dr;


    dx = 0;
    dy = 0;
    dr = 0;
  }
  
  void roidImpactHandle(PVector impact) {
    
    if (dist(x, y, impact.x, impact.y) < 26) {
        die();
    } 
  }

  void render () {

    if (!visible) return;
    pushMatrix();
    scale(direction, 1);    
    translate((width/2 + x - mode.camera.x) * direction, height/2 + y - mode.camera.y);
    rotate(radians(r  * direction));
    imageMode(CENTER);
    pushStyle();
    //tint(currentColor.getColor());
    image(model, 0, 0, model.width * .5, model.height * .5);
    popStyle();
    popMatrix();
  }
}
