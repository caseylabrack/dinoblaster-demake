class EventManager {
  ArrayList<gameOverEvent> gameOverSubscribers = new ArrayList<gameOverEvent>();
  EventManager () {
  
  }
  
  void dispatchGameOver () {
    for(gameOverEvent g : gameOverSubscribers) g.gameOverHandle();
  }
} 

interface gameOverEvent {
  void gameOverHandle();
}
