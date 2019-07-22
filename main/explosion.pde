class Explosion extends Entity {
  //PImage[] frames;
  PImage model;
  float radius;
  
  Explosion (float xpos, float ypos) {
    x = xpos;
    y = ypos;
    
    model = loadImage("splode.png");
    radius = model.width/2;
    earth.addChild(this);
    splodes.add(this);
    r = degrees(atan2(y - earth.y, x - earth.x)) + 90;
  }
  
  void update () {
    if(dist(player.x, player.y, x, y) < radius) {
      //println("hit!", radius);
    }
  }
  
  void render () {
    pushMatrix();
    translate(x, y);
    rotate(radians(r));
    imageMode(CENTER);
    image(model, 0, 0, model.width*.5, model.height*.5);
    popMatrix();
  }
}
