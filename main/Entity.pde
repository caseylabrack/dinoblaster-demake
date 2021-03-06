class Entity {
  float x, y, r, dx, dy, dr;
  int facing = 1;
  Entity parent = null;

  void addChild (Entity child) {
    child.setPosition(globalToLocalPos(child.globalPos()));
    child.r = child.globalRote() - r;
    child.parent = this;
  } 

  public PVector globalToLocalPos (PVector globalPoint) {
    PVector mypos = globalPos();
    float d = dist(mypos.x, mypos.y, globalPoint.x, globalPoint.y);
    float a = atan2(globalPoint.y - mypos.y, globalPoint.x - mypos.x);
    float rote = a - radians(globalRote());

    return new PVector(cos(rote) * d, sin(rote) * d);
  }

  PVector globalPos() {
    if (parent!=null) {
      float a = atan2(y, x) + radians(parent.r);
      float d = dist(x, y, 0, 0);
      return new PVector(parent.x + cos(a) * d, parent.y + sin(a) * d);
    }
    return new PVector(x, y);
  }

  float globalRote() {
    if (parent!=null) {
      return parent.r + r;
    }
    return r;
  }

  void setPosition (PVector pos) {
    x = pos.x;
    y = pos.y;
  }

  void setPosition (float _x, float _y) {
    x = _x;
    y = _y;
  }

  PVector localPos () {
    return new PVector(x, y);
  }

  float localRote() {
    return r;
  }
  
  void pushTransforms () {
    pushMatrix();
    PVector pos = globalPos();
    scale(facing, 1);
    translate(pos.x * facing, pos.y);
    rotate(radians(globalRote() * facing));
  }
  
  void simpleRenderImage (PImage im) {
    pushTransforms();
    image(im, 0, 0);
    popMatrix();
  }
}
