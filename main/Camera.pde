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
  int currentHue = 0;
  color[] hues = new color[]{#ff3800, #ffff00, #00ff00, #00ffff, #ff57ff};

  ColorDecider () {
  }

  void update () {
    currentHue = hues[utils.cycleRangeWithDelay(hues.length, 10, frameCount)];
  }

  color getColor () {
    return currentHue;
  }
}

class Time implements updateable, playerDiedEvent, gameOverEvent {

  private float clock;
  private float lastmillis;
  private float timeScale = 1;
  private long lastNanos;
  private float delta;

  private boolean dying = false;
  private float dyingStartTime;
  final float dyingDuration = 3e3;

  EventManager eventManager;

  Time (EventManager ev) {
    eventManager = ev;

    eventManager.playerDiedSubscribers.add(this);
    eventManager.gameOverSubscribers.add(this);
    
    lastmillis = millis();
    clock = millis();
  }

  void update () {
    
    clock += (millis() - lastmillis) * timeScale;
    lastmillis = millis();
    
    delta = (frameRateLastNanos - lastNanos)/1e6/16.666;
    lastNanos = frameRateLastNanos;

    eventManager.playerDiedSubscribers.add(this);

    if (dying) {
      float progress = (millis() - dyingStartTime) / dyingDuration;
      if (progress < 1) {
        timeScale = utils.easeInOutExpo(progress, .1, .9, 1);
      } else {
        dying = false;
      }
    }
  }

  void gameOverHandle(){
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
}
