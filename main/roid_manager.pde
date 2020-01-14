class RoidManager implements updateable {
  float wait;
  int min;
  int max;
  Roid[] roids;
  float lastFire;
  int roidindex = 0;
  Earth earth;
  EventManager events;
  Camera cam;

  Explosion[] splodes = new Explosion[25];
  PImage sheet;
  PImage[] frames;
  int splodeindex = 0;

  RoidManager (int _min, int _max, int poolsize, Earth earf, EventManager _events, Camera _cam) {
    min = _min;
    max = _max;
    roids = new Roid[poolsize];

    earth = earf;
    events = _events;
    cam = _cam;

    for (int i = 0; i < poolsize; i++) {
      roids[i] = new Roid(earth, events, cam);
    }

    sheet = loadImage("explosion-sheet.png");
    frames = utils.sheetToSprites(sheet, 3, 1);

    for (int j = 0; j < splodes.length; j++) {
      splodes[j] = new Explosion(cam, frames, earth);
      //earth.addChild(splodes[j]);
    }
    
    //frameRate(1);
    //splodes[splodeindex % splodes.length].fire(earth.x , earth.y -100);
    //splodes[1].fire(earth.x + 200, earth.y + 200);
  }

  void update () {
    //if (millis() - lastFire > wait) {
    //  lastFire = millis();
    //  wait = random(min, max);
    //  roids[roidindex % roids.length].fire();
    //  roidindex++;
    //};
    
   if(frameCount % 30 == 0) {
   roids[roidindex % roids.length].fire(); 
   roidindex++;
   }
    
   //  if(frameCount==400){
   //    frameRate(5);
   //  //  splodes[splodeindex % splodes.length].fire(earth.x , earth.y -100);
   //  //  circle(earth.x, earth.y -100, 25);
   //  //  circle(earth.x, earth.y, 40);
   //  }   
    
    for (Roid r : roids) {
      if (r.enabled) {
        r.update();
        if (dist(r.x, r.y, earth.x, earth.y) < earth.radius ) {
          //circle(r.x,r.y,20);
          r.enabled = false;
          splodes[splodeindex % splodes.length].fire(r.x, r.y);
          earth.addChild(splodes[splodeindex % splodes.length]);
          //println(splodeindex % splodes.length);
          //splodes[splodeindex % splodes.length].r = degrees(atan2(r.y - earth.y, r.x - earth.x)) + 90;
          //splodes[splodeindex % splodes.length].r = degrees(atan2(r.y - earth.y, r.x - earth.x)) + 90;
          //println(splodes[splodeindex % splodes.length].r);
          //splodes[splodeindex % splodes.length].r = degrees(atan2(r.y - earth.y, r.x - earth.x)) + 90;
          splodeindex++;
          //newSplode(r.x, r.y);
          events.dispatchRoidImpact(new PVector(r.x, r.y));
        }
        r.render();
      }
    }

    for (Explosion s : splodes) {
      s.update();
      s.render();
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
  //SplosionManager splodesManager;
  EventManager eventManager;
  Camera camera;

  Roid (Earth earf, EventManager _eventmanager, Camera _camera) {
    dr = .1;
    sheet = loadImage("asteroids-ss.png");
    trail = loadImage("roid-trail.png");
    roids = utils.sheetToSprites(sheet, 2, 2);
    model = roids[floor(random(0, 4))];
    radius = sqrt(sq(width/2) + sq(height/2)) + model.width;
    earth = earf;
    eventManager = _eventmanager;
    camera = _camera;
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

class Explosion extends Entity {
  PImage model;
  float start;
  float duration = 300;
  boolean visible = false;
  PImage[] frames;
  Camera camera;
  Earth earth;

  Explosion (Camera _cam, PImage[] _frames, Earth _earth) {

    frames = _frames;
    camera = _cam;
    earth = _earth;
  }

  void fire(float xpos, float ypos) {
    visible = true;
    x = xpos;
    y = ypos;
    start = millis();
    r = degrees(atan2(y - earth.y, x - earth.x)) + 90;
    //print("fire method");
    //println(r);
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
    translate(width/2 + x - camera.x, height/2 + y - camera.y);
    rotate(radians(r));
    imageMode(CENTER);
    image(model, 0, 0, model.width*.5, model.height*.5);
    popMatrix();
  }
}
