//class SplosionManager implements updateable, renderable {
//  Explosion[] splodes = new Explosion[25];
//  PImage sheet;
//  PImage[] frames;
//  int index = 0;

//  SplosionManager () {

//    sheet = loadImage("explosion-sheet.png");
//    frames = utils.sheetToSprites(sheet, 3, 1);

//    for (int i = 0; i < splodes.length; i++) {
//      splodes[i] = new Explosion(frames);
//      earth.addChild(splodes[i]);
//    }
//  }

//  void newSplode (float x, float y) {
//    splodes[index % splodes.length].fire(x, y);
//  }

//  void update () {
//    for (Explosion s : splodes) s.update();
//  }

//  void render () {
//    for (Explosion s : splodes) s.render();
//  }
//}
