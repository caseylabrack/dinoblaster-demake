class Camera extends Entity implements updateable {
  Camera () {

    setPosition(earth.getPosition());
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
  int[] hues = new int[]{0,60,120,180,240,300};
  ColorDecider () {
  }
  
  void update () {
    currentHue = hues[utils.cycleRangeWithDelay(hues.length, 10, frameCount)];
  }
  
  color getColor () {
    return color(currentHue, 100, 100);
  }
}
