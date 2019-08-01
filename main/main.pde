Earth earth;
Player player;
SplosionManager splodesManager;
EventManager eventManager;
//StarManager starManager;
Camera camera;
//Orbiter earthOrbit;
UIStuff ui;
ArrayList<updateable> updaters;
ArrayList<renderable> renderers;

void setup () {
  //fullScreen(P2D);
  size(640, 480, P2D);
  colorMode(HSB, 360, 100, 100);
  noCursor();
  init();
}

void init () {
  updaters = new ArrayList<updateable>();
  renderers = new ArrayList<renderable>();
  eventManager = new EventManager();
  earth = new Earth(width/2, height/2);
  player = new Player();
  RoidManager roids = new RoidManager(70, 400, 100);
  splodesManager = new SplosionManager();
  StarManager starManager = new StarManager();
  camera = new Camera();
  //earthOrbit = new Orbiter(100, 100, 0, 0, TWO_PI/360);
  ui = new UIStuff();
  updaters.add(ui);
  updaters.add(earth);
  updaters.add(roids);
  updaters.add(camera);
  updaters.add(player);
  updaters.add(splodesManager);
  //updaters.add(earthOrbit);
  updaters.add(starManager);
  renderers.add(ui);
  renderers.add(player);
  renderers.add(earth);
  renderers.add(starManager);
  renderers.add(splodesManager);
  //earth.setPosition(earthOrbit.getPosition());
  //earthOrbit.addChild(earth);
}

void keyPressed() {
  if (key=='1') {
    init();
  } else {
    player.setMove(keyCode, true);
  }
}

void keyReleased() {
  player.setMove(keyCode, false);
}

void draw () {

  background(0);
  for (updateable u : updaters) u.update();
  for (renderable r : renderers) r.render();

  //if(frameCount % 200 == 0) { println(frameRate); }
  //saveFrame("spoofs-and-goofs/frames/dino-####.png");
  //if(frameCount==800) exit();
}
