class UIStuff implements gameOverEvent, updateable, renderable {
  PFont hyperspace;
  boolean isGameOver = false;

  UIStuff () {
    hyperspace = loadFont("ProcessingSansPro-Regular-48.vlw");
    textFont(hyperspace);

    eventManager.gameOverSubscribers.add(this);
  }

  void gameOverHandle() {
    isGameOver = true;
  }

  void update () {
  }

  void render () {
    if (isGameOver) {
      pushMatrix();
      textAlign(CENTER, CENTER);
      fill(0, 50, 50); 
      text("EXTINCT", width/2, height/2);
      popMatrix();
    }
  }
} 
