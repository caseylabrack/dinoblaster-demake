class TrexManager implements updateable, renderable, levelChangeEvent {

  EventManager events;
  Time time;  
  Earth earth;
  Trex trex;
  EggTrex egg;
  PlayerManager playerManager;
  ColorDecider currentColor;

  final int SPAWN_DELAY = 25;
  int spawnSchedule = -1;

  TrexManager (EventManager e, Time t, Earth w, PlayerManager pm, ColorDecider c, int lvl) {
    events = e;
    time = t;
    earth = w;
    currentColor = c;
    playerManager = pm;

    if (lvl==UIStory.CRETACEOUS) spawnSchedule = SPAWN_DELAY; //spawn();
    events.levelChangeSubscribers.add(this);
  }

  void levelChangeHandle(int stage) {

    if (stage==UIStory.CRETACEOUS) spawnSchedule = SPAWN_DELAY; //spawn();
  }

  void spawn () {

    egg = new EggTrex(earth, time, currentColor);
  }

  void update () {

    if (spawnSchedule > -1) {
      spawnSchedule--;
      if (spawnSchedule==0) {
        spawnSchedule = -1;
        spawn();
      }
    }

    if (egg!=null) {
      egg.update();
      if (egg.state==EggTrex.DONE) {
        trex = new Trex(earth, playerManager, time, egg.localPos());
        egg = null;
      }
    }

    if (trex!=null) trex.update();
  }

  void render() {
    if (trex!=null) trex.render();
    if (egg!=null) egg.render();
  }
}

class EggTrex extends Entity implements updateable, renderable {

  Earth earth;
  Time time;
  ColorDecider currentColor;

  final float startY = 115;
  final float endY = 190;
  final float risingDuration = 1e3;
  final float idleDuration = 1e3;
  final float crackedDuration = 3e3;
  float startTime;
  float angle;

  final int WIGGLES_NUM = 3;
  int wiggleCount = 0;
  final float wiggleDuration = .5e3;
  final float WIGGLE_POWER_START = 90;
  float wigglePower;
  float uprightR;

  final static int RISING = 0;
  final static int WIGGLES = 1;
  final static int IDLE = 2;
  final static int CRACKED = 3;
  final static int DONE = 4;
  public int state = RISING;

  PImage model;

  EggTrex (Earth e, Time t, ColorDecider c) {
    earth = e;
    time = t;
    currentColor = c;

    model = assets.trexStuff.eggCracked;

    earth.addChild(this);
    x = 0;
    y = -100;

    // emerge from random place
    angle = random(360);
    setPosition(utils.rotateAroundPoint(localPos(), new PVector(0, 0), angle));
    r = angle + 90;
    uprightR = r;

    startTime = time.getClock();
  }

  void update () {

    float progress;

    switch(state) {

    case RISING:
      progress = (time.getClock() - startTime) / risingDuration;
      if (progress < 1) {
        //float dist = utils.easeLinear(progress,startY,endY-startY,1);
        float t = utils.easeOutBounce(progress);
        //float t = utils.easeOutElastic(progress);
        float dist = startY + (endY - startY) * t;
        x = cos(radians(angle)) * dist;
        y = sin(radians(angle)) * dist;
      } else {
        state = IDLE;
        startTime = time.getClock();
      }

      break;

    case IDLE:
      progress = (time.getClock() - startTime) / idleDuration;
      if (progress > 1) {
        if (wiggleCount < WIGGLES_NUM) {
          state = WIGGLES;
        } else {
          state = CRACKED;
          model = assets.trexStuff.eggBurst;
        }
        startTime = time.getClock();
      }
      break;

    case WIGGLES:
      progress = (time.getClock() - startTime) / wiggleDuration;
      if (progress < 1) {
        wigglePower = utils.easeInQuad(progress, WIGGLE_POWER_START, 0 - WIGGLE_POWER_START, 1);
        r = uprightR + sin(time.getClock()) * wigglePower;
      } else {
        r = uprightR;
        wiggleCount++;        
        state = IDLE;
        startTime = time.getClock();
      }
      break;

    case CRACKED:
      progress = (time.getClock() - startTime) / crackedDuration;
      if (round(progress * 10) % 2 == 0) {
        model = assets.trexStuff.eggBurst;
      } else {
        model = assets.trexStuff.trexIdle;
      }
      if (progress > 1) {
        state = DONE;
      }
      break;
    }
  }

  void render() {
    pushStyle();
    tint(currentColor.getColor());
    simpleRenderImage(model);
    popStyle();
  }
}


class Trex extends Entity implements gameOverEvent, updateable, renderable {

  PImage model;
  PImage idle;
  PImage[] runFrames = new PImage[2];
  boolean visible = true;
  float runSpeed = .75;
  boolean chasing = true;
  float attackAngle = 110;
  Earth earth;
  PlayerManager playerManager;
  Time time;

  final float HITBOX_ANGLE = 16;

  Trex (Earth _earth, PlayerManager pm, Time t, PVector pos) {
    earth = _earth; 
    playerManager = pm;
    time = t;
    //PImage sheet = loadImage("trex.png");
    //PImage[] frames = utils.sheetToSprites(sheet, 3, 1);
    idle = assets.trexStuff.trexIdle;//frames[0];
    runFrames[0] = assets.trexStuff.trexRun1;//frames[1];
    runFrames[1] = assets.trexStuff.trexRun2;//frames[2];
    model = idle;
    facing = -1;
    earth.addChild(this);
    setPosition(pos);
    r = utils.angleOf(new PVector(0, 0), localPos()) + 90;
  }

  void gameOverHandle () {
    chasing = false;
  }

  void update () {

    float playerDist = playerManager.player!=null ? utils.signedAngleDiff(r, playerManager.player.r) : 1e9;

    if (abs(playerDist) < HITBOX_ANGLE) {
      playerManager.roidImpactHandle(this.globalPos());
    }

    if (abs(playerDist) < attackAngle) {
      chasing = true;
      facing = playerDist > 0 ? 1 : -1;
    } else {
      chasing = false;
    }

    if (chasing) {
      model = runFrames[utils.cycleRangeWithDelay(runFrames.length, 12, frameCount)];
      if (model==runFrames[1]) earth.shake(2.5);
      setPosition(utils.rotateAroundPoint(localPos(), new PVector(0, 0), runSpeed * time.getTimeScale() * facing));
      dr += runSpeed * time.getTimeScale() * facing;
    } else {
      model = idle;
    }

    x += dx;
    y += dy;
    r += dr;

    dx = 0;
    dy = 0;
    dr = 0;
  }

  void render () {
    simpleRenderImage(model);
    //pushTransforms();
    //pushStyle();
    //noFill();
    //stroke(60,60,60);
    //strokeWeight(3);
    //circle(0, 0, HIT_RADIUS);
    //popStyle();
    //popMatrix();
  }
}
