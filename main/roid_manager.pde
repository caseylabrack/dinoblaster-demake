class RoidManager implements updateable {
  float wait;
  int min;
  int max;
  Roid[] roids;
  float lastFire;
  int index = 0;

  RoidManager (int _min, int _max, int poolsize) {
    min = _min;
    max = _max;
    roids = new Roid[poolsize];
    for (int i = 0; i < poolsize; i++) {
      roids[i] = new Roid();
    }
  }

  void update () {
    if (millis() - lastFire > wait) {
      lastFire = millis();
      wait = random(min, max);
      roids[index % roids.length].fire();
      index++;
    };

    for (Roid r : roids) r.update();
    for (Roid r : roids) r.render();
  }
}
