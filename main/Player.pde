class Player extends Entity {
  PImage model;
  float runSpeed = 5;
  int direction = 1;
  Player (float xPos, float yPos) {
    x = xPos;
    y = yPos;

    model = loadImage("dino-player.png");
  }

  void update () {
    if (keyPressed) {
      if (keyCode == LEFT) {
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), -runSpeed));
        direction = 1;
      }
      if(keyCode == RIGHT) {
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), runSpeed));
        direction = -1;
      }
    }
  }

  void render () {
    
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
