class UIStory implements gameOverEvent, updateable, renderableScreen {
  PFont EXTINCT;
  PFont body;
  boolean isGameOver = false;
  float score = 0;
  int stage = 1;
  int lastScoreTick = 0;
  String currentStage = "Triassic";
  String nextStage = "Jurassic";
  EventManager eventManager;
  ColorDecider currentColor;

  UIStory (EventManager _eventManager, ColorDecider _currentColor) {
    eventManager = _eventManager;
    currentColor = _currentColor;
    EXTINCT = createFont("Hyperspace", 92);
    body = createFont("Hyperspace Bold", 24);
    textFont(EXTINCT);
    textFont(body);

    eventManager.gameOverSubscribers.add(this);
  }

  void gameOverHandle() {
    isGameOver = true;
  }

  void update () {
    if(isGameOver) return;
    
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

    pushStyle();
    textFont(body);
    textAlign(LEFT, TOP);
    text(currentStage, 5, 5);
    popStyle();

    stroke(0, 0, 100);
    strokeWeight(1);
    line(5, 25, score/100 * stage * width-5, 25);

    if (isGameOver) {
      pushStyle();
      textFont(EXTINCT);
      textAlign(CENTER, CENTER);
      fill(currentColor.getColor()); 
      text("EXTINCT", width/2, height/2);
      popStyle();
    }
  }
} 
