class Entity {
  float x, y, r, dx, dy, rx;
  Entity parent;
  ArrayList<Entity> children = new ArrayList<Entity>();
  
  void setParent (Entity p) {
  
  }
  
  void addChild (Entity obj) {
    children.add(obj);
  }  
}
