abstract class Scene {
  public int sceneID;
  final static int SPLASH = 0;
  final static int MENU = 1;
  final static int PTUTORIAL = 2;
  final static int TRIASSIC = 3;
  final static int JURASSIC = 4;
  final static int CRETACEOUS = 5;
  final static int MULTIPLAYER = 6;
  final static int OVIRAPTOR = 7;

  public int status;
  final static int RUNNING = 1;
  final static int DONE = 2;

  abstract void update();
  abstract void render();
  //abstract int nextScene();
}

class SinglePlayer extends Scene {

  Earth earth;
  EventManager eventManager;
  StarManager starManager;
  RoidManager roids;
  VolcanoManager volcanoManager;
  ColorDecider currentColor;
  UIStory ui;
  UFOManager ufoManager;
  PlayerManager playerManager;
  Time time;
  Camera camera;
  TrexManager trexManager;
  GameScreenMessages gameText;

  ArrayList<updateable> updaters = new ArrayList<updateable>();
  ArrayList<renderableScreen> screenRenderers = new ArrayList<renderableScreen>();
  ArrayList<renderable> renderers =  new ArrayList<renderable>();

  SinglePlayer(int lvl) {
    sceneID = TRIASSIC + lvl - 1;

    eventManager = new EventManager();
    time = new Time(eventManager);
    earth = new Earth(time, eventManager, lvl);
    camera = new Camera(0, 0);
    roids = new RoidManager(earth, eventManager, time);
    currentColor = new ColorDecider();
    volcanoManager = new VolcanoManager(eventManager, time, currentColor, earth, lvl);
    starManager = new StarManager(currentColor, time, eventManager, lvl);
    gameText = new GameScreenMessages(eventManager, currentColor);

    //soundManager = new SoundManager(main, eventManager);

    playerManager = new PlayerManager(eventManager, earth, time, volcanoManager, starManager, camera);
    trexManager = new TrexManager(eventManager, time, earth, playerManager, currentColor, lvl);

    ui = new UIStory(eventManager, time, currentColor, lvl);
    ufoManager = new UFOManager (currentColor, earth, playerManager, eventManager, time);

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
    updaters.add(trexManager);

    renderers.add(ufoManager);
    renderers.add(volcanoManager);
    renderers.add(playerManager);
    renderers.add(trexManager);
    renderers.add(earth);
    renderers.add(roids);
    renderers.add(starManager);

    screenRenderers.add(gameText);
    screenRenderers.add(ui);

    status = RUNNING;
  }

  void update () {

    for (updateable u : updaters) u.update();
  }

  void render () {

    pushMatrix(); // world-space
    translate(camera.x, camera.y);
    scale(SCALE);
    for (renderable r : renderers) r.render();
    popMatrix(); 

    pushMatrix(); // screen-space (UI)
    translate(width/2, height/2);
    scale(SCALE);
    gameText.render();
    assets.applyBlur();
    ui.render();
    popMatrix();

    pushMatrix(); // pillarboxing (for high aspect ratios)
    pushStyle();
    translate(0, 0);
    float w = 2678 / 2 * SCALE;
    fill(0, 0, 0, 1);
    rect(0, 0, (width-w)/2, height);
    rect((width-w)/2 + w, 0, (width-w)/2, height);
    popStyle();
    popMatrix();
  }

  //int nextScene () {
  //  return SINGLEPLAYER;
  //}
}

class testScene extends Scene {

  Earth earth;
  EventManager eventManager;
  ColorDecider currentColor;
  StarManager starManager;  
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

  testScene (int lvl) {
    sceneID = TRIASSIC;

    eventManager = new EventManager();
    time = new Time(eventManager);
    earth = new Earth(time, eventManager, lvl);
    //earth.dr = 0;

    camera = new Camera(0, 0);
    roids = new RoidManager(earth, eventManager, time);
    currentColor = new ColorDecider();
    starManager = new StarManager(currentColor, time, eventManager, lvl);
    //starManager = new StarManager(currentColor, time);

    //soundManager = new SoundManager(main, eventManager);
    volcanoManager = new VolcanoManager(eventManager, time, currentColor, earth, lvl);
    playerManager = new PlayerManager(eventManager, earth, time, volcanoManager, starManager, camera);
    playerManager.spawningDuration = 10;
    ui = new UIStory(eventManager, time, currentColor, lvl);
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
    //pushMatrix(); // world-space
    //translate(camera.x, camera.y);
    //for (renderable r : renderers) r.render();

    //popMatrix(); // screen-space
    //for (renderableScreen rs : screeenRenderers) rs.render(); // UI
  }

  //int nextScene () {
  //  return SINGLEPLAYER;
  //}
}
