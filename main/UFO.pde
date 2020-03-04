class UFOManager implements updateable, renderable {

  PImage brontoAbductionSheet;
  PImage[] brontoAbductionFrames = new PImage[9];
  PImage model;
  PImage ufoSheet;
  PImage[] ufoFrames = new PImage[9];
  ColorDecider currentColor;
  UFO ufo = null;
  Earth earth;
  Player player;
  EventManager eventManager;

  UFOManager (ColorDecider _color, Earth _earth, Player _player, EventManager _ev) {

    currentColor = _color;
    earth = _earth;
    player = _player;
    eventManager = _ev;

    model = loadImage("UFO.png");

    ufoSheet = loadImage("ufo-resizing-sheet.png");
    ufoFrames = utils.sheetToSprites(ufoSheet, 3, 3);

    brontoAbductionSheet = loadImage("bronto-abduction-sheet.png");
    brontoAbductionFrames = utils.sheetToSprites(brontoAbductionSheet, 3, 3);
  }

  void spawnUFOAbducting () {

    ufo = new UFO(currentColor, brontoAbductionFrames, earth, player, ufoFrames, eventManager);
  }

  void spawnUFOReturning () {
  }

  void update () {
    if (ufo!=null) {
      ufo.update();
      if (ufo.state==ufo.DONE) {
        ufo = null;
      }
    }
  }

  void render () {
    if (ufo!=null) ufo.render();
  }
}



class UFO extends Entity implements updateable, renderable {

  //PShape model;
  PShape lilBronto;
  PImage[] brontoAbductionFrames;
  PImage[] ufoFrames;
  PImage model;
  PImage modelBig;
  ColorDecider currentColor;
  Earth earth;
  Player player;

  final static int INTO_VIEW = 0;
  final static int APPROACHING = 1;
  final static int CIRCLING = 2;
  final static int SCANNING = 3;
  final static int SNATCHING = 4;
  final static int LEAVING = 5;
  final static int DONE = 6;
  int state = INTO_VIEW;

  final static int initialDist = 1000;
  final static int initialSpeed = 3;
  final static int initialRotate = 1;

  final float normalSize = 64;
  final float startSize = 500;
  final float startDist = 530;
  final float finalDist = 300;
  float currentSize = startSize;
  final float approachTime = 1e3;
  float startApproach;

  final float circlingMaxSpeed = 3;
  float speed = circlingMaxSpeed;
  final float circlingTime = 2e3;//2 * 1e3;
  float startCircling;

  //float scanningStart = 0;
  final float scanningStartDelay = 1e3;
  final float scanningTransitioning = 2e3;
  final float scanningPause = 1e3;
  final float maxBeamWidth = 15;
  float beamWidth = 0;

  final float scanDuration = scanningStartDelay + scanningTransitioning + scanningPause + scanningTransitioning + 2e3;
  float scanstart = 0;

  final float snatchMargin = 10;

  final float snatchDuration = 3e3;
  float snatchStart = 0;
  PVector snatchStartPos = new PVector();
  PVector lilBrontoPos = new PVector();
  int lilBrontoFacingDirection = -1;
  float lilBrontoAngle = 0;

  float progress, dist, angle;

  EventManager eventManager;

  UFO (ColorDecider _color, PImage[] _brontoAbductionFrames, Earth _earth, Player _player, PImage[] _ufoFrames, EventManager _ev) {

    currentColor = _color;
    earth = _earth;
    ufoFrames = _ufoFrames;
    player = _player;
    brontoAbductionFrames = _brontoAbductionFrames;
    eventManager = _ev;

    model = ufoFrames[0];

    float angle = random(0, 360);
    x = earth.x + cos(angle) * initialDist;
    y = earth.y + sin(angle) * initialDist;
    startApproach = millis();
  }

  void init() {
  }

