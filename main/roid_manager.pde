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

  class Explosion extends Entity {
    PImage model;
    float start;
    final static float duration = 500;
    boolean enabled = false;
    float angle = 0;
  }

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

    for (int j = 0; j < splodes.length; j++) {
      splodes[j] = new Explosion();
      earth.addChild(splodes[j]);
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
        if (PVector.dist(r.globalPos(), earth.globalPos()) < earth.radius ) {
          r.enabled = false;
          Explosion splode = splodes[splodeindex % splodes.length];
          splodeindex++;
          events.dispatchRoidImpact(r.globalPos());

          splode.enabled = true;
          splode.start = time.getClock();
          float angle = utils.angleOfRadians(earth.globalPos(), r.globalPos());
          float offset = 20;
          PVector adjustedPosition = new PVector(earth.x + cos(angle) * (earth.radius + offset), earth.y + sin(angle) * (earth.radius + offset));
          splode.setPosition(earth.globalToLocalPos(adjustedPosition));
          splode.r = utils.angleOf(earth.localPos(), splode.localPos()) + 90;
        }
      }
    }

    for (Explosion s : splodes) {
      if (!s.enabled) continue;

      float elapsed = time.getClock() - s.start;

      if (elapsed < Explosion.duration) {
        s.model = assets.roidStuff.explosionFrames[round((elapsed / Explosion.duration) * (assets.roidStuff.explosionFrames.length - 1))];
      } else {
        s.enabled = false;
      }
    }
  }

  void render () {
    for (Roid r : roids) r.render();
    for (Explosion s : splodes) {
      if (!s.enabled) continue;
      s.simpleRenderImage(s.model);
    }
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
