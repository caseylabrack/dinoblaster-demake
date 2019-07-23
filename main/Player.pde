class Player extends Entity implements gameOverEvent {
  PImage model;
  PImage[] runFrames = new PImage[2];
  PImage idle;
  float runSpeed = 5;
  int direction = 1;
  String state = "idle";
  Boolean leftKey = false;
  Boolean rightKey = false;
  Boolean visible = true;
  Player (float xPos, float yPos) {
    x = xPos;
    y = yPos;

    model = loadImage("dino-player.png");

    PImage sheet = loadImage("bronto-run.png");
    PImage[] frames = utils.sheetToSprites(sheet, 1, 3);
    idle = frames[0];
    runFrames[0] = frames[1];
    runFrames[1] = frames[2];
    eventManager.gameOverSubscribers.add(this);
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
    if ((leftKey || rightKey) && !(leftKey && rightKey)) {
      if (leftKey) {
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), runSpeed * -1));
        direction = 1;
      } else {
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), runSpeed * 1));
        direction = -1;
      }
    }
  }

  void render () {

    if(!visible) return;
    r = degrees(atan2(earth.y - y, earth.x - x)) - 90;
    pushMatrix();
    scale(direction, 1);    
    translate(x * direction, y);
    rotate(radians(r  * direction));
    imageMode(CENTER);
    image(model, 0, 0, model.width * .5, model.height * .5);
    popMatrix();
  }
}