  void update() {

    switch(state) {

    case INTO_VIEW:
      dist = dist(x, y, earth.x, earth.y);
      if (dist > startDist) {
        angle = (float)Math.atan2(y - earth.y, x - earth.x);
        x = earth.x + cos(angle) * (dist-initialSpeed);
        y = earth.y + sin(angle) * (dist-initialSpeed);
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), initialRotate * -1));
      } else {
        state = APPROACHING;
        startApproach = millis();
      }

      break;

    case APPROACHING:
      progress = (millis() - startApproach)  / approachTime;
      //dist = dist(x, y, earth.x, earth.y);
      if (progress < 1) {
        //model = ufoFrames[floor(progress * 9)];
        model = ufoFrames[floor(utils.easeInQuad(progress, 0, 9, 1))];
        //currentSize = utils.easeInOutExpo(progress * 100, startSize, normalSize - startSize, 100);
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), (progress * circlingMaxSpeed + initialRotate) * -1));
        angle = (float)Math.atan2(y - earth.y, x - earth.x);
        dist = utils.easeOutQuad(progress, startDist, -(startDist - finalDist), 1);
        x = earth.x + cos(angle) * dist;
        y = earth.y + sin(angle) * dist;
      } else {
        state = CIRCLING;
        startCircling = millis();
      }
      break;

    case CIRCLING:
      progress = (millis() - startCircling)  / circlingTime;
      if (progress < 1) {
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), utils.easeOutQuad((1 - progress), initialRotate, circlingMaxSpeed + initialRotate, 1) * -1));
        //setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), ((1 - progress) * (circlingMaxSpeed + initialRotate)) * -1));
      } else {
        scanstart = millis();
        state = SCANNING;
      }
      break;

    case SCANNING:
      if (millis() - scanstart < scanDuration) {
        if (millis() - scanstart > scanningStartDelay + scanningTransitioning && millis() - scanstart < scanningStartDelay + scanningTransitioning + scanningPause) {
          //println("scanning");
          if (utils.unsignedAngleDiff(player.getAngleFromEarth(), degrees((float)Math.atan2(earth.y - y, earth.x - x))) < snatchMargin) {
            snatchStart = millis();
            snatchStartPos = player.getPosition();
            lilBrontoFacingDirection = player.direction;
            state = SNATCHING;
            lilBrontoAngle = player.r;
            eventManager.dispatchAbduction(player.getPosition());
          }
        }
      } else {
        state = LEAVING;
      }
      break;

    case SNATCHING:
      progress = (millis() - snatchStart)  / snatchDuration;
      if (progress <= 1) {
        lilBrontoPos.set(PVector.lerp(snatchStartPos, getPosition(), progress));
      } else {
        state = LEAVING;
      }
      break;

    case LEAVING:
      dist = dist(x, y, earth.x, earth.y);
      if (dist < 2000) {
        angle = (float)Math.atan2(y - earth.y, x - earth.x);
        x = earth.x + cos(angle) * (dist+initialSpeed);
        y = earth.y + sin(angle) * (dist+initialSpeed);
      } else {
        state = DONE;
      }
      break;

    case DONE:
      break;

    default:
      println("ufo state wut");
      break;
    }

    x += dx;
    y += dy;
    r += dr;

    dx = dy = dr = 0;
  }

  void render () {

    if (state==SCANNING) {
      pushStyle();
      stroke(currentColor.getColor());
      float angle = degrees(atan2(earth.y - y, earth.x - x));
      float scantime = millis() - scanstart;
      if (scantime < scanningStartDelay) {
        //line(x, y, x + cos(radians(angle)) * 250, y + sin(radians(angle)) * 250);
      }
      if (scantime > scanningStartDelay && scantime < scanningStartDelay + scanningTransitioning) {
        beamWidth = utils.easeInExpo((scantime - scanningStartDelay)/scanningTransitioning, 0, maxBeamWidth, 1);
        line(x, y, x + cos(radians(angle + beamWidth)) * 250, y + sin(radians(angle + beamWidth)) * 250);
        line(x, y, x + cos(radians(angle - beamWidth)) * 250, y + sin(radians(angle - beamWidth)) * 250);
      }
      if (scantime > scanningStartDelay + scanningTransitioning && scantime < scanningStartDelay + scanningTransitioning + scanningPause) {
        line(x, y, x + cos(radians(angle + maxBeamWidth)) * 250, y + sin(radians(angle + maxBeamWidth)) * 250);
        line(x, y, x + cos(radians(angle - maxBeamWidth)) * 250, y + sin(radians(angle - maxBeamWidth)) * 250);
      }
      if (scantime > scanningStartDelay + scanningTransitioning + scanningPause && scantime < scanningStartDelay + scanningTransitioning + scanningPause + scanningTransitioning) {
        beamWidth = utils.easeInQuad(((scantime - scanningStartDelay - scanningTransitioning - scanningPause)/scanningTransitioning), maxBeamWidth, -maxBeamWidth, 1);
        line(x, y, x + cos(radians(angle + beamWidth)) * 250, y + sin(radians(angle + beamWidth)) * 250);
        line(x, y, x + cos(radians(angle - beamWidth)) * 250, y + sin(radians(angle - beamWidth)) * 250);
      }
      popStyle();
    }

    if (state==SNATCHING) {
      pushStyle();
      noFill();
      stroke(currentColor.getColor());
      float angle = degrees(atan2(earth.y - y, earth.x - x));
      line(x, y, x + cos(radians(angle + maxBeamWidth)) * 250, y + sin(radians(angle + maxBeamWidth)) * 250);
      line(x, y, x + cos(radians(angle - maxBeamWidth)) * 250, y + sin(radians(angle - maxBeamWidth)) * 250);

      pushMatrix();
      scale(lilBrontoFacingDirection, 1);
      translate(lilBrontoPos.x * lilBrontoFacingDirection, lilBrontoPos.y);
      rotate(radians(lilBrontoAngle  * lilBrontoFacingDirection));
      imageMode(CENTER);      
      progress = (millis() - snatchStart)  / snatchDuration;
      image(brontoAbductionFrames[ceil(progress * 8)], 0, 0);
      popMatrix();
      popStyle();
    }

    pushStyle();
    noFill();
    tint(currentColor.getColor());
    pushMatrix();
    fill(0, 0, 0);
    imageMode(CENTER);
    image(model, x, y);
    popMatrix();
    popStyle();
  }
}
