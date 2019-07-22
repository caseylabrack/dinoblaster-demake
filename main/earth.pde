class Earth extends Entity {
  PImage model;
  float radius;
  Earth (float xpos, float ypos) {
    x = xpos;
    y = ypos;
    rx = 2.3;
    model = loadImage("earth.png");
    radius = model.width/2 * .5;
  }

  void update() {
    x += dx;
    y += dy;
    r += rx;
    for (Entity child : children) {
      child.x += dx;
      child.y += dy;
      child.setPosition(utils.rotateAroundPoint(child.getPosition(), getPosition(), rx));
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
