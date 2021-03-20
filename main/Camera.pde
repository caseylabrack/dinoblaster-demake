class Camera extends Entity implements updateable {

  Camera (float _x, float _y) {

    x = _x + width/2;
    y = _y + height/2;
  }

  void update () {

    //cute screenshake idea
    //float magnitude = 25;
    //float start = 0;
    //float duration = 120;
    //translate(
    //  camera.x + (frameCount - start < duration ? cos(frameCount % 360) * magnitude * pow((duration - frameCount - start) / duration, 5) : 0), 
    //  camera.y + (frameCount - start < duration ? sin(frameCount % 360) * magnitude * pow((duration - frameCount - start) / duration, 5) : 0)
    //  );

    x += dx;
    y += dy;
    r += dr;
  }
}


class ColorDecider implements updateable {
  private int currentHue = 0;
  private color[] hues = new color[]{#ff3800, #ffff00, #00ff00, #00ffff, #ff57ff};   // photoshop LAB
  //private color[] hues = new color[]{#FEA7DD,#ABC3FB,#4BD7E4,#5DDDA6,#ADD568,#F7C155}; // chroma.js
  //private color[] hues = new color[]{#926E9B,#5384A8,#009293,#3C9867,#7C953D,#B58834}; // chroma.js darker 

  void update () {
    currentHue = hues[utils.cycleRangeWithDelay(hues.length, 10, frameCount)];
  }

  color getColor () {
    return currentHue;
  }
}

class Time implements updateable, playerDiedEvent, gameOverEvent, nebulaEvents {

  private float clock;
  private float lastmillis;
  private float timeScale = 1;
  private long lastNanos;
  private float delta;
  private int tick;

  private boolean dying = false;
  private float dyingStartTime;
  final float dyingDuration = 3e3;

  private boolean hyperspace = false;
  final float HYPERSPACE_TIME = 1.75;

  EventManager eventManager;

  Time (EventManager ev) {
    eventManager = ev;

    eventManager.playerDiedSubscribers.add(this);
    eventManager.gameOverSubscribers.add(this);
    eventManager.nebulaStartSubscribers.add(this);

    lastmillis = millis();
    //clock = millis();
    clock = 0;
  }

  void update () {

    tick++;

    clock += (millis() - lastmillis) * timeScale;
    lastmillis = millis();

    delta = min((frameRateLastNanos - lastNanos)/1e6/16.666, 2);
    lastNanos = frameRateLastNanos;

    eventManager.playerDiedSubscribers.add(this);

    if (dying) {
      float progress = (millis() - dyingStartTime) / dyingDuration;
      if (progress < 1) {
        float targetTimeScale = hyperspace ? HYPERSPACE_TIME: 1;
        timeScale = utils.easeInOutExpo(progress, .1, targetTimeScale - .1, targetTimeScale);
      } else {
        dying = false;
      }
    }
  }

  void nebulaStartHandle() {

    if (!hyperspace) {
      timeScale = HYPERSPACE_TIME;
      hyperspace = true;
    }
  }

  void nebulaStopHandle() {
   
      hyperspace = false;
      if(!dying) { 
        timeScale = 1;
      }
  }

  void gameOverHandle() {
    dying = true;
    dyingStartTime = millis();
  }

  void playerDiedHandle(PVector position) {
    dying = true;
    dyingStartTime = millis();
  }

  public float getTimeScale () {
    //return timeScale; 
    return timeScale * delta;
  }
  public float getClock() {
    return clock;
  }
  public float getTick() {
    return tick;
  }
}
