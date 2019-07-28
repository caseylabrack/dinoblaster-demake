class Entity {
  float x, y, r, dx, dy, rx;
  Entity parent;
  ArrayList<Entity> children = new ArrayList<Entity>();

  void setParent (Entity p) {
    parent = p;
  }

  void addChild (Entity obj) {
    children.add(obj);
  } 

  void setPosition (PVector pos) {
    x = pos.x;
    y = pos.y;
  }
  
  void updateChildren () {
  
    for(Entity c : children) {
    
        c.dx += dx;
        c.dy += dy;
        c.updateChildren();    
    }
  }

  PVector getPosition () {
    return new PVector(x, y);
  }
}
