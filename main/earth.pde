class Earth extends Entity implements gameOverEvent, updateable, renderable {
  PImage model;
  //PGraphics model;
  PShape modelV;
  float radius;

  float shakeAngle;
  boolean shake = false;
  float shakeMag;

  boolean shaking = false;
  float shakingDur;
  float shakingMag;
  float shakingStart;
  
  GameMode mode;

  Earth (GameMode _mode, float xpos, float ypos) {
    x = xpos;
    y = ypos;
    dx = 0;
    dy = 0;
    dr = 3;//2.3;
    //modelV = loadShape("earth.svg");
    //model = createGraphics(50,50);
    //model.beginDraw();
    model = loadImage("earth4.png");
    radius = model.width/2;
    mode = _mode;
    mode.eventManager.gameOverSubscribers.add(this);
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
    shakingStart = millis();
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
      if (millis() - shakingStart > shakingDur) {
        shaking = false;
      }
    }
    
    x += dx;
    y += dy;
    r += dr;
    updateChildren();
  }

  void render () {
    pushMatrix();
    rotate(radians(r));
    imageMode(CENTER);
    image(model, 0, 0, model.width, model.height);
    //pushStyle();
    //stroke(30,60,60);
    //noFill();
    //line(0, 0, 0, radius);
    //popStyle();
    popMatrix();
  }
}
