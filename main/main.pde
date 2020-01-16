import processing.sound.*;

//Earth earth;
//Player player;
//SplosionManager splodesManager;
//EventManager eventManager;
//StarManager starManager;
//SoundManager soundManager;
//Camera camera;
//UIStuff ui;
//ColorDecider currentColor;
//Trex trex;
//ArrayList<updateable> updaters;
//ArrayList<renderable> renderers;
boolean testactive = true;
GameMode game;
long prev;

void setup () {
  //size(640, 480, P2D);
  //fullScreen(P2D);

  size(1024, 768, P2D);
  colorMode(HSB, 360, 100, 100);
  noCursor();
  //init();
  game = new OviraptorMode(this);
  //game = new StoryMode(this);
  //frameRate(10);
  //game.init(this);
  prev = frameRateLastNanos;
}

//void init () {
//  testactive = true;
//  updaters = new ArrayList<updateable>();
//  renderers = new ArrayList<renderable>();
//  eventManager = new EventManager();
//  soundManager = new SoundManager(this);
//  earth = new Earth(width/2, height/2);
//  player = new Player(2);
//  RoidManager roids = new RoidManager(70, 400, 100);
//  splodesManager = new SplosionManager();
//  StarManager starManager = new StarManager();
//  camera = new Camera();
//  //earthOrbit = new Orbiter(100, 100, 0, 0, TWO_PI/360);
//  ui = new UIStuff();
//  currentColor = new ColorDecider();
//  trex = new Trex();
//  earth.addChild(trex);
//  updaters.add(ui);
//  updaters.add(earth);
//  updaters.add(roids);
//  updaters.add(camera);
//  updaters.add(player);
//  updaters.add(splodesManager);
//  updaters.add(currentColor);
//  updaters.add(trex);
//  updaters.add(starManager);
//  renderers.add(ui);
//  renderers.add(player);
//  renderers.add(earth);
//  renderers.add(starManager);
//  renderers.add(splodesManager);
//  renderers.add(trex);  
//}

void keyPressed() {
  
  switch (key) {   
    case '1':
     game = new StoryMode(this);
    break;
    
    case '2':
    game = new OviraptorMode(this);
    break;
    
    case ' ':
    testactive = !testactive;
    break;
    
    default:
      game.input(keyCode, true);
    break;
  }
}

void keyReleased() {
  game.input(keyCode, false);
}

void draw () {

  if(testactive) {
    background(0);
    game.update();
  }
  
  //if(frameCount % 60==0) println((frameRateLastNanos - prev)/1e6/16.666);
  prev = frameRateLastNanos;

  //if(frameCount % 200 == 0) { println(frameRate); }
  //saveFrame("spoofs-and-goofs/frames2/dino-####.png");
  //if(frameCount==300) exit();
}
