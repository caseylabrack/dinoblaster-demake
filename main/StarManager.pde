class StarManager implements updateable, renderable, renderableScreen, nebulaStartEvent {

  PVector[] stars = new PVector[800];
  float r = 2000;
  float a = 180;
  float x, y;
  final float defaultStarSpeed = TWO_PI / (360 * 40);
  float starSpeed = defaultStarSpeed;

  PVector nebulaPos;
  boolean nebulaActive = false;
  final float nebulaLead = 15;
  final float nebulaOffset = -150;

  ColorDecider currentColor;
  Time time;
  EventManager events;

  Hypercube hypercube;
  boolean hyperspace = false;

  StarManager (ColorDecider _color, Time t, EventManager evs) {

    currentColor = _color;
    time = t;
    events = evs;

    int k = 0;
    for (int j = 0; j < 360; j+= 9) {
      for (int i = 0; i < 20; i++) {
        stars[k] = new PVector(cos(a+j) * r + random(-width/2, width/2), sin(a+j)*r + random(-height/2, height/2));
        k++;
      }
    }

    evs.nebulaStartSubscribers.add(this);

    spawnNeb();
  }

  void nebulaStartHandle() {
    hyperspace = true;
    starSpeed = defaultStarSpeed * 5;
  }

  void spawnNeb () {
    nebulaActive = true;
    hypercube = new Hypercube(currentColor);
    nebulaPos = new PVector(cos(a + radians(nebulaLead)) * (r + nebulaOffset), sin(a + radians(nebulaLead)) * (r + nebulaOffset));
  }

  void update () {
    a += starSpeed * time.getTimeScale();
  }

  PVector nebulaPosition () {
    return nebulaActive ? new PVector(nebulaPos.x - x, nebulaPos.y - y) : new PVector(Float.MAX_VALUE, Float.MAX_VALUE);
  }

  void render () {

    x = (cos(a) * r) ;
    y = (sin(a) * r) ;
    pushStyle();
    pushMatrix();
    noStroke();
    fill(0, 0, 100);
    for (PVector s : stars) {
      if (abs(s.x - x) < width && abs(s.y - y) < height) {
        pushMatrix();
        //rotate(TWO_PI/8);
        square(s.x - x, s.y - y, 2);
        //circle(nebulaPos.x - x, nebulaPos.y - y, 25);

        popMatrix();
      }
    }
    pushMatrix();
    //rotate(TWO_PI/8);
    translate(nebulaPos.x - x, nebulaPos.y - y);
    popStyle();
    hypercube.update();
    pushStyle();
    noFill();
    if (hyperspace) {
      stroke(40, 50, 70);
      strokeWeight(10);
    } else {
      stroke(0, 50, 70);
    }
    ellipse(0, 0, 225, 225);
    popStyle();
    popMatrix();

    //image(nebulaModel, nebulaPos.x - x, nebulaPos.y - y);
    popMatrix();


    //if (nebulaActive) {
    //  x = nebulaPos.x - (cos(a) * r - width / 2);
    //  y = nebulaPos.y - (sin(a) * r - height / 2);

    //  if (x>-640 && x < width + 640 && y > -640 && y < height + 640) {
    //    pushStyle();
    //    pushMatrix();
    //    translate(x, y);
    //    tint(currentColor.getColor());
    //    image(nebulaModel, 0, 0);
    //    popMatrix();
    //    popStyle();
    //  }
    //}
  }
}
