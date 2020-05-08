class PlayerManager implements updateable, renderable, abductionEvent, roidImpactEvent, playerRespawnedEvent {

  EventManager eventManager;
  Earth earth;
  Time time;
  VolcanoManager volcanoManager;

  Player player = null;

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
  }

  void render() {

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
      if(v.passable()) continue;
      float myAngle = utils.angleOf(new PVector(0, 0), targetPos);
      float vAngle = utils.angleOf(new PVector(0, 0), v.localPos());
      float volcanoDist = utils.signedAngleDiff(myAngle, vAngle);
      if (abs(volcanoDist) < v.getCurrentMargin()) {
        int side = volcanoDist > 0 ? -1 : 1;
        targetPos = utils.rotateAroundPoint(new PVector(cos(radians(vAngle)) * DIST_FROM_EARTH, sin(radians(vAngle)) * DIST_FROM_EARTH), new PVector(0, 0), v.getCurrentMargin() * side);
      }
    }

    setPosition(targetPos);
    r = utils.angleOf(new PVector(0,0),localPos()) + 90;
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
