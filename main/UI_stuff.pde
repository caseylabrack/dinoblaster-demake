class UIStuff implements gameOverEvent, updateable, renderable {
  PFont EXTINCT;
  PFont body;
  boolean isGameOver = false;
  float score = 0;
  int stage = 1;
  int lastScoreTick = 0;
  String currentStage = "Triassic";
  String nextStage = "Jurassic";

  UIStuff (OviraptorMode mode) {
    //printArray(PFont.list());
    EXTINCT = createFont("Hyperspace", 92);
    //body = loadFont("Hyperspace-Bold-18.vlw");
    body = createFont("Hyperspace Bold", 24);
    textFont(EXTINCT);
    textFont(body);

    mode.eventManager.gameOverSubscribers.add(this);
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
      //fill(currentColor.getColor()); 
      text("EXTINCT", width/2, height/2);
      popStyle();
    }
  }
} 
