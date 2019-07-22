class Roid extends Entity {
  PImage sheet;
  PImage[] roids;
  PImage model;
  float speed = 5;
  boolean visible = false;
  
  Roid () {
    rx = .1;
    sheet = loadImage("asteroids-ss.png");
    roids = utils.sheetToSprites(sheet, 2, 2);
    model = roids[floor(random(0, 4))];
  }
  
  void fire () {
    visible = true;
    float radius = width/2;
    float angle = random(0,359);
    x = width / 2 + cos(radians(angle)) * radius;
    y = height / 2 + sin(radians(angle)) * radius;
    
    dx = cos(radians(angle+180)) * speed;
    dy = sin(radians(angle+180)) * speed;
  }

  void update () {
    x += dx;
    y += dy;
    r += rx;
    
    if(dist(x, y, earth.x, earth.y) < earth.radius) {
      visible = false;
      Explosion splode = new Explosion(x, y);
    }
  }

  void render() {
    if(!visible) return;
    pushMatrix();
    translate(x, y);
    rotate(r);
    imageMode(CENTER);
    image(model, 0, 0, model.width/2, model.height/2);
    popMatrix();
  }
}
