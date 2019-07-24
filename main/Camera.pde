class Camera extends Entity {
  Camera () {

    setPosition(earth.getPosition());
    earth.addChild(this);
  }

  void update () {
    x += dx;
    y += dy;
    r += rx;

    dx = 0;
    dy = 0;
  }
}
