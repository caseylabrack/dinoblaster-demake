class Explosion extends Entity {
  //PImage[] frames;
  PImage model;
  float radius;
  float start = millis();
  float duration = 125;
  boolean visible = true;
  
  Explosion (float xpos, float ypos) {
    x = xpos;
    y = ypos;
    
    model = loadImage("splode.png");
    radius = model.width/2;
    earth.addChild(this);
    splodesManager.splodes.add(this);
    r = degrees(atan2(y - earth.y, x - earth.x)) + 90;
  }
  
  void update () {
    if(millis() - start > duration) {
      visible = false;
    }
  }
  
  void render () {
    if(!visible) return;
    pushMatrix();
    translate(x, y);
    rotate(radians(r));
    imageMode(CENTER);
    image(model, 0, 0, model.width*.5, model.height*.5);
    popMatrix();
  }
}
