class Earth extends Entity implements gameOverEvent, updateable, renderable {
  PImage model;
  PShape modelV;
  float radius;

  float shakeAngle;
  boolean shake = false;
  float shakeMag;

  boolean shaking = false;
  float shakingDur;
  float shakingMag;
  float shakingStart;

  EventManager eventManager;
  Time time;

  Earth (EventManager ev, Time t) {
    eventManager = ev;
    time = t;

    x = 0;
    y = 0;
    dx = 1;
    dy = 0;
    dr = 2.3;

    model = loadImage("earth-fill.png");
    radius = model.width/2;

    eventManager.gameOverSubscribers.add(this);
  }

  void gameOverHandle () {
    //rx = 0;
  }

  void shake (float _mag) {
    shakeMag += _mag;
    shake = true;
  }

  void shakeContinous (float _dur, float _mag) {
    shakingDur += _dur;
    shakingMag = _mag;
    shakingStart = time.getClock();
    shaking = true;
  }

  void update() {

    dx = 0 - x;
    dy = 0 - y;

    if (shake) {
      shakeAngle = random(0, TWO_PI);
      dx += cos(shakeAngle) * shakeMag;
      dy += sin(shakeAngle) * shakeMag;
      shakeMag *= .9;
      if (shakeMag < .1) {
        shakeMag =0;
        shake = false;
      }
    } 

    if (shaking) {
      shakeAngle = random(0, TWO_PI);
      dx += cos(shakeAngle) * shakingMag;
      dy += sin(shakeAngle) * shakingMag;
      if (time.getClock() - shakingStart > shakingDur) {
        shaking = false;
      }
    }

    x += dx * time.getTimeScale();
    y += dy * time.getTimeScale();
    r += dr * time.getTimeScale();
  }

  void render () {
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
