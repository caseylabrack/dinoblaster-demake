class PlayerManager implements updateable, renderable, abductionEvent {

  EventManager eventManager;
  Keys keys;

  PImage model;
  int extralives = 0;
  int flicker = 60;
  boolean display = true;
  float flickerStart = 0;
  float flickerDuration = 6e3;
  boolean respawning = false;
  float flickerInitialRate = 250;
  float flickerRate = 250;
  float respawningY = -100;
  float respawningYTarget = -197;
  float respawningDuration = 3e3;
  float respawningStart = 0;
  float progress = 0;

  boolean spawning = true;
  float spawningStart = 0;
  float spawningDuration = 4e3;
  float spawningRate = 125;
  float spawningFlickerStart;

  PlayerManager (EventManager _ev, Keys _keys) {
    keys = _keys;
    eventManager = _ev;
    eventManager.abductionSubscribers.add(this);

    model = utils.sheetToSprites(loadImage("bronto-frames.png"), 3, 1)[0];

    spawningStart = millis();
    progress = 0;
    spawningFlickerStart = millis();
  }

  void abductionHandle(PVector p) {
    println("extra life"); 
    extralives++;
    respawning = true;
    flickerStart = millis();
    flickerRate = flickerInitialRate;
    respawningStart = millis();
    display = true;
    progress = 0;
  }

  void update() {
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
        println("spawn!");
      }
      if (display) {
        image(model, 0, respawningYTarget);
      }
    }


    if (respawning) {
      progress = (millis() - respawningStart) / respawningDuration;
      if (millis() - flickerStart > flickerRate) {
        display = !display;
        flickerStart = millis();
      }
      if (progress < 1) {
        respawningY = utils.easeOutQuad(progress, -100, respawningYTarget - (-100), 1);    
        flickerRate = utils.easeOutExpo(progress, 250, 50 - 250, 1);
      } else {
        // allow respawning
        if (keys.anykey) {
          println("respawned!");
          respawning = false;
        }
      }
      if (display) {
        image(model, 0, respawningY);
      }
    }
  }
}


class PlayerIntro extends Entity {
  PImage model;
  GameMode mode;

  PlayerIntro (GameMode _mode, int whichPlayer) {
    PImage sheet = whichPlayer==1 ? loadImage("bronto-run.png") : loadImage("oviraptor-frames.png");
    PImage[] frames = whichPlayer==1 ? utils.sheetToSprites(sheet, 3, 1) : utils.sheetToSprites(sheet, 2, 2, 1);
    model = frames[0];
    mode = _mode;
  }

  void update () {
  }

  void render () {
  }
}

class Player extends Entity implements updateable, renderable, roidImpactEvent, abductionEvent, gameOverEvent {
  PImage model;
  PImage[] runFrames = new PImage[2];
  PImage idle;
  float runSpeed = 5;
  int direction = 1;
  String state = "idle";
  Boolean leftKey = false;
  Boolean rightKey = false;
  Boolean visible = true;
  int playerNum = 1;
  int framesTotal = 8;
  float delay = 100;

  Keys keys;

  EventManager eventManager;
  Earth earth;

  Player (EventManager _eventManager, Keys _keys, Earth _earth, int whichPlayer) {

    eventManager = _eventManager;
    earth = _earth;
    keys = _keys;

    //PImage sheet = whichPlayer==1 ? loadImage("bronto-run.png") : loadImage("oviraptor-frames.png");
    //PImage[] frames = whichPlayer==1 ? utils.sheetToSprites(sheet, 3, 1) : utils.sheetToSprites(sheet, 2, 2, 1);
    PImage sheet = whichPlayer==1 ? loadImage("bronto-frames.png") : loadImage("oviraptor-frames.png");
    PImage[] frames = whichPlayer==1 ? utils.sheetToSprites(sheet, 3, 1) : utils.sheetToSprites(sheet, 2, 2, 1);
    idle = frames[0];
    runFrames[0] = frames[1];
    runFrames[1] = frames[2];
    model = idle;
    eventManager.abductionSubscribers.add(this);
    eventManager.gameOverSubscribers.add(this);
    eventManager.roidImpactSubscribers.add(this);
    earth.addChild(this);
    x = earth.x + cos(radians(-90)) * (earth.radius + 30);
    y = earth.y + sin(radians(-90)) * (earth.radius + 30);
  }

  //void input(Keys _keys) {
  //  keys = _keys;
  //}

  void die () {
    eventManager.dispatchGameOver();
  }

  void gameOverHandle () {
    //visible = false;
  }

  void abductionHandle(PVector p) {
    println("time to disappear or something");
  }

  float getAngleFromEarth () {

    return degrees((float)Math.atan2(earth.y - y, earth.x - x));
  }

  //void setMove (int keyevent, boolean set) {
  //  switch(keyevent) {
  //  case LEFT: 
  //    leftKey = set;
  //    break;
  //  case RIGHT:
  //    rightKey = set;
  //    break;
  //  }
  //} 

  void update () {

    if (keys.left != keys.right) { // xor
      model = runFrames[utils.cycleRangeWithDelay(runFrames.length, 4, frameCount)];
      if (keys.left) {
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), runSpeed * -1));
        dr -= runSpeed;
        direction = -1;
      } else {
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), runSpeed * 1));
        dr += runSpeed;
        direction = 1;
      }
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

  void roidImpactHandle(PVector impact) {

    if (dist(x, y, impact.x, impact.y) < 26) {
      die();
    }
  }

  void render () {

    if (!visible) return;
    pushMatrix();
    scale(direction, 1);
    translate(x * direction, y);
    rotate(radians(r  * direction));
    imageMode(CENTER);
    pushStyle();
    //tint(currentColor.getColor());
    image(model, 0, 0, model.width, model.height);
    popStyle();
    popMatrix();
  }
}
