class PlayerManager implements updateable, renderable, abductionEvent, roidImpactEvent, playerRespawnedEvent {

  EventManager eventManager;
  Earth earth;
  Time time;
  VolcanoManager volcanoManager;

  Player player = null;
  PlayerDeath deathAnim = null;

  PImage model;
  int extralives = 0;

  boolean display = true;
  float flickerStart = 0;
  float flickerDuration = 6e3;
  boolean respawning = false;
  float flickerInitialRate = 1e3;
  final static float respawnReadyFlickerRate = 50;
  float flickerRate = 250;
  float respawningY = -100;
  float respawningYTarget = -197;
  float respawningDuration = 3e3;
  float respawningStart = 0;
  float progress = 0;

  boolean spawning = true;
  float spawningStart = 0;
  float spawningDuration = 2e3;
  float spawningRate = 125;
  private float spawningFlickerStart;

  PlayerManager (EventManager _ev, Earth _earth, Time t, VolcanoManager volcs) {
    eventManager = _ev;
    earth = _earth;
    time = t;
    volcanoManager = volcs;

    model = utils.sheetToSprites(loadImage("bronto-frames.png"), 3, 1)[0];

    spawningStart = millis();
    progress = 0;
    spawningFlickerStart = millis();
    //spawning = false;

    eventManager.roidImpactSubscribers.add(this);
    eventManager.abductionSubscribers.add(this);
    eventManager.playerRespawnedSubscribers.add(this);
  }

  void roidImpactHandle(PVector impact) {

    if (player!=null) {
      if (PVector.dist(player.globalPos(), impact) < 50) {
        extralives--;
        float incomingAngle = utils.angleOf(earth.globalPos(), impact);
        PVector adjustedPosition = new PVector(earth.globalPos().x + cos(radians(incomingAngle)) * (earth.radius - 50), earth.globalPos().y + sin(radians(incomingAngle)) * (earth.radius - 50));

        Entity thing = new Entity();
        thing.setPosition(adjustedPosition);
        thing.r = player.globalRote();

        Entity pl = new Entity();
        pl.setPosition(player.globalPos());
        pl.r = player.globalRote();
        pl.addChild(thing);

        deathAnim = new PlayerDeath(time, player.globalPos(), player.globalRote(), player.direction, thing.localPos());
        if (extralives<0) {
          eventManager.dispatchGameOver();
        } else {
          eventManager.dispatchPlayerDied(player.globalPos());
        }
        player.cleanup();
        player = null;
      }
    }
  }

  void abductionHandle(PVector p) {
    player.cleanup();
    player = null;
    extralives++;
    respawning = true;
    flickerStart = millis();
    flickerRate = flickerInitialRate;
    respawningStart = millis();
    display = true;
    progress = 0;
  }

  void playerRespawnedHandle(PVector position) {
    player = new Player(eventManager, time, earth, 1, volcanoManager, position);
  }

  void update() {
    if (player!=null) player.update();

    if (deathAnim!=null) deathAnim.update();
  }

  void render() {

    if (deathAnim!=null) deathAnim.render();

    if (spawning) {
      progress = (millis() - spawningStart) / spawningDuration;
      if (progress < 1) {
        if (millis() - spawningFlickerStart > spawningRate) {
          display = !display;
          spawningFlickerStart = millis();
        }
      } else {
        spawning = false;
        player = new Player(eventManager, time, earth, 1, volcanoManager, null);
        eventManager.dispatchPlayerSpawned(player);
      }
      if (display) {
        image(model, 0, respawningYTarget);
      }
    }

    if (player!=null) player.render();

    if (respawning) {
      progress = (millis() - respawningStart) / respawningDuration;
      if (millis() - flickerStart > flickerRate) {
        display = !display;
        flickerStart = millis();
      }
      if (progress < 1) {
        respawningY = utils.easeOutQuad(progress, -100, respawningYTarget - (-100), 1);    
        flickerRate = utils.easeOutExpo(progress, flickerInitialRate, respawnReadyFlickerRate - flickerInitialRate, 1);
      } else { // allow respawning
        if (keys.anykey) {
          respawning = false;
          eventManager.dispatchPlayerRespawned(null);
        }
      }
      if (display) {
        image(model, 0, respawningY);
      }
    }
  }
}

class PlayerDeath extends Entity {

  PVector ppos;
  float pr;
  float pDir;
  PVector forcePoint;

  Time time;
  Particle[] parts;

  PlayerDeath (Time t, PVector _spot, float _r, float _dir, PVector _forcePoint) {
    time = t;
    ppos = _spot;
    pr = _r;
    pDir = 1;
    //pDir = _dir;
    forcePoint = _forcePoint;

    float ang = utils.angleOf(new PVector(0, 0), _spot);

    parts = new Particle[assets.playerStuff.dethSVG.getChildCount()];

    for (int i = 0; i < parts.length; i++) {
      parts[i] = new Particle(time, assets.playerStuff.dethSVG.getChild(i), new PVector(51/2, 67/2), _dir==1);
      //parts[i] = new Particle(time, assets.playerStuff.dethSVG.getChild(i), new PVector(0, 0));
      float angle = atan2(parts[i].midpoint.y - forcePoint.y, parts[i].midpoint.x - forcePoint.x);
      //float angle = atan2(parts[i].midpoint.y - 67, parts[i].midpoint.x - 26);
      float d = dist(forcePoint.x, forcePoint.y, parts[i].midpoint.x, parts[i].midpoint.y);
      //float d = dist(26, 67, parts[i].midpoint.x, parts[i].midpoint.y);
      //float force = (1/(d * d)) * 10000;
      float force = (1/d) * 1000;//500;
      //float force = 1;
      parts[i].dx = cos(angle) * force;
      parts[i].dy = sin(angle) * force;
    }
  }

