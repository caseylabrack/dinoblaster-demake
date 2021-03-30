class Earth extends Entity implements updateable, renderable {

  PGraphics tarpitDynamicMask;
  final float TARPIT_AMPLITUDE = 20;
  final float TARPIT_ARC = 45;
  float tarpitArcCenter;

  float shakeAngle;
  boolean shake = false;
  float shakeMag;

  boolean shaking = false;
  float shakingDur;
  float shakingMag;
  float shakingStart;

  final static float DEFAULT_EARTH_ROTATION = 2.3;
  final static float EARTH_RADIUS = 167;

  Time time;


  Earth (Time t) {
    time = t;

    x = 0;
    y = 0;
    dx = 0;
    dy = 0;
    dr = settings.getFloat("earthRotationSpeed", DEFAULT_EARTH_ROTATION);

    tarpitArcCenter = random(360-TARPIT_ARC);

    int side = assets.earthStuff.earth.width; // square asset
    tarpitDynamicMask = createGraphics(side, side, P2D);
    tarpitDynamicMask.noSmooth();
    tarpitDynamicMask.ellipseMode(CENTER);
    tarpitDynamicMask.beginDraw();
    tarpitDynamicMask.colorMode(HSB, 360, 100, 100, 1);
    tarpitDynamicMask.noStroke();
    tarpitDynamicMask.fill(0, 0, 0, 1);
    tarpitDynamicMask.translate(side/2, side/2);
    tarpitDynamicMask.beginShape();
    tarpitDynamicMask.vertex(cos(radians(tarpitArcCenter)) * (EARTH_RADIUS+100), sin(radians(tarpitArcCenter)) * (EARTH_RADIUS+100));
    tarpitDynamicMask.vertex(cos(radians(tarpitArcCenter + TARPIT_ARC)) * (EARTH_RADIUS + 100), sin(radians(tarpitArcCenter + TARPIT_ARC)) * (EARTH_RADIUS+100));    
    tarpitDynamicMask.vertex(cos(radians(tarpitArcCenter + TARPIT_ARC)) * (EARTH_RADIUS - 40), sin(radians(tarpitArcCenter + TARPIT_ARC)) * (EARTH_RADIUS - 40));
    tarpitDynamicMask.vertex(cos(radians(tarpitArcCenter)) * (EARTH_RADIUS-40), sin(radians(tarpitArcCenter)) * (EARTH_RADIUS-40));
    tarpitDynamicMask.endShape();
    //////tarpitDynamicMask.arc((float)side/2, (float)side/2, side, side, 0, TWO_PI * .2, CHORD);
    ////tarpitDynamicMask.arc((float)side/2, (float)side/2, side, side, radians(tarpitArcCenter), radians(tarpitArcCenter + TARPIT_ARC), CHORD);
    //tarpitDynamicMask.ellipse((float)side/2, (float)side/2, side-8, side-8);
    tarpitDynamicMask.endDraw();
  }

  void shake (float _mag) {
    shakeMag = _mag;
    shake = true;
  }

  public void shakeContinous (float _dur, float _mag) {
    shakingDur = _dur;
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
        shakeMag = 0;
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

  void ripple (float x, float y) {
    float amp = 10;
    beginShape();
    vertex(x, y);
    vertex(x - amp, y - amp);
    vertex(x - amp - amp, y);
    endShape();
  }

  void render () {
    assets.earthStuff.mask.set("mask", tarpitDynamicMask);
    //assets.earthStuff.mask.set("mask", assets.earthStuff.tarpitMask);
    shader(assets.earthStuff.mask);
    simpleRenderImage(assets.earthStuff.earth);
    resetShader();

    pushTransforms();
    pushStyle();
    //image(assets.earthStuff.earth, 0, 0);
    strokeWeight(.75);
    stroke(0, 0, 100, 1);
    fill(0, 0, 0, 1);
    //noFill();
    beginShape();
    // arc
    float arcDist = EARTH_RADIUS-10;
    vertex(cos(radians(tarpitArcCenter)) * (arcDist), sin(radians(tarpitArcCenter)) * (arcDist));
    float x, y, t, dist;
    //float amp = 5;
    //float amp = map(mouseY, 0, height, 1, 20);
    //float step = map(mouseX, 0, width, 1, 20);
    float amp = 12;
    float step = 12;
    //println("amp: " + amp + "step: " + step);
    for (int i = (int)tarpitArcCenter+10; i < tarpitArcCenter + TARPIT_ARC - 10; i+=step) {
      //float dist = (EARTH_RADIUS - 20) + (sin(i + time.getClock()/1e3) * 10);
      x = cos(radians(i)) * (arcDist - 5);
      y = sin(radians(i)) * (arcDist - 5);
      //circle(x, y, 6);
      x += cos(i + time.getClock()/1e3) * amp;
      y += sin(i + time.getClock()/1e3) * amp;
      //circle(x, y, 2);
      vertex(x, y);
    }
    vertex(cos(radians(tarpitArcCenter + TARPIT_ARC)) * (arcDist), sin(radians(tarpitArcCenter + TARPIT_ARC)) * (arcDist));

    float pit = EARTH_RADIUS - 70; 
    // chord
    float cx = cos(radians(tarpitArcCenter + TARPIT_ARC/2)) * (arcDist * .75);
    float cy = sin(radians(tarpitArcCenter + TARPIT_ARC/2)) * (arcDist * .75);
    float offset = tarpitArcCenter + TARPIT_ARC * 2;
    for (int i = 0; i < 200; i+=35) { 
      vertex(cx + cos(radians(i + offset)) * 50, cy + sin(radians(i + offset)) * 50);
    }
    //vertex(cos(radians(tarpitArcCenter + TARPIT_ARC)) * (pit), sin(radians(tarpitArcCenter + TARPIT_ARC)) * (pit));
    //vertex(cos(radians(tarpitArcCenter)) * (pit), sin(radians(tarpitArcCenter)) * (pit));
    endShape(CLOSE);
    //endShape();

    float rippleDist1 = EARTH_RADIUS - 40;
    float rippleDist2 = EARTH_RADIUS - 70;
    beginShape();
    for (int i = (int)tarpitArcCenter+5; i < tarpitArcCenter + 20; i+=4) {
      //dist = (EARTH_RADIUS - 20) + (sin(i + time.getClock()/1e3) * 5);
      dist = (rippleDist1 + floor(sin(time.getClock()/1e3)) * 6) + (sin(i) * 5);
      x = cos(radians(i)) * dist;
      y = sin(radians(i)) * dist;
      vertex(x, y);
    }
    endShape();

    beginShape();
    for (int i = (int)tarpitArcCenter+30; i < tarpitArcCenter + TARPIT_ARC - 5; i+=4) {
      //dist = (EARTH_RADIUS - 20) + (sin(i + time.getClock()/1e3) * 5);
      dist = (rippleDist1 + floor(cos(time.getClock()/1e3)) * 6) + (sin(i) * 5);
      x = cos(radians(i)) * dist;
      y = sin(radians(i)) * dist;
      vertex(x, y);
    }
    endShape();

    beginShape();
    for (int i = (int)(tarpitArcCenter + TARPIT_ARC/2 - 10); i < tarpitArcCenter + TARPIT_ARC/2 + 10; i+=4) {
      //dist = (EARTH_RADIUS - 40) + (sin(i + time.getClock()/1e3) * 5);
      dist = (rippleDist2 + floor(sin(time.getClock()/1e3 + .5e3)) * 6) + (sin(i) * 5);
      x = cos(radians(i)) * dist;
      y = sin(radians(i)) * dist;
      vertex(x, y);
    }
    endShape();

    popMatrix();
    popStyle();
  }
}
