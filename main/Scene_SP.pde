abstract class Scene {
  public int sceneID;
  final static int SPLASH = 0;
  final static int MENU = 1;
  final static int PTUTORIAL = 2;
  final static int SINGLEPLAYER = 3;
  final static int MULTIPLAYER = 4;
  final static int OVIRAPTOR = 5;

  public int status;
  final static int RUNNING = 1;
  final static int DONE = 2;

  abstract void update();
  abstract void render();
  abstract int nextScene();
}

class SinglePlayer extends Scene {

  Earth earth;
  EventManager eventManager;
  StarManager starManager;
  RoidManager roids;
  VolcanoManager volcanoManager;
  SoundManager soundManager;
  ColorDecider currentColor;
  UIStory ui;
  UFOManager ufoManager;
  PlayerManager playerManager;
  Time time;
  Camera camera;

  ArrayList<updateable> updaters = new ArrayList<updateable>();
  ArrayList<renderableScreen> screeenRenderers = new ArrayList<renderableScreen>();
  ArrayList<renderable> renderers =  new ArrayList<renderable>();

  SinglePlayer() {
    sceneID = SINGLEPLAYER;

    eventManager = new EventManager();
    time = new Time(eventManager);
    earth = new Earth(time);
    camera = new Camera(0, 0);
    roids = new RoidManager(earth, eventManager, time);
    currentColor = new ColorDecider();
    volcanoManager = new VolcanoManager(eventManager, time, currentColor, earth);
    starManager = new StarManager(currentColor, time);

    //soundManager = new SoundManager(main, eventManager);

    playerManager = new PlayerManager(eventManager, earth, time, volcanoManager);
    ui = new UIStory(eventManager, time, currentColor);
    ufoManager = new UFOManager (currentColor, earth, playerManager, eventManager);

    updaters.add(time);
    updaters.add(ui);
    updaters.add(earth);
    updaters.add(roids);
    updaters.add(camera);
    updaters.add(currentColor);
    updaters.add(starManager);
    updaters.add(ufoManager);
    updaters.add(playerManager);
    updaters.add(volcanoManager);

    renderers.add(ufoManager);
    renderers.add(volcanoManager);
    renderers.add(playerManager);
    renderers.add(earth);
    renderers.add(roids);
    renderers.add(starManager);

    screeenRenderers.add(ui);
  }

  void update () {

    //if (time.getTick()==20) ufoManager.spawnUFOAbducting();

    for (updateable u : updaters) u.update();
  }

  void render () {

    pushMatrix(); // world-space
    translate(camera.x, camera.y);
    for (renderable r : renderers) r.render();
    popMatrix(); // screen-space

    for (renderableScreen rs : screeenRenderers) rs.render(); // UI
  }

  int nextScene () {
    return SINGLEPLAYER;
  }
}

class testScene extends Scene {

  Earth earth;
  EventManager eventManager;
  ColorDecider currentColor;
  UIStory ui;
  RoidManager roids;
  //UFOManager ufoManager;
  PlayerManager playerManager;
  Time time;
  Camera camera;
  VolcanoManager volcanoManager;

  ArrayList<updateable> updaters = new ArrayList<updateable>();
  ArrayList<renderableScreen> screeenRenderers = new ArrayList<renderableScreen>();
  ArrayList<renderable> renderers =  new ArrayList<renderable>();

  testScene () {
    sceneID = SINGLEPLAYER;

    eventManager = new EventManager();
    time = new Time(eventManager);
    earth = new Earth(time);
    //earth.dr = 0;

    camera = new Camera(0, 0);
    roids = new RoidManager(earth, eventManager, time);
    currentColor = new ColorDecider();
    //starManager = new StarManager(currentColor, time);

    //soundManager = new SoundManager(main, eventManager);
    volcanoManager = new VolcanoManager(eventManager, time, currentColor, earth);
    playerManager = new PlayerManager(eventManager, earth, time, volcanoManager);
    playerManager.spawningDuration = 10;
    ui = new UIStory(eventManager, time, currentColor);
    ui.score = 90;
    //ufoManager = new UFOManager (currentColor, earth, playerManager, eventManager);

    updaters.add(time);
    //updaters.add(ui);
    updaters.add(earth);
    updaters.add(roids);
    updaters.add(camera);
    updaters.add(currentColor);
    //updaters.add(starManager);
    //updaters.add(ufoManager);
    updaters.add(playerManager);
    //updaters.add(volcanoManager);

    //renderers.add(ufoManager);
    renderers.add(playerManager);
    //renderers.add(volcanoManager);

    renderers.add(earth);
    renderers.add(roids);
    //renderers.add(starManager);

    //screeenRenderers.add(ui);
  }

  void update () {

    //if (time.getTick()==20) ufoManager.spawnUFOAbducting();

    for (updateable u : updaters) u.update();
  }

  void render () {
    pushMatrix(); // world-space
    translate(camera.x, camera.y);
    for (renderable r : renderers) r.render();

    popMatrix(); // screen-space
    for (renderableScreen rs : screeenRenderers) rs.render(); // UI
  }

  int nextScene () {
    return SINGLEPLAYER;
  }
}
