class EventManager {
  ArrayList<gameOverEvent> gameOverSubscribers = new ArrayList<gameOverEvent>();
  ArrayList<roidImpactEvent> roidImpactSubscribers = new ArrayList<roidImpactEvent>();
  
  EventManager () {
  
  }
  
  void dispatchGameOver () {
    for(gameOverEvent g : gameOverSubscribers) g.gameOverHandle();
  }
  
  void dispatchRoidImpact(PVector p) {
    for(roidImpactEvent r : roidImpactSubscribers) r.roidImpactHandle(p);
  }
} 

interface gameOverEvent {
  void gameOverHandle();
}

interface roidImpactEvent {
  void roidImpactHandle(PVector p);
}
