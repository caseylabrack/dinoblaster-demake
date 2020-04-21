abstract class GameMode {

  Earth earth;
  //Player player;
  EventManager eventManager;
  StarManager starManager;
  RoidManager roids;
  SoundManager soundManager;
  ColorDecider currentColor;
  int tick = 0;
  //Keys keys;

  Camera camera;
  int score = 0;
  ArrayList<updateable> updaters;
  ArrayList<renderableScreen> screeenRenderers;
  ArrayList<renderable> renderers;
  ArrayList<deletable> deletables;

  GameMode (PApplet main) {
    updaters = new ArrayList<updateable>();
    renderers = new ArrayList<renderable>();
    screeenRenderers = new ArrayList<renderableScreen>();
    eventManager = new EventManager();
    earth = new Earth(this, 0, 0);
    camera = new Camera(0, 0);
    roids = new RoidManager(70, 400, 100, earth, eventManager);
    currentColor = new ColorDecider();
    starManager = new StarManager(currentColor);

    soundManager = new SoundManager(main, eventManager);
  }

  abstract void update();
}

class OviraptorMode extends GameMode {

  Trex trex;

  OviraptorMode (PApplet _main) {
    super(_main);
    //player = new Player(eventManager, earth, 2);
    //trex = new Trex(earth, player, camera);
    earth.addChild(trex);
    updaters.add(earth);
    updaters.add(roids);
    updaters.add(camera);
    //updaters.add(player);
    updaters.add(currentColor);
    updaters.add(trex);
    updaters.add(starManager);

    //renderers.add(player);
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
  UFOManager ufoManager;
  PlayerManager playerManager;

  StoryMode (PApplet _main) {
    super(_main);
    playerManager = new PlayerManager(eventManager, earth);
    //player = new Player(eventManager, earth, 1);
    ui = new UIStory(eventManager, currentColor);
    ufoManager = new UFOManager (currentColor, earth, playerManager, eventManager);

    updaters.add(ui);
    updaters.add(earth);
    updaters.add(roids);
    updaters.add(camera);
    updaters.add(currentColor);
    updaters.add(starManager);
    updaters.add(ufoManager);
    updaters.add(playerManager);

    renderers.add(ufoManager);
    renderers.add(playerManager);
    renderers.add(earth);
    renderers.add(roids);
    renderers.add(starManager);

    screeenRenderers.add(ui);
  }

  void update () {

    tick++;

    if (tick==30) {
      ufoManager.spawnUFOAbducting();
    }
    
    pushMatrix(); // world-space
    translate(camera.x, camera.y);
    for (updateable u : updaters) u.update();
    for (renderable r : renderers) r.render();
    
    popMatrix(); // screen-space
    for (renderableScreen rs : screeenRenderers) rs.render(); // UI
    
  }
}
