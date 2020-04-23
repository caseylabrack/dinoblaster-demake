class UIStory implements gameOverEvent, abductionEvent, playerDiedEvent, playerSpawnedEvent, playerRespawnedEvent, updateable, renderableScreen {
  PFont EXTINCT;
  PFont body;
  boolean isGameOver = false;
  float score = 0;
  int stage = 1;
  float lastScoreTick = 0;
  boolean scoring = false;
  
  EventManager eventManager;
  ColorDecider currentColor;
  Time time;

  PImage extralifeSheet;
  PImage[] extralifeIcons;
  int extralives = 0;
  float extralifeAnimationStart = 0;
  boolean extralifeAnimating = false;
  float extralifeAnimationDuration = 5e3;

  PImage letterbox;

  UIStory (EventManager _eventManager, Time t, ColorDecider _currentColor) {
    eventManager = _eventManager;
    currentColor = _currentColor;
    time = t;
    
    lastScoreTick = time.getClock();

    eventManager.gameOverSubscribers.add(this);
    eventManager.abductionSubscribers.add(this);
    eventManager.playerDiedSubscribers.add(this);
    eventManager.playerSpawnedSubscribers.add(this);
    eventManager.playerRespawnedSubscribers.add(this);

    extralifeSheet = loadImage("bronto-abduction-sheet.png");
    extralifeIcons = utils.sheetToSprites(extralifeSheet, 3, 3);

    letterbox = loadImage("letterboxes.png");
  }

  void gameOverHandle() {
    isGameOver = true;
  }
  
  void playerSpawnedHandle(Player p) {
    scoring = true;
  }
  
  void playerRespawnedHandle(PVector position) {
  scoring = true;
  }
  
  void playerDiedHandle(PVector position) {
    extralives--;
    scoring = false;
  }

  void abductionHandle(PVector p) {
    extralifeAnimationStart = time.getClock();
    extralifeAnimating = true;
    extralives++;
    scoring = false;
  }

  void update () {
    if (isGameOver) return;
    
    if (time.getClock() - lastScoreTick > 1000 && scoring) {
      score++;
      lastScoreTick = time.getClock();
    }
  }

  void render () {

    // letterbox bg
    pushStyle();
    fill(0, 0, 0);
    noStroke();
    rect(0, 0, 128, height);
    rect(1024 - 128, 0, 128, height);
    popStyle();

    // score tracker
    pushStyle();
    stroke(0, 0, 100);
    strokeWeight(1);
    line(64, 40, 64, 40 + score/300 * stage * (height - 40));
    popStyle();

    // letterbox
    pushStyle();
    imageMode(CORNER);
    image(letterbox, 0, 0);
    popStyle();

    if (extralives > 0) {
      int i = 0;
      for (i = 0; i < extralives-1; i++) {
        image(extralifeIcons[4], 1024 - 128 + 64, 64 + i * 48);
      }
      int index = 4;
      if (extralifeAnimating) {
        float progress = (time.getClock() - extralifeAnimationStart)/extralifeAnimationDuration;
        if (progress < 1) {
          index = 4 + floor((1 - progress - .0001) * 5);
        } else {
          extralifeAnimating = false;
        }
      }
      image(extralifeIcons[index], 1024 - 128 + 64, 64 + i * 48);
    }

    if (isGameOver) {
      pushStyle();
      pushMatrix();
      imageMode(CORNER);
      tint(currentColor.getColor()); 
      image(assets.uiStuff.extinctSign, 0, 0);
      popMatrix();
      popStyle();
    }
  }
} 
