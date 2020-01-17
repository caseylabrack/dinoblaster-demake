abstract class GameMode {

  Earth earth;
  Player player;
  EventManager eventManager;
  StarManager starManager;
  RoidManager roids;
  SoundManager soundManager;
  ColorDecider currentColor;

  Camera camera;
  int score = 0;
  ArrayList<updateable> updaters = new ArrayList<updateable>();
  ArrayList<renderable> renderers = new ArrayList<renderable>();

  GameMode (PApplet main) {
    updaters = new ArrayList<updateable>();
    renderers = new ArrayList<renderable>();
    eventManager = new EventManager();
    earth = new Earth(this, width/2, height/2);
    camera = new Camera();
    camera.setPosition(earth.getPosition());
    roids = new RoidManager(70, 400, 100, earth, eventManager, camera);
    starManager = new StarManager();
    currentColor = new ColorDecider();

    soundManager = new SoundManager(main, eventManager);

  }

  void input(int _key, boolean pressed) {
    player.setMove(_key, pressed);
  }
  abstract void update();
}

class OviraptorMode extends GameMode {

  Trex trex;
  
  OviraptorMode (PApplet _main) {
    super(_main);
    player = new Player(this, 2);
    trex = new Trex(earth, player, camera);
    earth.addChild(trex);
    updaters.add(earth);
    updaters.add(roids);
    updaters.add(camera);
    updaters.add(player);
    updaters.add(currentColor);
    updaters.add(trex);
    updaters.add(starManager);
    renderers.add(player);
    renderers.add(earth);
    renderers.add(starManager);
    renderers.add(trex); 
  }
    
  void update () {
    for (updateable u : updaters) u.update();
    for (renderable r : renderers) r.render();
  }
}

class StoryMode extends GameMode {

  UIStory ui;
  
  StoryMode (PApplet _main) {
    super(_main);
    player = new Player(this, 1);
    ui = new UIStory(eventManager, currentColor);
    updaters.add(ui);
    updaters.add(earth);
    updaters.add(roids);
    updaters.add(camera);
    updaters.add(player);
    updaters.add(currentColor);
    updaters.add(starManager);
    
    renderers.add(ui);
    renderers.add(earth);
    renderers.add(player);
    renderers.add(starManager);
  }
    
  void update () {
    
    for (updateable u : updaters) u.update();
    for (renderable r : renderers) r.render();
  }
}
