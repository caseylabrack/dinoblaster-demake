abstract class GameMode {

  Earth earth;
  Player player;
  //SplosionManager splodesManager;
  EventManager eventManager;
  StarManager starManager;
  RoidManager roids;
  SoundManager soundManager;

  Camera camera;
  int score = 0;
  ArrayList<updateable> updaters = new ArrayList<updateable>();
  ArrayList<renderable> renderers = new ArrayList<renderable>();

  GameMode () {
    print("super class");
    updaters = new ArrayList<updateable>();
    renderers = new ArrayList<renderable>();
    eventManager = new EventManager();
    earth = new Earth(this, width/2, height/2);
    camera = new Camera();
    camera.setPosition(earth.getPosition());
    roids = new RoidManager(70, 400, 100, earth, eventManager, camera);
    starManager = new StarManager();
    earth.addChild(camera);

    //soundManager = new SoundManager(_main);



  }

  void input(int _key, boolean pressed) {
    player.setMove(_key, pressed);
  }
  abstract void update();
}

class OviraptorMode extends GameMode {

  //Camera camera;
  //UIStuff ui;
  //ColorDecider currentColor;
  //Trex trex;
  
  OviraptorMode (PApplet _main) {
    super();
    print("start oviraptor mode");
    player = new Player(this, 2);
    //earthOrbit = new Orbiter(100, 100, 0, 0, TWO_PI/360);
    //ui = new UIStuff();
    //currentColor = new ColorDecider();
    //trex = new Trex();
    //earth.addChild(trex);
    //updaters.add(ui);
    updaters.add(earth);
    updaters.add(roids);
    updaters.add(camera);
    updaters.add(player);
    //updaters.add(splodesManager);
    //updaters.add(currentColor);
    //updaters.add(trex);
    updaters.add(starManager);
    //renderers.add(ui);
    renderers.add(player);
    renderers.add(earth);
    renderers.add(starManager);
    //renderers.add(splodesManager);
    //renderers.add(trex); 
  }
    
  void update () {
    //print("oviraptor tick");
    for (updateable u : updaters) u.update();
    for (renderable r : renderers) r.render();
  }
}

class StoryMode extends GameMode {

  //Camera camera;
  //UIStuff ui;
  //ColorDecider currentColor;
  //Trex trex;
  
  StoryMode (PApplet _main) {
    super();
    print("start story mode");
    player = new Player(this, 1);
    //earthOrbit = new Orbiter(100, 100, 0, 0, TWO_PI/360);
    //ui = new UIStuff();
    //currentColor = new ColorDecider();
    //trex = new Trex();
    //earth.addChild(trex);
    //updaters.add(ui);
    updaters.add(earth);
    updaters.add(roids);
    updaters.add(camera);
    updaters.add(player);
    //updaters.add(splodesManager);
    //updaters.add(currentColor);
    //updaters.add(trex);
    updaters.add(starManager);
    
    //renderers.add(ui);
    renderers.add(earth);
    renderers.add(player);
    renderers.add(starManager);
    //renderers.add(splodesManager);
    //renderers.add(trex); 
  }
    
  void update () {
    
    for (updateable u : updaters) u.update();
    for (renderable r : renderers) r.render();
  }
}
