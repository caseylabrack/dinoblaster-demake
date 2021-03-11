class UIStory implements gameOverEvent, abductionEvent, playerDiedEvent, playerSpawnedEvent, playerRespawnedEvent, updateable, renderableScreen {
  PFont EXTINCT;
  PFont body;
  boolean isGameOver = false;
  float gameOverGracePeriodStart;
  final float gameOverGracePeriodDuration = 4e3;
  float score = 0;

  final static int TRIASSIC = 0;
  final static int JURASSIC = 1;
  final static int CRETACEOUS = 2;
  final static int FINAL = 3;
  int stage = TRIASSIC;

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

  float highscore = 85;
  boolean newHighScore = false;

  final String SCORE_DATA_FILENAME = "dino.dat";

  UIStory (EventManager _eventManager, Time t, ColorDecider _currentColor, int lvl) {
    eventManager = _eventManager;
    currentColor = _currentColor;
    time = t;

    stage = lvl;
    score = lvl * 100;

    lastScoreTick = time.getClock();

    eventManager.gameOverSubscribers.add(this);
    eventManager.abductionSubscribers.add(this);
    eventManager.playerDiedSubscribers.add(this);
    eventManager.playerSpawnedSubscribers.add(this);
    eventManager.playerRespawnedSubscribers.add(this);

    extralifeSheet = loadImage("bronto-abduction-sheet.png");
    extralifeIcons = utils.sheetToSprites(extralifeSheet, 3, 3);

    //letterbox = loadImage("letterboxes.png");
    letterbox = loadImage("letterboxes2.png");

    byte[] scoreData = loadBytes(SCORE_DATA_FILENAME);
    if (scoreData==null) {
      highscore = 0;
    } else {
      highscore = 0;
      for (byte n : scoreData) {
        highscore += float(n + 128);
      }
    }
    
  }

  void gameOverHandle() {
    isGameOver = true;
    gameOverGracePeriodStart = millis();
    if (score > highscore) {
      byte[] nums = new byte[score > 255 ? 2 : 1];
      nums[0] = byte(highscore > 255 ? 127 : floor(score) - 128);
      if (highscore > 256) nums[1] = byte(floor(score) - 256 - 127);
      saveBytes(SCORE_DATA_FILENAME, nums);
    }
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

  public void setLevel (int lvl) {
    stage = lvl;
    score = lvl * 100;
  }

  void update () {
    if (isGameOver) {
      if (millis() - gameOverGracePeriodStart > gameOverGracePeriodDuration) {
        if (keys.anykey) {
          currentScene = new SinglePlayer(stage);
        }
      }
      return;
    }

    if (!newHighScore) {
      if (score > highscore) {
        newHighScore = true;
      }
    }

    if (time.getClock() - lastScoreTick > 1000 && scoring) {
      score++;
      lastScoreTick = time.getClock();
    }

    if (score==100 && stage==TRIASSIC) {
      stage = JURASSIC;
      eventManager.dispatchLevelChanged(stage);
    }

    if (score==200 && stage==JURASSIC) {
      stage = CRETACEOUS;
      eventManager.dispatchLevelChanged(stage);
    }
  }

  void render () {

    //  acrylics transparent portions bg
    pushStyle();
    fill(0, 0, 0);
    noStroke();
    rect(-WIDTH_REF_HALF, -HEIGHT_REF_HALF, 128, HEIGHT_REFERENCE);
    rect(WIDTH_REF_HALF - 128, -HEIGHT_REF_HALF, 128, HEIGHT_REFERENCE);
    //rect(0, 0, 128, height);
    //rect(1024 - 128, 0, 128, height);
    popStyle();

    // score tracker 
    // highscore
    pushStyle();
    stroke(0, 0, 100);
    noFill();
    strokeWeight(1);
    pushMatrix();
    rectMode(CENTER);
    translate(-WIDTH_REF_HALF + 64, -HEIGHT_REF_HALF + 40 + (highscore/300.0) * (HEIGHT_REFERENCE - 80));
    rotate(PI/4);
    rect(0, 0, 8, 8);
    popMatrix();
    // current score
    pushMatrix();
    int endpoint = 40 + round(score/300 * (HEIGHT_REFERENCE - 80));
    translate(-WIDTH_REF_HALF + 64, -HEIGHT_REF_HALF + endpoint);
    rotate(PI/4);
    if (newHighScore) stroke(currentColor.getColor());
    rectMode(CENTER);
    rect(0, 0, 16, 16);
    //image(assets.ufostuff.brontoAbductionFrames[5], 0,0);
    popMatrix();
    popStyle();

    // acrylics
    pushStyle();
    imageMode(CENTER);
    pushMatrix();
    image(letterbox, 0, 0, 2678 / 2, HEIGHT_REFERENCE);
    //image(letterbox, width/2, height/2, letterbox.width * height/letterbox.height, height);
    popMatrix();
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
      imageMode(CENTER);
      tint(currentColor.getColor()); 
      image(assets.uiStuff.extinctSign, 0, 0);
      popMatrix();
      popStyle();
    }
  }
} 
