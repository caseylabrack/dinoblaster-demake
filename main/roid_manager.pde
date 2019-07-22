class RoidManager {
  float rate = 3000;
  Roid[] roids;
  float lastFire;
  int index = 0;
  
  RoidManager (float _rate, int poolsize) {
    rate = _rate;
    roids = new Roid[poolsize];
    for(int i = 0; i < poolsize; i++) {
      roids[i] = new Roid();
    }
    fire();
  }
  
  void update () {
    if(millis() - lastFire > rate) {
      fire();
    }
    
    for(Roid r : roids) r.update();
    for(Roid r : roids) r.render();
  }
  
  void fire () {
    roids[index].fire();
    lastFire = millis();
    index++;
  }
}
