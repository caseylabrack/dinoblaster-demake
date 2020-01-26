class UFOManager implements updateable, renderable {

  PShape model;
  //PImage model;
  ColorDecider currentColor;
  ArrayList<UFO> ufos = new ArrayList<UFO>();
  Earth earth;

  UFOManager (ColorDecider _color, Earth _earth) {

    currentColor = _color;
    earth = _earth;

    //model = loadImage("ufo.png");
    model = loadShape("UFO.svg");
    model.disableStyle();

    //spawnUFOAbducting();
  }

  void spawnUFOAbducting () {

    ufos.add(new UFO(currentColor, model, earth));
  }

  void spawnUFOReturning () {
  }

  void update () {
    for (UFO u : ufos) u.update();
  }

  void render () {
    for (UFO u : ufos) u.render();
  }
}



class UFO extends Entity implements updateable, renderable {

  PShape model;
  //PImage model;
  ColorDecider currentColor;
  Earth earth;

  final static int INTO_VIEW = 0;
  final static int APPROACHING = 1;
  final static int CIRCLING = 2;
  final static int SCANNING = 3;
  final static int SNATCHING = 4;
  final static int LEAVING = 5;
  int state = INTO_VIEW;

  final float normalSize = 64;
  final float startSize = 500;
  final float startDist = 1200;
  final float finalDist = 200;
  float currentSize = startSize;
  final float approachTime = 4 * 1e3;
  float startApproach;

  final float circlingMaxSpeed = 3;
  float speed = circlingMaxSpeed;
  final float circlingTime = 4 * 1e3;
  float startCircling;

  float progress, dist, angle;

  UFO (ColorDecider _color, PShape _model, Earth _earth) {
    //UFO (ColorDecider _color, PImage _model) {

    currentColor = _color;
    model = _model;
    earth = _earth;

    float angle = random(0, 360);
    //x = width/2 + cos(angle) * startDist;
    //y = height/2 + sin(angle) * startDist;
    x = earth.x + cos(angle) * startDist;
    y = earth.y + sin(angle) * startDist;
    startApproach = millis();
  }

  void update() {


    switch(state) {

    case INTO_VIEW:
      dist = dist(x, y, earth.x, earth.y);
      if (dist > 500) {
        angle = (float)Math.atan2(y - earth.y, x - earth.x);
        x = earth.x + cos(angle) * (dist-2);
        y = earth.y + sin(angle) * (dist-2);
      } else {
        state = APPROACHING;
        startApproach = millis();
      }
            println("into view", dist);

      break;

    case APPROACHING:
      println("approach: ", startApproach);
      progress = (millis() - startApproach)  / approachTime;
      dist = dist(x, y, earth.x, earth.y);
      if (progress < 1) {
        //currentSize = (1 - progress) * 500 + normalSize;
        currentSize = utils.easeInOutExpo(progress * 100, startSize, normalSize - startSize, 100);
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), progress * circlingMaxSpeed * -1));
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
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), (1 - progress) * circlingMaxSpeed * -1));
      } else {
        state = SCANNING;
      }
      break;

    case SCANNING:
      break;

    default:
      println("wut");
      break;
    }

    x += dx;
    y += dy;
    r += dr;

    dx = dy = dr = 0;
  }

  void render () {

    //float resize = map(mouseX, 0, width, 1, width);

    pushStyle();
    noFill();
    strokeWeight(1 * 128/currentSize);
    stroke(currentColor.getColor());
    //tint(currentColor.getColor());
    pushMatrix();
    //translate(width/2,height/2);
    shapeMode(CENTER);
    //image(model, x, y, currentSize, currentSize);
    shape(model, x, y, currentSize, currentSize);
    popMatrix();
    popStyle();
  }
}
