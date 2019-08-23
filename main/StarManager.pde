class StarManager implements updateable, renderable {

  PVector[] stars = new PVector[800];
  float r = 2000;
  float a = 0;
  float x, y;

  StarManager () {

    int k = 0;
    for (int j = 0; j < 360; j+= 9) {
      for (int i = 0; i < 20; i++) {
        stars[k] = new PVector(cos(a+j) * r + random(-width/2, width/2), sin(a+j)*r + random(-height/2, height/2));
        k++;
      }
    }
  }

  void update () {
    a += TWO_PI / (360 * 40);
  }

  void render () {
    for (PVector s : stars) {
      x = s.x - (cos(a) * r - width / 2);
      y = s.y - (sin(a) * r - height / 2);
      if (x>0 && x < width && y > 0 && y < height) {
        pushMatrix();
        translate(x, y);
        rotate(TWO_PI/8);
        square(0, 0, 2);
        popMatrix();
      }
    }
  }
}
