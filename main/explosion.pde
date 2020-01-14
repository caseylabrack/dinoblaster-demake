//class Explosion extends Entity {
//  PImage model;
//  float start;
//  float duration = 300;
//  boolean visible = false;
//  PImage[] frames;
//  Camera camera;
//  Earth earth;

//  Explosion (Camera _cam, PImage[] _frames, Earth _earth) {

//    frames = _frames;
//    camera = _cam;
//    earth = _earth;
//  }

//  void fire(float xpos, float ypos) {
//    visible = true;
//    x = xpos;
//    y = ypos;
//    start = millis();
//    //r = degrees(atan2(y - mode.earth.y, x - mode.earth.x)) + 90;
//  }

//  void update () {

//    if (!visible) return;

//    if (millis() - start > duration) {
//      visible = false;
//    }
//    int frameNum = floor(map((millis() - start) / duration, 0, 1, 0, frames.length)); // animation progress is proportional to duration progress
//    model = frames[frameNum > 2 ? 2 : frameNum]; // mapping above is not clamped to frames.length, can create array out of index error 

//    x += dx;
//    y += dy;
//    r += dr;

//    dx = 0;
//    dy = 0;
//    dr = 0;
//  }

//  void render () {
//    if (!visible) return;
//    pushMatrix();
//    translate(width/2 + x - camera.x, height/2 + y - camera.y);
//    rotate(radians(r));
//    imageMode(CENTER);
//    image(model, 0, 0, model.width*.5, model.height*.5);
//    popMatrix();
//  }
//}
