class RoidManager implements updateable, renderable {

  EventManager events;
  Time time;

  float wait;
  int min;
  int max;
  Roid[] roids;
  float lastFire;
  int roidindex = 0;
  Earth earth;

  PShape roidsheetV;
  PGraphics roidsheet;
  float roidSize = 400;

  Explosion[] splodes = new Explosion[25];
  PImage sheet;
  PImage[] frames;
  int splodeindex = 0;

  RoidManager (int _min, int _max, int poolsize, Earth earf, EventManager _events, Time t) {
    min = _min;
    max = _max;
    roids = new Roid[poolsize];

    earth = earf;
    events = _events;
    time = t;

    sheet = loadImage("roids.png");

    for (int i = 0; i < poolsize; i++) {
      roids[i] = new Roid(earth, events, sheet, time);
    }

    sheet = loadImage("explosion.png");
    frames = utils.sheetToSprites(sheet, 3, 1);

    for (int j = 0; j < splodes.length; j++) {
      splodes[j] = new Explosion(frames, time);
    }

    //roids[roidindex % roids.length].fire();
    //roidindex++;
  }

  void update () {
    if (time.getClock() - lastFire > wait) {
      lastFire = time.getClock();
      wait = random(min, max);
      roids[roidindex % roids.length].fire();
      roidindex++;
    };

    for (Roid r : roids) {
      if (r.enabled) {
        r.update();
        if (dist(r.x, r.y, earth.x, earth.y) < earth.radius ) {
          r.enabled = false;
          splodes[splodeindex % splodes.length].enable(r.globalPos(), earth);
          splodeindex++;
          events.dispatchRoidImpact(r.globalPos());
        }
      }
    }

    for (Explosion s : splodes) s.update();
  }

  void render () {
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
  Time time;

  Roid (Earth earf, EventManager _eventmanager, PImage _sheet, Time t) {
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
    time = t;
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
    x += dx * time.getTimeScale();
    y += dy * time.getTimeScale();
    r += dr * time.getTimeScale();
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
  float duration = 500;
  boolean enabled = false;
  PImage[] frames;
  Time time;
  float angle = 0;

  Explosion (PImage[] _frames, Time t) {

    frames = _frames;
    time = t;
  }

  void enable (PVector pos, Earth earth) {

    enabled = true;
    start = time.getClock();

    setPosition(pos);
    angle = atan2(pos.y - earth.y, pos.x - earth.x);
    x = earth.x + cos(angle) * (earth.radius + 20);
    y = earth.y + sin(angle) * (earth.radius + 20);
    r = degrees(angle) + 90;
    earth.addChild(this);
  }

  void update () {

    if (!enabled) return;

    float elapsed = time.getClock() - start;

    if (elapsed < duration) {
      model = frames[round((elapsed / duration) * (frames.length - 1))];
    } else {
      enabled = false;
      parent.removeChild(this);
    }

    x += dx;
    y += dy;
    r += dr;

    dx = 0;
    dy = 0;
    dr = 0;
  }

  void render () {
    if (!enabled) return;
    pushMatrix();
    pushStyle();
    PVector trans = globalPos();
    translate(trans.x, trans.y);
    rotate(radians(globalRote()));
    image(model, 0, 0, model.width, model.height);
    popStyle();
    popMatrix();
  }
}
