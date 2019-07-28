Earth earth;
Player player;
RoidManager roids;
SplosionManager splodesManager;
EventManager eventManager;
StarManager starManager;
Camera camera;
Orbiter earthOrbit;

void setup () {
  //fullScreen();
  size(640, 480, P2D);
  colorMode(HSB, 360, 100, 100);
  eventManager = new EventManager();
  earth = new Earth(width/2, height/2);
  player = new Player();
  roids = new RoidManager(100, 500, 100);
  splodesManager = new SplosionManager();
  starManager = new StarManager();
  camera = new Camera();
  earthOrbit = new Orbiter(100, 100, 0, 0, TWO_PI/360);
  //earth.setPosition(earthOrbit.getPosition());
  //earthOrbit.addChild(earth);
}

void keyPressed() {
  player.setMove(keyCode, true);
}

void keyReleased() {
  player.setMove(keyCode, false);
}

void draw () {

  background(0);
  earthOrbit.update();
  camera.update();
  roids.update();
  earth.update();
  earth.render();
  player.update();
  player.render();
  splodesManager.update();
  
  //pushMatrix();
  //translate(width/2 + 0 - camera.x, height/2 + 0 - camera.y);
  //circle(width/2, height/2, 10);
  //popMatrix();
  
  //if(frameCount % 200 == 0) { println(frameRate); }
  //saveFrame("spoofs-and-goofs/frames/dino-####.png");
  //if(frameCount==200) exit();
}
