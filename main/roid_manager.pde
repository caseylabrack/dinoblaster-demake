class RoidManager implements updateable, renderable {

  EventManager events;
  Time time;  
  Earth earth;

  float spawnInterval;
  float minSpawnInterval;//70;
  float maxSpawnInterval;//400;
  final static float DEFAULT_SPAWN_RATE = 300;
  final static float DEFAULT_SPAWN_DEVIATION = 100;
  final static float spawnDist = 720;
  Roid[] roids = new Roid[100];
  float lastFire;
  int roidindex = 0;

  Explosion[] splodes = new Explosion[25];
  int splodeindex = 0;

  public boolean enabled;

  class Explosion extends Entity {
    PImage model;
    float start;
    final static float duration = 500;
    boolean enabled = false;
  }

  class Roid extends Entity {
    int modelIndex;
    final static float speed = 2.5;
    boolean enabled = false;
    PImage trail;
    float angle;
    PVector trailPosition;
    final static float dr = .1;
  }

  RoidManager (Earth earf, EventManager _events, Time t) {
    earth = earf;
    events = _events;
    time = t;

    for (int i = 0; i < roids.length; i++) {
      roids[i] = new Roid();
    }

    for (int j = 0; j < splodes.length; j++) {
      splodes[j] = new Explosion();
      earth.addChild(splodes[j]);
    }

    enabled = settings.getBoolean("roidsEnabled", true);
    minSpawnInterval = settings.getFloat("roidImpactRateInMilliseconds", DEFAULT_SPAWN_RATE) - settings.getFloat("roidImpactRateVariation", DEFAULT_SPAWN_DEVIATION)/2;
    maxSpawnInterval = settings.getFloat("roidImpactRateInMilliseconds", DEFAULT_SPAWN_RATE) + settings.getFloat("roidImpactRateVariation", DEFAULT_SPAWN_DEVIATION)/2;

    //roids[roidindex % roids.length].fire();
    //roidindex++;
  }

  void update () {

    if (!enabled) return;

    if (time.getClock() - lastFire > spawnInterval) {
      lastFire = time.getClock();
      spawnInterval = random(minSpawnInterval, maxSpawnInterval);

      Roid r = roids[roidindex++ % roids.length]; // increment roid index and wrap to length of pool
      r.enabled = true;
      r.angle = random(0, 359);
      r.x = earth.x + cos(radians(r.angle)) * spawnDist;
      r.y = earth.y + sin(radians(r.angle)) * spawnDist;
      r.dx = cos(radians(r.angle+180)) * Roid.speed;
      r.dy = sin(radians(r.angle+180)) * Roid.speed;
    };

    for (Roid r : roids) {
      if (!r.enabled) continue;
      r.x += r.dx * time.getTimeScale();
      r.y += r.dy * time.getTimeScale();
      r.r += Roid.dr * time.getTimeScale();

      if (PVector.dist(r.globalPos(), earth.globalPos()) < Earth.EARTH_RADIUS ) {
        r.enabled = false;
        Explosion splode = splodes[splodeindex++ % splodes.length]; // increment splode index and wrap to length of pool
        events.dispatchRoidImpact(r.globalPos());

        splode.enabled = true;
        splode.start = time.getClock();
        float angle = utils.angleOfRadians(earth.globalPos(), r.globalPos());
        float offset = 20;
        PVector adjustedPosition = new PVector(earth.x + cos(angle) * (Earth.EARTH_RADIUS + offset), earth.y + sin(angle) * (Earth.EARTH_RADIUS + offset));
        splode.setPosition(earth.globalToLocalPos(adjustedPosition));
        splode.r = utils.angleOf(earth.localPos(), splode.localPos()) + 90;
        
        println("sound pls");
        int w = (int)random(0,4);
        assets.roidStuff.sounds[w].rewind();
        assets.roidStuff.sounds[w].play();
        //assets.roidStuff.roid1.rewind();
        //assets.roidStuff.roid1.play();
      }
    }

    for (Explosion s : splodes) {
      if (!s.enabled) continue;

      float elapsed = time.getClock() - s.start;

      if (elapsed < Explosion.duration) {
        s.model = assets.roidStuff.explosionFrames[round((elapsed / Explosion.duration) * (assets.roidStuff.explosionFrames.length - 1))];
      } else {
        s.enabled = false;
      }
    }
  }

  void render () {

    if (!enabled) return;

    for (Roid r : roids) {
      if (!r.enabled) continue;
      pushMatrix();
      imageMode(CENTER);
      translate(r.x, r.y);

      pushMatrix();
      rotate(radians(r.angle+90));
      image(assets.roidStuff.trail, 0, -25);
      popMatrix();

      rotate(r.r);
      image(assets.roidStuff.roidFrames[r.modelIndex], 0, 0);
      //image(model, 0, 0, model.width/2, model.height/2);
      popMatrix();
    }
    for (Explosion s : splodes) {
      if (!s.enabled) continue;
      s.simpleRenderImage(s.model);
    }
  }
}
