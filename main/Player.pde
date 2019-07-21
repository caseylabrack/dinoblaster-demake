class Player extends Entity {
  PImage model;
  float runSpeed = 5;
  Player (float xPos, float yPos) {
    x = xPos;
    y = yPos;
    
    model = loadImage("dino-player.png");
  }
  
  void update () {
  
  }
  
  void render () {
    pushMatrix();
    translate(x,y);
    rotate(radians(r));
    imageMode(CENTER);
    image(model, 0, 0, model.width * .5, model.height * .5);
    popMatrix();
  }
}
