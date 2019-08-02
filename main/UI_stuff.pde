class UIStuff implements gameOverEvent, updateable, renderable {
  PFont EXTINCT;
  PFont body;
  boolean isGameOver = false;
  float score = 0;
  int stage = 1;
  int lastScoreTick = 0;
  String currentStage = "Triassic";
  String nextStage = "Jurassic";

  UIStuff () {
    EXTINCT = loadFont("Hyperspace-Bold-92.vlw");
    body = loadFont("Hyperspace-Bold-18.vlw");
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
    line(5, 25, score/100 * stage * width, 25);

    if (isGameOver) {
      pushStyle();
      textFont(EXTINCT);
      textAlign(CENTER, CENTER);
      fill(0, 50, 50); 
      text("EXTINCT", width/2, height/2);
      popStyle();
    }
  }
} 
