class UIStory implements gameOverEvent, abductionEvent, playerDiedEvent, playerSpawnedEvent, playerRespawnedEvent, updateable, renderableScreen {
  PFont EXTINCT;
  PFont body;
  boolean isGameOver = false;
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
    if (isGameOver) return;
    
    if(!newHighScore) {
      if(score > highscore) {
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
    noFill();
    strokeWeight(1);
    //line(64, 40, 64, endpoint);
    pushMatrix();
    //translate(64, 100);
    translate(64, 40 + (highscore/300.0) * (height - 80));
    //println((85.0/300.0) * (height - 80));
    rotate(PI/4);
    rect(0, 0, 8, 8);
    popMatrix();
    pushMatrix();
    int endpoint = 40 + round(score/300 * (height - 80));
    translate(64, endpoint);
    rotate(PI/4);
    if(newHighScore) stroke(currentColor.getColor());
    rect(0, 0, 16, 16);
    //image(assets.ufostuff.brontoAbductionFrames[5], 0,0);
    popMatrix();
    popStyle();

    // letterbox
    pushStyle();
    imageMode(CORNER);
    pushMatrix();
    //translate(0,0,10);
    image(letterbox, 0, 0);
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
      imageMode(CORNER);
      tint(currentColor.getColor()); 
      image(assets.uiStuff.extinctSign, 0, 0);
      popMatrix();
      popStyle();
    }
  }
} 
