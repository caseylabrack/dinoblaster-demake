class EventManager {
  ArrayList<gameOverEvent> gameOverSubscribers = new ArrayList<gameOverEvent>();
  ArrayList<roidImpactEvent> roidImpactSubscribers = new ArrayList<roidImpactEvent>();
  ArrayList<abductionEvent> abductionSubscribers = new ArrayList<abductionEvent>();
  
  EventManager () {
  
  }
  
  void dispatchGameOver () {
    for(gameOverEvent g : gameOverSubscribers) g.gameOverHandle();
  }
  
  void dispatchRoidImpact(PVector p) {
    for(roidImpactEvent r : roidImpactSubscribers) r.roidImpactHandle(p);
  }
  
  void dispatchAbduction(PVector p) {
    for(abductionEvent a : abductionSubscribers) a.abductionHandle(p);
  }
} 

interface gameOverEvent {
  void gameOverHandle();
}

interface roidImpactEvent {
  void roidImpactHandle(PVector p);
}

interface abductionEvent {
  void abductionHandle(PVector p);
}
