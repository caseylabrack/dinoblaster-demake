abstract class GameMode {

  Earth earth;
  Player player;
  SplosionManager splodesManager;
  EventManager eventManager;
  StarManager starManager;
  SoundManager soundManager;
  int score = 0;

  abstract void init(PApplet _main);
  abstract void update();
}

class OviraptorMode extends GameMode {


  //Camera camera;
  //UIStuff ui;
  //ColorDecider currentColor;
  //Trex trex;
  ArrayList<updateable> updaters;
  ArrayList<renderable> renderers;
  
  void init (PApplet _main) {
    print("start oviraptor mode");
    updaters = new ArrayList<updateable>();
    renderers = new ArrayList<renderable>();
    eventManager = new EventManager();
    //soundManager = new SoundManager(_main);
    earth = new Earth(width/2, height/2);
    player = new Player(this, 2);
    //RoidManager roids = new RoidManager(70, 400, 100);
    //splodesManager = new SplosionManager();
    //StarManager starManager = new StarManager();
    //camera = new Camera();
    //earthOrbit = new Orbiter(100, 100, 0, 0, TWO_PI/360);
    //ui = new UIStuff();
    //currentColor = new ColorDecider();
    //trex = new Trex();
    //earth.addChild(trex);
    //updaters.add(ui);
    updaters.add(earth);
    //updaters.add(roids);
    //updaters.add(camera);
    updaters.add(player);
    //updaters.add(splodesManager);
    //updaters.add(currentColor);
    //updaters.add(trex);
    //updaters.add(starManager);
    //renderers.add(ui);
    renderers.add(player);
    renderers.add(earth);
    //renderers.add(starManager);
    //renderers.add(splodesManager);
    //renderers.add(trex); 
  }
  
  void update () {
    print("oviraptor tick");
    for (updateable u : updaters) u.update();
    for (renderable r : renderers) r.render();
  }
}
