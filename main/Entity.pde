class Entity {
  float x, y, r, dx, dy, dr;
  Entity parent = null;
  ArrayList<Entity> children = new ArrayList<Entity>();

  void addChild (Entity child) {

    float d = dist(x, y, child.x, child.y);
    float a = degrees(atan2(child.y - y, child.x - x));
    float rote = a - r;
    float x = cos(radians(rote)) * d;
    float y = sin(radians(rote)) * d;

    child.x = x;
    child.y = y;
    child.r = child.r - r;
    child.parent = this;
    children.add(child);
  } 

  void removeChild (Entity obj) {
    children.remove(obj);
  }

  float[] localToGlobal() {

    if (parent!=null) {
      float a = atan2(y, x) + radians(parent.r);
      float d = dist(x, y, 0, 0);
      float x = parent.x + cos(a) * d;
      float y = parent.y + sin(a) * d;
      float rote = parent.r + r;
      float[] transform = {x, y, rote};
      return transform;
    }
    float[] transform = {x, y, r};
    return transform;
  }

  PVector globalPos() {
    if (parent!=null) {
      float a = atan2(y, x) + radians(parent.r);
      float d = dist(x, y, 0, 0);
      return new PVector(parent.x + cos(a) * d, parent.y + sin(a) * d);
    }
    return getPosition();
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

  PVector getPosition () {
    return new PVector(x, y);
  }
}
