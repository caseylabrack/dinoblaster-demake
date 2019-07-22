class Roid extends Entity {
  PImage sheet;
  PImage[] roids;
  PImage model;
  Roid () {
    //x = xPos;
    //y = yPos;
    dx = random(-.1,.1);
    rx = .1;
    sheet = loadImage("asteroids-ss.png");
    roids = utils.sheetToSprites(sheet, 2, 2);
    model = roids[floor(random(0, 4))];
    
    float radius = 100;
    float angle = random(0,359);
    x = width / 2 + cos(radians(angle)) * radius;
    y = height / 2 + sin(radians(angle)) * radius;
  }

  void update () {
    x += dx;
    y += dy;
    r += rx;
  }

  void render() {
    pushMatrix();
    translate(x, y);
    rotate(r);
    imageMode(CENTER);
    image(model, 0, 0, model.width/2, model.height/2);
    popMatrix();
  }
}
