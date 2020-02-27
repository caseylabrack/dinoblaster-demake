class UFOManager implements updateable, renderable {

  //PShape model;
  PShape lilBronto;
  PImage brontoAbductionSheet;
  PImage[] brontoAbductionFrames = new PImage[9];
  PImage model;
  PImage modelBig;
  PImage ufoSheet;
  PImage[] ufoFrames = new PImage[9];
  ColorDecider currentColor;
  ArrayList<UFO> ufos = new ArrayList<UFO>();
  Earth earth;
  Player player;

  UFOManager (ColorDecider _color, Earth _earth, Player _player) {

    currentColor = _color;
    earth = _earth;
    player = _player;

    //model = loadShape("UFO.svg");
    //model.disableStyle();
    model = loadImage("UFO.png");
    modelBig = loadImage("UFO-big.png");

    ufoSheet = loadImage("ufo-resizing-sheet.png");
    ufoFrames = utils.sheetToSprites(ufoSheet, 3, 3);

    lilBronto = loadShape("bronto.svg");
    lilBronto.disableStyle();

    brontoAbductionSheet = loadImage("bronto-abduction-sheet.png");
    brontoAbductionFrames = utils.sheetToSprites(brontoAbductionSheet, 3, 3);

    //spawnUFOAbducting();
  }

  void spawnUFOAbducting () {

    ufos.add(new UFO(currentColor, model, brontoAbductionFrames, earth, player, ufoFrames));
  }

  void spawnUFOReturning () {
  }

  void update () {
    for (UFO u : ufos) u.update();
  }

  void render () {
    //image(brontoAbductionFrames[0], 0, -200);
    for (UFO u : ufos) u.render();
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
  int state = INTO_VIEW;

  final static int initialDist = 1000;
  final static int initialSpeed = 3;
  final static int initialRotate = 1;

  final float normalSize = 64;
  final float startSize = 500;
  final float startDist = height/2 + startSize/2 - 50;
  final float finalDist = 300;
  float currentSize = startSize;
  final float approachTime = 4e3;
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

  final float snatchMargin = 3;

  final float snatchDuration = 5e3;
  float snatchStart = 0;
  PVector snatchStartPos = new PVector();
  PVector lilBrontoPos = new PVector();
  int lilBrontoFacingDirection = -1;
  float lilBrontoNativeSize = 64;
  float lilBrontoSize = lilBrontoNativeSize;

  float progress, dist, angle;


  UFO (ColorDecider _color, PImage _model, PImage[] _brontoAbductionFrames, Earth _earth, Player _player, PImage[] _ufoFrames) {

    currentColor = _color;
    model = _model;
    //modelBig = _modelBig;
    earth = _earth;
    //lilBronto = _bronto;
    ufoFrames = _ufoFrames;
    player = _player;
    brontoAbductionFrames = _brontoAbductionFrames;

    float angle = random(0, 360);
    x = earth.x + cos(angle) * initialDist;
    y = earth.y + sin(angle) * initialDist;
    startApproach = millis();
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
      dist = dist(x, y, earth.x, earth.y);
      if (progress < 1) {
        model = ufoFrames[ceil(progress * 8)];
        currentSize = utils.easeInOutExpo(progress * 100, startSize, normalSize - startSize, 100);
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), (progress * circlingMaxSpeed + initialRotate) * -1));
        angle = (float)Math.atan2(y - earth.y, x - earth.x);
        x = earth.x + cos(angle) * ((startDist-finalDist) * (1-progress) + finalDist);
        y = earth.y + sin(angle) * ((startDist-finalDist) * (1-progress) + finalDist);
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
        if (utils.unsignedAngleDiff(player.getAngleFromEarth(), degrees((float)Math.atan2(earth.y - y, earth.x - x))) < snatchMargin) {
          snatchStart = millis();
          snatchStartPos = player.getPosition();
          lilBrontoFacingDirection = player.direction;
          state = SNATCHING;
        }
      } else {
        state = LEAVING;
      }
      break;

    case SNATCHING:
      progress = (millis() - snatchStart)  / snatchDuration;
      if (progress <= 1) {
        lilBrontoPos.set(PVector.lerp(snatchStartPos, getPosition(), progress));
        lilBrontoSize = (1 - progress) * lilBrontoNativeSize;
      } else {
        state = LEAVING;
      }
      break;

    case LEAVING:
      dist = dist(x, y, earth.x, earth.y);
      angle = (float)Math.atan2(y - earth.y, x - earth.x);
      x = earth.x + cos(angle) * (dist+initialSpeed);
      y = earth.y + sin(angle) * (dist+initialSpeed);
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
      float angle = degrees(atan2(earth.y - y, earth.x - x));
      float scantime = millis() - scanstart;
      if (scantime < scanningStartDelay) {
        line(x, y, x + cos(radians(angle)) * 250, y + sin(radians(angle)) * 250);
      }
      if (scantime > scanningStartDelay && scantime < scanningStartDelay + scanningTransitioning) {
        beamWidth = utils.easeOutExpo((scantime - scanningStartDelay)/scanningTransitioning, 0, maxBeamWidth, 1);
        line(x, y, x + cos(radians(angle + beamWidth)) * 250, y + sin(radians(angle + beamWidth)) * 250);
        line(x, y, x + cos(radians(angle - beamWidth)) * 250, y + sin(radians(angle - beamWidth)) * 250);
      }
      if (scantime > scanningStartDelay + scanningTransitioning && scantime < scanningStartDelay + scanningTransitioning + scanningPause) {
        line(x, y, x + cos(radians(angle + beamWidth)) * 250, y + sin(radians(angle + beamWidth)) * 250);
        line(x, y, x + cos(radians(angle - beamWidth)) * 250, y + sin(radians(angle - beamWidth)) * 250);
      }
      if (scantime > scanningStartDelay + scanningTransitioning + scanningPause && scantime < scanningStartDelay + scanningTransitioning + scanningPause + scanningTransitioning) {
        beamWidth = utils.easeInExpo(((scantime - scanningStartDelay - scanningTransitioning - scanningPause)/scanningTransitioning), maxBeamWidth, -maxBeamWidth, 1);
        line(x, y, x + cos(radians(angle + beamWidth)) * 250, y + sin(radians(angle + beamWidth)) * 250);
        line(x, y, x + cos(radians(angle - beamWidth)) * 250, y + sin(radians(angle - beamWidth)) * 250);
      }
    }

    if (state==SNATCHING) {
      pushStyle();
      noFill();
      float angle = degrees(atan2(earth.y - y, earth.x - x));
      line(x, y, x + cos(radians(angle + maxBeamWidth)) * 250, y + sin(radians(angle + maxBeamWidth)) * 250);
      line(x, y, x + cos(radians(angle - maxBeamWidth)) * 250, y + sin(radians(angle - maxBeamWidth)) * 250);

      //strokeWeight(1 * lilBronto.width/max(.05, lilBrontoSize));
      //strokeWeight(1 * lilBrontoNativeSize/max(.05, lilBrontoSize));
      pushMatrix();
      imageMode(CENTER);
      progress = (millis() - snatchStart)  / snatchDuration;
      image(brontoAbductionFrames[ceil(progress * 8)], lilBrontoPos.x, lilBrontoPos.y);
      //scale(direction, 1);
      //rotate(radians(0  * lilBrontoFacingDirection));
      //shapeMode(CENTER);
      //shape(lilBronto, lilBrontoPos.x, lilBrontoPos.y, lilBrontoSize, lilBrontoSize * (lilBronto.height / lilBronto.width));
      popMatrix();
      popStyle();
    }

    pushStyle();
    noFill();
    //strokeWeight(1);
    //strokeWeight(1 * model.width/currentSize);
    //stroke(currentColor.getColor());
    tint(currentColor.getColor());
    pushMatrix();
    fill(0, 0, 0);
    imageMode(CENTER);
    //shapeMode(CENTER);
    image(model, x, y);
    //if (state <= APPROACHING) {
    //  image(model, x, y, currentSize, currentSize * (float)model.height/(float)model.width);
    //} else {
    //  image(model, x, y);
    //}

    //shape(model, x, y);
    //shape(model, x, y, currentSize, currentSize * (model.height/model.width));
    popMatrix();
    popStyle();
  }
}
