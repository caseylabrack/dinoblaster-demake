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
}
