

class Orbiter extends Entity implements updateable {
  float cx, cy, radius, angle, angleStep;
  Orbiter (float _x, float _y, float _cx, float _cy, float _step) {
    x = _x;
    y = _y;
    cx = _cx;
    cy = _cy;
    angleStep = _step;
    angle = atan2(y - cy, x - cx);
    radius = dist(x, y, cx, cy);
  }

  void update () {
    dx = cos(angle) * radius - x;
    dy = sin(angle) * radius - y;
    angle += angleStep;

    x += dx;
    y += dy;

    updateChildren();
    //for (Entity child : children) {
    //  child.dx += dx;
    //  child.dy += dy;
    //}

    //pushMatrix();
    //translate(width/2 + x - camera.x, height/2 + y - camera.y);
    //circle(width/2, height/2, 10);
    //popMatrix();
  }
}

class Earth extends Entity implements gameOverEvent, updateable, renderable {
  PImage model;
  float radius;

  float shakeAngle;
  boolean shake = false;
  float shakeMag;

  boolean shaking = false;
  float shakingDur;
  float shakingMag;
  float shakingStart;

  Earth (float xpos, float ypos) {
    x = xpos;
    y = ypos;
    dx = 0;
    dy = 0;
    dr = 2.3;
    model = loadImage("earth.png");
    radius = (model.width/2) * .5 - 5;
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
    shakingStart = millis();
    shaking = true;
  }

  void update() {

    dx = width/2 - x;
    dy = height/2 - y;

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
    translate(width/2 + x - camera.x, height/2 + y - camera.y);
    rotate(radians(r));
    imageMode(CENTER);
    image(model, 0, 0, model.width*.5, model.height*.5);
    popMatrix();
  }
}
