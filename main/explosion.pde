class Explosion extends Entity {
  PImage model;
  float radius;
  float start = millis();
  float duration = 300;
  boolean visible = true;
  PImage sheet;
  PImage[] frames;

  Explosion (float xpos, float ypos) {
    x = xpos;
    y = ypos;

    sheet = loadImage("explosion-sheet.png");
    frames = utils.sheetToSprites(sheet, 3, 1);

    radius = model.width/2;
    splodesManager.splodes.add(this);
    r = degrees(atan2(y - earth.y, x - earth.x)) + 90;
  }

  void update () {

    if (!visible) return;

    if (millis() - start > duration) {
      visible = false;
    }
    int frameNum = floor(map((millis() - start) / duration, 0, 1, 0, frames.length)); // animation progress is proportional to duration progress
    model = frames[frameNum > 2 ? 2 : frameNum]; // mapping above is not clamped to frames.length, can create array out of index error 

    x += dx;
    y += dy;

    dx = 0;
    dy = 0;
  }

  void render () {
    if (!visible) return;
    pushMatrix();
    translate(width/2 + x - camera.x, height/2 + y - camera.y);
    rotate(radians(r));
    imageMode(CENTER);
    image(model, 0, 0, model.width*.5, model.height*.5);
    popMatrix();
  }
}
