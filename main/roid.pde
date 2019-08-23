class Roid extends Entity {
  PImage sheet;
  PImage[] roids;
  PImage model;
  float speed = 2.5;
  boolean enabled = false;
  float radius;
  PImage trail;
  float angle;
  PVector trailPosition;

  Roid () {
    dr = .1;
    sheet = loadImage("asteroids-ss.png");
    trail = loadImage("roid-trail.png");
    roids = utils.sheetToSprites(sheet, 2, 2);
    model = roids[floor(random(0, 4))];
    radius = sqrt(sq(width/2) + sq(height/2)) + model.width;
  }

  void fire () {
    enabled = true;
    angle = random(0, 359);
    x = earth.x + cos(radians(angle)) * radius;
    y = earth.y + sin(radians(angle)) * radius;

    dx = cos(radians(angle+180)) * speed;
    dy = sin(radians(angle+180)) * speed;
  }

  void update () {
 
    if (!enabled) return; 
    x += dx;
    y += dy;
    r += dr;

    if (dist(x, y, earth.x, earth.y) < earth.radius) {
      enabled = false;
      if (dist(x, y, player.x, player.y) < 26) {
        player.die();
      } 
      splodesManager.newSplode(x, y);
    }
  }

  void render() {
    if (!enabled) return;
    pushMatrix();
    imageMode(CENTER);
    translate(width/2 + x - camera.x, height/2 + y - camera.y);
    pushMatrix();
    rotate(radians(angle+90));
    image(trail, 0, -25, trail.width/2, trail.height/2);
    popMatrix();
    rotate(r);
    image(model, 0, 0, model.width/2, model.height/2);
    popMatrix();
  }
}
