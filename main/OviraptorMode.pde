abstract class GameMode {

  Earth earth;
  Player player;
  //SplosionManager splodesManager;
  EventManager eventManager;
  StarManager starManager;
  //SoundManager soundManager;
  Camera camera;
  int score = 0;
  ArrayList<updateable> updaters = new ArrayList<updateable>();
  ArrayList<renderable> renderers = new ArrayList<renderable>();

  //abstract void init(PApplet _main);
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
    print("start oviraptor mode");
    eventManager = new EventManager();
    //soundManager = new SoundManager(_main);
    earth = new Earth(this, width/2, height/2);
    player = new Player(this, 2);
    //RoidManager roids = new RoidManager(70, 400, 100);
    //splodesManager = new SplosionManager();
    //StarManager starManager = new StarManager();
    camera = new Camera();
    camera.setPosition(earth.getPosition());
    earth.addChild(camera);
    //earthOrbit = new Orbiter(100, 100, 0, 0, TWO_PI/360);
    //ui = new UIStuff();
    //currentColor = new ColorDecider();
    //trex = new Trex();
    //earth.addChild(trex);
    //updaters.add(ui);
    updaters.add(earth);
    //updaters.add(roids);
    updaters.add(camera);
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
  
  //void input(String _key) {
  //      player.setMove(keyCode, true);
  //}
  
  void update () {
    print("oviraptor tick");
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
    print("start story mode");
    updaters = new ArrayList<updateable>();
    renderers = new ArrayList<renderable>();
    eventManager = new EventManager();
    //soundManager = new SoundManager(_main);
    earth = new Earth(this, width/2, height/2);
    player = new Player(this, 1);
    //RoidManager roids = new RoidManager(70, 400, 100);
    //splodesManager = new SplosionManager();
    //StarManager starManager = new StarManager();
    camera = new Camera();
    camera.setPosition(earth.getPosition());
    earth.addChild(camera);
    //earthOrbit = new Orbiter(100, 100, 0, 0, TWO_PI/360);
    //ui = new UIStuff();
    //currentColor = new ColorDecider();
    //trex = new Trex();
    //earth.addChild(trex);
    //updaters.add(ui);
    updaters.add(earth);
    //updaters.add(roids);
    updaters.add(camera);
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
  
  void keyPressed() {
  //if (key=='1') {
  //  init();
  //} else {
    //player.setMove(keyCode, true);
    //print("pressed");
  //}
  
  //if(key=='2') testactive = !testactive;
}

  //void input(String _key) {
  //      player.setMove(keyCode, true);
  //}
  
  void update () {
    //print("story tick");
    for (updateable u : updaters) u.update();
    for (renderable r : renderers) r.render();
  }
}
