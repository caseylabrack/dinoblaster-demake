

class Orbiter extends Entity {
  float cx, cy, radius, angle, angleStep;
  Orbiter (float _x, float _y, float _cx, float _cy, float _step) {
    x = _x;
    y = _y;
    cx = _cx;
    cy = _cy;
    angleStep = _step;
    angle = atan2(y - cy, x - cx);
    radius = dist(x, y, cx, cy);
  }

  void update () {
    dx = cos(angle) * radius - x;
    dy = sin(angle) * radius - y;
    angle += angleStep;

    x += dx;
    y += dy;

  updateChildren();
    //for (Entity child : children) {
    //  child.dx += dx;
    //  child.dy += dy;
    //}

    pushMatrix();
    translate(width/2 + x - camera.x, height/2 + y - camera.y);
    circle(width/2, height/2, 10);
    popMatrix();
  }
}

class Earth extends Entity implements gameOverEvent {
  PImage model;
  float radius;
  Earth (float xpos, float ypos) {
    x = xpos;
    y = ypos;
    dx = 0;
    dy = 0;
    rx = 2.3;
    model = loadImage("earth.png");
    radius = (model.width/2) * .5;
    eventManager.gameOverSubscribers.add(this);
  }

  void gameOverHandle () {
    //rx = 0;
  }

  void update() {
    x += dx;
    y += dy;
    r += rx;
    for (Entity child : children) {
      child.dx += dx;
      child.dy += dy;
      child.r += rx;
      child.setPosition(utils.rotateAroundPoint(child.getPosition(), getPosition(), rx));
    }
  }

  void render () {
    pushMatrix();
    translate(width/2 + x - camera.x, height/2 + y - camera.y);
    rotate(radians(r));
    imageMode(CENTER);
    image(model, 0, 0, model.width*.5, model.height*.5);
    popMatrix();
  }
}
