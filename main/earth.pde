class Earth extends Entity implements updateable, renderable {

  PGraphics tarpitDynamicMask;
  final float TARPIT_AMPLITUDE = 20;
  final float TARPIT_ARC = 45;
  float tarpitArcStart;

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

    tarpitArcStart = random(360-TARPIT_ARC);

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
    tarpitDynamicMask.vertex(cos(radians(tarpitArcStart)) * (EARTH_RADIUS+100), sin(radians(tarpitArcStart)) * (EARTH_RADIUS+100));
    tarpitDynamicMask.vertex(cos(radians(tarpitArcStart + TARPIT_ARC)) * (EARTH_RADIUS + 100), sin(radians(tarpitArcStart + TARPIT_ARC)) * (EARTH_RADIUS+100));    
    tarpitDynamicMask.vertex(cos(radians(tarpitArcStart + TARPIT_ARC)) * (EARTH_RADIUS - 40), sin(radians(tarpitArcStart + TARPIT_ARC)) * (EARTH_RADIUS - 40));
    tarpitDynamicMask.vertex(cos(radians(tarpitArcStart)) * (EARTH_RADIUS-40), sin(radians(tarpitArcStart)) * (EARTH_RADIUS-40));
    tarpitDynamicMask.endShape();
    tarpitDynamicMask.endDraw();
    assets.earthStuff.mask.set("mask", tarpitDynamicMask);
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
    shader(assets.earthStuff.mask);
    simpleRenderImage(assets.earthStuff.earth);
    resetShader();

    pushTransforms();
    pushStyle();
    strokeWeight(.75);
    stroke(0, 0, 100, 1);
    fill(0, 0, 0, 1);
    beginShape();

    // tarpit surface
    float arcDist = EARTH_RADIUS - 10;
    vertex(cos(radians(tarpitArcStart)) * (arcDist), sin(radians(tarpitArcStart)) * (arcDist));
    float x, y, t, dist;
    float amp = 9.613;
    float step = 12;
    float phase = 1.822;
    //float phase = map(mouseX, 0, width, .1, 5.0);
    //float phase = map(mouseX, 0, width, 0, TWO_PI);
    //amp = map(mouseY, 0, height, .1, 12);
    //println("phase: " + phase + " amp: " + amp);
    for (int i = (int)tarpitArcStart+10; i < tarpitArcStart + TARPIT_ARC - 10; i+=step) {
      //float dist = (EARTH_RADIUS - 20) + (sin(i + time.getClock()/1e3) * 10);
      x = cos(radians(i)) * (arcDist);
      y = sin(radians(i)) * (arcDist);
      //circle(x, y, 6);
      x += cos(i * phase + time.getClock()/1e3) * amp;
      y += sin(i * phase + time.getClock()/1e3) * amp;
      //circle(x, y, 2);
      vertex(x, y);
    }
    vertex(cos(radians(tarpitArcStart + TARPIT_ARC)) * (arcDist), sin(radians(tarpitArcStart + TARPIT_ARC)) * (arcDist));

    // tarpit floor
    float cx = cos(radians(tarpitArcStart + TARPIT_ARC/2)) * (arcDist * .75);
    float cy = sin(radians(tarpitArcStart + TARPIT_ARC/2)) * (arcDist * .75);
    float offset = tarpitArcStart + TARPIT_ARC * 2;
    for (int i = 0; i < 200; i+=35) { 
      vertex(cx + cos(radians(i + offset)) * 60, cy + sin(radians(i + offset)) * 60);
    }
    endShape(CLOSE);

    // tarpit doodads
    float ang = tarpitArcStart + TARPIT_ARC - 8;
    float d = (EARTH_RADIUS - 65) + (floor(sin(radians(0) + time.getClock()/1e3)) * 5); // bob up and down in a square wave
    pushMatrix();
    translate(cos(radians(ang)) * d, sin(radians(ang)) * d);
    rotate(radians(tarpitArcStart + 200));
    image(assets.earthStuff.doodadHead, 0, 0);
    popMatrix();

    ang = tarpitArcStart + 15;
    d = (EARTH_RADIUS - 85) + (floor(sin(radians(60) + time.getClock()/1e3)) * 5); // bob up and down in a square wave
    pushMatrix();
    translate(cos(radians(ang)) * d, sin(radians(ang)) * d);
    rotate(radians(tarpitArcStart + 90));
    image(assets.earthStuff.doodadRibs, 0, 0);
    popMatrix();

    ang = tarpitArcStart + 10;
    d = (EARTH_RADIUS - 55) + (floor(sin(radians(120) + time.getClock()/1e3)) * 5); // bob up and down in a square wave
    pushMatrix();
    translate(cos(radians(ang)) * d, sin(radians(ang)) * d);
    rotate(radians(tarpitArcStart + 180));
    image(assets.earthStuff.doodadBone, 0, 0);
    popMatrix();

    //ang = tarpitArcStart + 10;
    //d = (EARTH_RADIUS - 50) + (floor(sin(radians(180) + time.getClock()/1e3)) * 5); // bob up and down in a square wave
    //pushMatrix();
    //translate(cos(radians(ang)) * d, sin(radians(ang)) * d);
    //rotate(radians(tarpitArcStart + 90));
    //image(assets.earthStuff.doodadFemur, 0, 0);
    //popMatrix();

    //float rippleDist1 = EARTH_RADIUS - 30;
    //float rippleDist2 = EARTH_RADIUS - 40;
    //beginShape();
    //for (int i = (int)tarpitArcStart+5; i < tarpitArcStart + 20; i+=4) {
    //  //dist = (EARTH_RADIUS - 20) + (sin(i + time.getClock()/1e3) * 5);
    //  dist = (rippleDist1 + floor(sin(time.getClock()/1e3)) * 6) + (sin(i) * 5);
    //  x = cos(radians(i)) * dist;
    //  y = sin(radians(i)) * dist;
    //  vertex(x, y);
    //}
    //endShape();

    //beginShape();
    //for (int i = (int)tarpitArcStart+30; i < tarpitArcStart + TARPIT_ARC - 5; i+=4) {
    //  //dist = (EARTH_RADIUS - 20) + (sin(i + time.getClock()/1e3) * 5);
    //  dist = (rippleDist1 + floor(cos(time.getClock()/1e3)) * 6) + (sin(i) * 5);
    //  x = cos(radians(i)) * dist;
    //  y = sin(radians(i)) * dist;
    //  vertex(x, y);
    //}
    //endShape();

    popMatrix();
    popStyle();
  }
}
