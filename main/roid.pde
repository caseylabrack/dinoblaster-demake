class Roid extends Entity {
  PImage sheet;
  PImage[] roids;
  PImage model;
  float speed = 2;
  boolean enabled = false;
  
  Roid () {
    rx = .1;
    sheet = loadImage("asteroids-ss.png");
    roids = utils.sheetToSprites(sheet, 2, 2);
    model = roids[floor(random(0, 4))];
  }
  
  void fire () {
    enabled = true;
    float radius = width/2;
    float angle = random(0,359);
    x = earth.x + cos(radians(angle)) * radius;
    y = earth.y + sin(radians(angle)) * radius;
    
    dx = cos(radians(angle+180)) * speed;
    dy = sin(radians(angle+180)) * speed;
  }

  void update () {
    
    if(!enabled) return; 
    x += dx;
    y += dy;
    r += rx;
    
    if(dist(x, y, earth.x, earth.y) < earth.radius) {
      enabled = false;
      if(dist(x,y,player.x,player.y) < 15) {
        eventManager.dispatchGameOver();
      } 
      Explosion splode = new Explosion(x, y);
      earth.addChild(splode);
    }
  }

  void render() {
    if(!enabled) return;
    pushMatrix();
    translate(width/2 + x - camera.x, height/2 + y - camera.y);
    rotate(r);
    imageMode(CENTER);
    image(model, 0, 0, model.width/2, model.height/2);
    popMatrix();
  }
}
