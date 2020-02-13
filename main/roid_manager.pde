class RoidManager implements updateable, renderable {
  float wait;
  int min;
  int max;
  Roid[] roids;
  float lastFire;
  int roidindex = 0;
  Earth earth;
  EventManager events;
  
  PShape roidsheetV;
  PGraphics roidsheet;
  float roidSize = 400;

  Explosion[] splodes = new Explosion[25];
  //PShape sheet;
  PImage sheet;
  PImage[] frames;
  int splodeindex = 0;

  RoidManager (int _min, int _max, int poolsize, Earth earf, EventManager _events) {
    min = _min;
    max = _max;
    roids = new Roid[poolsize];

    earth = earf;
    events = _events;
    
    //roidsheetV = loadShape("roids.svg");
    //roidsheetV.disableStyle();
    //roidsheet = createGraphics((int)roidSize, (int)roidSize);
    //roidsheet.beginDraw();
    //roidsheet.colorMode(HSB, 360, 100, 100);
    //roidsheet.stroke(0,0,100);
    //roidsheet.strokeWeight(2 * 100 / roidSize);
    //roidsheet.noFill();
    ////roidsheet.shapeMode(CENTER);
    //roidsheet.shape(roidsheetV, 0, 0, roidSize, roidSize);
    //roidsheet.endDraw();
    sheet = loadImage("roids.png");

    for (int i = 0; i < poolsize; i++) {
      roids[i] = new Roid(earth, events, sheet);
    }

    //sheet = loadImage("explosion-sheet.png");
    sheet = loadImage("explosion.png");
    frames = utils.sheetToSprites(sheet, 3, 1);

    for (int j = 0; j < splodes.length; j++) {
      splodes[j] = new Explosion(frames, earth);
    }
  }

  void update () {
    if (millis() - lastFire > wait) {
      lastFire = millis();
      wait = random(min, max);
      roids[roidindex % roids.length].fire();
      roidindex++;
    };

    for (Roid r : roids) {
      if (r.enabled) {
        r.update();
        if (dist(r.x, r.y, earth.x, earth.y) < earth.radius ) {
          r.enabled = false;
          splodes[splodeindex % splodes.length].fire(r.x, r.y);
          earth.addChild(splodes[splodeindex % splodes.length]);
          splodeindex++;
          events.dispatchRoidImpact(new PVector(r.x, r.y));
        }
      }
    }

    for (Explosion s : splodes) s.update();
  }

  void render () {
    //image(roidsheet, 0, 0, roidsheet.width, roidsheet.height);
    //shapeMode(CENTER);
    //shape(roidsheetV, 0, 0, roidSize, roidSize);
    for (Roid r : roids) r.render();
    for (Explosion s : splodes) s.render();
  }
}

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
  Earth earth;
  Player player;
  EventManager eventManager;

  Roid (Earth earf, EventManager _eventmanager, PImage _sheet) {
    dr = .1;
    sheet = _sheet;
    //sheet = loadImage("roids.png");
    //sheet = loadImage("asteroids-ss.png");
    trail = loadImage("roid-trail.png");
    roids = utils.sheetToSprites(sheet, 2, 2);
    model = roids[floor(random(0, 4))];
    radius = sqrt(sq(width/2) + sq(height/2)) + model.width;
    earth = earf;
    eventManager = _eventmanager;
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
  }

  void render() {
    if (!enabled) return;
    pushMatrix();
    imageMode(CENTER);
    translate(x, y);
    pushMatrix();
    rotate(radians(angle+90));
    image(trail, 0, -25, trail.width/2, trail.height/2);
    popMatrix();
    rotate(r);
    image(model, 0, 0, model.width, model.height);
    //image(model, 0, 0, model.width/2, model.height/2);
    popMatrix();
  }
}

class Explosion extends Entity {
  PImage model;
  float start;
  float duration = 300;
  boolean visible = false;
  PImage[] frames;
  Earth earth;
  float angle = 0;

  Explosion (PImage[] _frames, Earth _earth) {

    frames = _frames;
    earth = _earth;
  }

  void fire(float xpos, float ypos) {
    visible = true;
    angle = atan2(ypos - earth.y, xpos - earth.x);
    start = millis();
    r = degrees(angle) + 90;
    x = earth.x + cos(angle) * (earth.radius + 20);
    y = earth.y + sin(angle) * (earth.radius + 20);
  }

  void update () {

    if (!visible) return;

    if (millis() - start > duration) {
      visible = false;
      earth.removeChild(this);
    }
    int frameNum = floor(map((millis() - start) / duration, 0, 1, 0, frames.length)); // animation progress is proportional to duration progress
    model = frames[frameNum > 2 ? 2 : frameNum]; // mapping above is not clamped to frames.length, can create array out of index error 

    x += dx;
    y += dy;
    r += dr;

    dx = 0;
    dy = 0;
    dr = 0;
  }

  void render () {
    if (!visible) return;
    pushMatrix();
    translate(x, y);
    rotate(radians(r));
    imageMode(CENTER);
    image(model, 0, 0, model.width, model.height);
    popMatrix();
  }
}
