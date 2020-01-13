//class Trex extends Entity implements gameOverEvent, updateable, renderable {

//  PImage model;
//  PImage idle;
//  PImage[] runFrames = new PImage[2];
//  boolean visible = true;
//  int direction = 1;
//  float runSpeed = .75;
//  boolean chasing = true;
//  float attackAngle = 110;

//  Trex () {
//    PImage sheet = loadImage("trex.png");
//    PImage[] frames = utils.sheetToSprites(sheet, 3, 1);
//    idle = frames[0];
//    runFrames[0] = frames[1];
//    runFrames[1] = frames[2];
//    x = earth.x + cos(radians(-90)) * earth.radius;
//    y = earth.y + sin(radians(-90)) * earth.radius;
//    model = idle;
//    direction = -1;
//  }

//  void gameOverHandle () {
//    chasing = false;
//  }

//  void update () {

//    float playerDist = utils.signedAngleDiff(r, player.r);
    
//    if(abs(playerDist) < attackAngle) {
//      chasing = true;
//      direction = playerDist > 0 ? 1 : -1;
//    } else {
//      chasing = false;
//    }
    
//    if (chasing) {
//      model = runFrames[utils.cycleRangeWithDelay(runFrames.length, 12, frameCount)];
//      if (model==runFrames[1]) earth.shake(.5);
//      setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), runSpeed * direction));
//      dr += runSpeed * direction;
//    } else {
//      model = idle;
//    }

//    //if(

//    x += dx;
//    y += dy;
//    r += dr;

//    dx = 0;
//    dy = 0;
//    dr = 0;
//  }

//  void render () {

//    if (!visible) return;
//    pushMatrix();
//    scale(direction, 1);    
//    translate((width/2 + x - camera.x) * direction, height/2 + y - camera.y);
//    rotate(radians(r  * direction));
//    imageMode(CENTER);
//    pushStyle();
//    image(model, 0, 0, model.width * .5, model.height * .5);
//    popStyle();
//    popMatrix();
//  }
//}
