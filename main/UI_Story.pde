class UIStory implements gameOverEvent, abductionEvent, updateable, renderableScreen {
  PFont EXTINCT;
  PFont body;
  //PImage extinc
  boolean isGameOver = false;
  float score = 0;
  int stage = 1;
  int lastScoreTick = 0;
  String currentStage = "Triassic";
  String nextStage = "Jurassic";
  EventManager eventManager;
  ColorDecider currentColor;

  PImage extralifeSheet;
  PImage[] extralifeIcons;
  int extralives = 0;
  float extralifeAnimationStart = 0;
  boolean extralifeAnimating = false;
  float extralifeAnimationDuration = 5e3;

  PImage letterbox;

  UIStory (EventManager _eventManager, ColorDecider _currentColor) {
    eventManager = _eventManager;
    currentColor = _currentColor;
    //EXTINCT = createFont("Hyperspace", 92);
    //body = createFont("Hyperspace Bold", 24);
    //textFont(EXTINCT);
    //textFont(body);

    eventManager.gameOverSubscribers.add(this);
    eventManager.abductionSubscribers.add(this);

    extralifeSheet = loadImage("bronto-abduction-sheet.png");
    extralifeIcons = utils.sheetToSprites(extralifeSheet, 3, 3);

    letterbox = loadImage("letterboxes.png");
  }

  void gameOverHandle() {
    isGameOver = true;
  }

  void abductionHandle(PVector p) {
    extralifeAnimationStart = millis();
    extralifeAnimating = true;
    extralives++;
  }

  void update () {
    if (isGameOver) return;

    if (millis() - lastScoreTick > 1000) {
      score++;
      lastScoreTick = millis();
    }

    if (score==100) {
      stage++;
      currentStage = "Jurassic";
      nextStage = "Cretaceous";
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
    line(64, 40, 64, 40 + score/100 * stage * (height - 40));
    popStyle();

    // letterbox
    pushStyle();
    imageMode(CORNER);
    image(letterbox, 0, 0);
    popStyle();

    // letterboxes
    //pushStyle();
    //imageMode(CORNER);
    //fill(0, 0, 0);
    //noStroke();
    //image(letterboxLeft, 0, 0);
    //image(letterboxRight, 1024 - 128, 0);
    //popStyle();

    if (extralives > 0) {
      int i = 0;
      for (i = 0; i < extralives-1; i++) {
        image(extralifeIcons[4], 1024 - 128 + 64, 64 + i * 48);
      }
      int index = 4;
      if (extralifeAnimating) {
        float progress = (millis() - extralifeAnimationStart)/extralifeAnimationDuration;
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
      //textFont(EXTINCT);
      //textAlign(CENTER, CENTER);

      //text("EXTINCT", width/2, height/2);
      pushMatrix();
      imageMode(CORNER);
      tint(currentColor.getColor()); 
      image(assets.uiStuff.extinctSign, 0, 0);
      popMatrix();
      popStyle();
    }
  }
} 
