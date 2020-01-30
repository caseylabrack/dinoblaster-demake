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
