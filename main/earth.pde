class Earth extends Entity {
  PImage model;
  Earth (float xpos, float ypos) {
    x = xpos;
    y = ypos;
    rx = 2;

    model = loadImage("earth.png");
  }

  void update() {
    x += dx;
    y += dy;
    r += rx;
    for (Entity child : children) {
      child.x += dx;
      child.y += dy;
      float angle = degrees(atan2(y - child.y, x - child.x));
      float dist = dist(x, y, child.x, child.y);
      angle += rx;
      child.x = x - cos(radians(angle)) * dist;
      child.y = y - sin(radians(angle)) * dist;
      child.r += rx;
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
