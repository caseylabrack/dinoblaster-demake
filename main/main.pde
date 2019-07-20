Earth earth = new Earth(400,400);

void setup () {
  //fullScreen();
  size(640,480);
}

void draw () {
  earth.update();
}