  void update () {
    for (Particle p : parts) p.update();
  }

  void render () {

    pushMatrix();
    pushStyle();
    stroke(0, 0, 100);
    strokeWeight(1);
    //shapeMode(CENTER);
    scale(pDir, 1);
    translate(ppos.x * pDir, ppos.y);
    rotate(radians(pDir * pr));

    for (Particle p : parts) {
      if (!p.enabled) continue;
      line(p.p1.x, p.p1.y, p.p2.x, p.p2.y);
      //line(0, 0, p.dx * 10, p.dy * 10);
    }
    popStyle();
    popMatrix();
  }
} 

class Particle {
  //float x, y, r;
  float r;
  float dx, dy, dr;
  PShape model;
  float[] params = new float[4];
  PVector points;
  PVector p1, p2;
  PVector midpoint;
  PVector position;
  PVector center;
  boolean enabled = true;
  final static int minDisable = 30;
  final static int maxDisable = 120;
  int disableCount = 0;
  int disableDuration;
  Time time;

  Particle (Time t, PShape shape, PVector _center, boolean isLeft) {
    time = t;
    model = shape;
    center = _center;
    params = model.getParams();
    p1 = new PVector(model.getParams()[0], model.getParams()[1]);
    p2 = new PVector(model.getParams()[2], model.getParams()[3]);
    p1 = utils.offset(p1, _center);
    p2 = utils.offset(p2, _center);
    p1 = new PVector(isLeft ? p1.x : -p1.x, p1.y);
    p2 = new PVector(isLeft ? p2.x : -p2.x, p2.y);
    //p1.x*= isLeft ? -1 : 1;
    //p2.x*= isLeft ? -1 : 1;
    midpoint = utils.midpoint(p1, p2);
    disableDuration = round(random(minDisable, maxDisable));
  }

  void update() {

    //disableCount++;
    if (disableCount > disableDuration) enabled = false;

    p1.x += dx * time.getTimeScale();
    p1.y += dy * time.getTimeScale();

    p2.x += dx * time.getTimeScale();
    p2.y += dy * time.getTimeScale();
    r += dr;

    dx *= .99;
    dy *= .99;
  }
}

class Player extends Entity implements updateable, renderable { 
  PImage model;
  PImage[] runFrames = new PImage[2];
  PImage idle;
  final static float runSpeed = 5;
  int direction = 1;
  int playerNum = 1;
  int framesTotal = 8;
  final static float DIST_FROM_EARTH = 197;

  EventManager eventManager;
  Time time;
  VolcanoManager volcanoManager;

  Player (EventManager _eventManager, Time t, Earth earth, int whichPlayer, VolcanoManager volcs, PVector pos) {
    eventManager = _eventManager;
    time = t;
    volcanoManager = volcs;

    PImage sheet = whichPlayer==1 ? loadImage("bronto-frames.png") : loadImage("oviraptor-frames.png");
    PImage[] frames = whichPlayer==1 ? utils.sheetToSprites(sheet, 3, 1) : utils.sheetToSprites(sheet, 2, 2, 1);
    idle = frames[0];
    runFrames[0] = frames[1];
    runFrames[1] = frames[2];
    model = idle;
    x = pos==null ? earth.x + cos(radians(-90)) * DIST_FROM_EARTH : pos.x;
    y = pos==null ? earth.y + sin(radians(-90)) * DIST_FROM_EARTH : pos.y;
    r = degrees(atan2(earth.y - y, earth.x - x)) - 90;
    earth.addChild(this);
  }

  void update () {

    PVector targetPos = localPos();
    float targetDr = dr;

    if (keys.left != keys.right) { // xor
      model = runFrames[utils.cycleRangeWithDelay(runFrames.length, 4, frameCount)];
      direction = keys.left ? -1 : 1;
      targetPos = utils.rotateAroundPoint(localPos(), new PVector(0, 0), runSpeed * time.getTimeScale() * direction);
      targetDr = runSpeed * time.getTimeScale() * direction;
    } else {
      model = idle;
    }

    for (Volcano v : volcanoManager.volcanos) {
      if (v.passable()) continue;
      float myAngle = utils.angleOf(new PVector(0, 0), targetPos);
      float vAngle = utils.angleOf(new PVector(0, 0), v.localPos());
      float volcanoDist = utils.signedAngleDiff(myAngle, vAngle);
      if (abs(volcanoDist) < v.getCurrentMargin()) {
        int side = volcanoDist > 0 ? -1 : 1;
        targetPos = utils.rotateAroundPoint(new PVector(cos(radians(vAngle)) * DIST_FROM_EARTH, sin(radians(vAngle)) * DIST_FROM_EARTH), new PVector(0, 0), v.getCurrentMargin() * side);
      }
    }

    setPosition(targetPos);
    r = utils.angleOf(new PVector(0, 0), localPos()) + 90;
  }

  void render () {
    pushMatrix();
    pushStyle();
    imageMode(CENTER);
    PVector trans = globalPos();
    scale(direction, 1);
    translate(trans.x * direction, trans.y);
    rotate(radians(globalRote() * direction));
    image(model, 0, 0);
    popStyle();
    popMatrix();
  }

  void cleanup () {
    parent.removeChild(this);
  }
}
