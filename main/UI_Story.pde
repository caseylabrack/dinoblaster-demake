class UIStory implements gameOverEvent, abductionEvent, playerDiedEvent, playerSpawnedEvent, playerRespawnedEvent, updateable, renderableScreen {
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

  int extralives;
  float extralifeAnimationStart = 0;
  boolean extralifeAnimating = false;
  float extralifeAnimationDuration = 5e3;

  float highscore = 85;
  boolean newHighScore = false;

  final String SCORE_DATA_FILENAME = "dino.dat";
  StringList motds;
  int motdIndex = 0;
  float motdStart;
  final float MOTD_DURATION = 4e3;
  
  boolean extinctDisplay = true;
  final float EXTINCT_FLICKER_RATE_START = 100;
  float extinctFlickerRate = 100;
  final float EXTINCT_FLICKERING_DURATION = 3e3;
  float extinctFlickeringStart;

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

    extralives = settings.getInt("extraLives", 0);

    motds = new StringList();
    motds.append("Real Winners Say No to Drugs");
    motds.append("This is Fine");
    motds.append("Life Finds a Way");
    motds.append("Tough Out There for Sauropods"); 
    motds.shuffle();
    motdStart = millis();

    byte[] scoreData = loadBytes(SCORE_DATA_FILENAME);
    if (scoreData==null) {
      highscore = 0;
    } else {
      highscore = 0;
      for (byte n : scoreData) {
        highscore += float(n + 128);
      }
    }
    println("highscore: " + highscore);
  }

  void gameOverHandle() {
    isGameOver = true;
    gameOverGracePeriodStart = millis();
    extinctFlickeringStart = millis();
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
      //score+=10;
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
    //pushStyle();
    //fill(0, 0, 0);
    //noStroke();
    //rect(-WIDTH_REF_HALF, -HEIGHT_REF_HALF, 128, HEIGHT_REFERENCE);
    ////rect(WIDTH_REF_HALF - 128, -HEIGHT_REF_HALF, 128, HEIGHT_REFERENCE);
    ////rect(0, 0, 128, height);
    ////rect(1024 - 128, 0, 128, height);
    //popStyle();

    push();
    imageMode(CORNER);
    image(assets.uiStuff.progressBG, -WIDTH_REF_HALF + 40, -HEIGHT_REF_HALF);
    image(assets.uiStuff.extraDinosBG, WIDTH_REF_HALF - 100, -HEIGHT_REF_HALF);
    pop();

    // score tracker
    push();
    //tint(0,60,99,1);
    imageMode(CENTER);
    float p = ((float)score)/300.0;
    float totalpixels = HEIGHT_REFERENCE - 80;
    float fillupto = p * totalpixels;
    float tickheight = 10;//assets.uiStuff.tick.height;
    for (int i = 0; i < fillupto; i+=tickheight) {
      image(assets.uiStuff.tick, -WIDTH_REF_HALF + 64, -HEIGHT_REF_HALF + 40 + i);
    }
    pop();

    // acrylics
    pushStyle();
    imageMode(CENTER);
    pushMatrix();
    image(assets.uiStuff.letterbox, 0, 0, assets.uiStuff.letterbox.width, HEIGHT_REFERENCE);
    popMatrix();
    popStyle();

    image(extralives>=1 ? assets.uiStuff.extraDinoActive : assets.uiStuff.extraDinoInactive, WIDTH_REF_HALF - 65, -HEIGHT_REF_HALF + 75);
    image(extralives>=2 ? assets.uiStuff.extraDinoActive : assets.uiStuff.extraDinoInactive, WIDTH_REF_HALF - 65, -HEIGHT_REF_HALF + 75 + 75);
    image(extralives>=3 ? assets.uiStuff.extraDinoActive : assets.uiStuff.extraDinoInactive, WIDTH_REF_HALF - 65, -HEIGHT_REF_HALF + 75 + 75 + 75);
    //if (extralives > 0) {
    //  int i = 0;
    //  for (i = 0; i < extralives-1; i++) {
    //    image(extralifeIcons[4], 1024 - 128 + 64, 64 + i * 48);
    //  }
    //  int index = 4;
    //  if (extralifeAnimating) {
    //    float progress = (time.getClock() - extralifeAnimationStart)/extralifeAnimationDuration;
    //    if (progress < 1) {
    //      index = 4 + floor((1 - progress - .0001) * 5);
    //    } else {
    //      extralifeAnimating = false;
    //    }
    //  }
    //  image(extralifeIcons[index], 1024 - 128 + 64, 64 + i * 48);
    //}

    if (millis() - motdStart < MOTD_DURATION) {
      pushStyle();
      textFont(assets.uiStuff.MOTD);
      textAlign(CENTER, CENTER);
      text(motds.get(0), 0, -HEIGHT_REF_HALF + 50);
      popStyle();
    }

    if (isGameOver) {
      pushStyle();
      fill(currentColor.getColor());
      textFont(assets.uiStuff.extinctType);
      textAlign(CENTER, CENTER);

      if(millis() - extinctFlickeringStart < EXTINCT_FLICKERING_DURATION) {
        extinctDisplay = !extinctDisplay;
        if(extinctDisplay) {
          text("EXTINCT", 
          15, // optical margin adjustment 
          0);
        }
      } else {
       text("EXTINCT", 
        15, // optical margin adjustment 
        0); 
      }
            popStyle();

      //pushStyle();
      //pushMatrix();
      //imageMode(CENTER);
      //tint(currentColor.getColor()); 
      //image(assets.uiStuff.extinctSign, 0, 0);
      //popMatrix();
      //popStyle();
    }
  }
} 
