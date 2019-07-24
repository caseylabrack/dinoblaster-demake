Earth earth;
Player player;
RoidManager roids;
SplosionManager splodesManager;
EventManager eventManager;
StarManager starManager;
Camera camera;

void setup () {
  //fullScreen();
  size(640, 480, P2D);
  colorMode(HSB, 360, 100, 100);
  eventManager = new EventManager();
  earth = new Earth(width/2, height/2);
  player = new Player();
  roids = new RoidManager(30, 100);
  splodesManager = new SplosionManager();
  starManager = new StarManager();
  camera = new Camera();
}

void keyPressed() {
  player.setMove(keyCode, true);
}

void keyReleased() {
  player.setMove(keyCode, false);
}

void draw () {

  background(0);
  camera.update();
  roids.update();
  earth.update();
  earth.render();
  player.update();
  player.render();
  splodesManager.update();
  //println(camera.x);
  //if(frameCount % 200 == 0) { println(frameRate); }
  //saveFrame("spoofs and goofs/frames/dino-####.png");
  //if(frameCount==200) exit();
}
