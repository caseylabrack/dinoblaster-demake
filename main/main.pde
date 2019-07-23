Earth earth;
Player player;
RoidManager roids;
SplosionManager splodesManager;
EventManager eventManager;

void setup () {
  //fullScreen();
  size(640, 480, P2D);
  colorMode(HSB, 360, 100, 100);
  eventManager = new EventManager();
  earth = new Earth(width/2, height/2);
  player = new Player(width/2, 105);
  earth.addChild(player);
  roids = new RoidManager(3000, 100);
  splodesManager = new SplosionManager();
}

void keyPressed() {
  player.setMove(keyCode, true);
}

void keyReleased() {
  player.setMove(keyCode, false);
}

void draw () {

  background(0);
  roids.update();
  earth.update();
  earth.render();
  player.update();
  player.render();
  splodesManager.update();
  //if(frameCount % 200 == 0) { println(frameRate); }
  //saveFrame("spoofs and goofs/frames/dino-####.png");
  //if(frameCount==200) exit();
}
