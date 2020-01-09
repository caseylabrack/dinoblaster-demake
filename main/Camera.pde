class Camera extends Entity implements updateable {
  Camera () {

    //setPosition(earth.getPosition());
    //earth.addChild(this);
  }

  void update () {
    x += dx;
    y += dy;
    r += dr;

    dx = 0;
    dy = 0;
  }
}

class ColorDecider implements updateable {
  int currentHue = 0;
  color[] hues = new color[]{#ff3800,#ffff00,#00ff00,#00ffff,#ff57ff};
  ColorDecider () { }

  void update () {
    currentHue = hues[utils.cycleRangeWithDelay(hues.length, 10, frameCount)];
  }

  color getColor () {
    return currentHue;
  }
}
