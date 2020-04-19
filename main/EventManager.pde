class EventManager {
  ArrayList<gameOverEvent> gameOverSubscribers = new ArrayList<gameOverEvent>();
  ArrayList<roidImpactEvent> roidImpactSubscribers = new ArrayList<roidImpactEvent>();
  ArrayList<abductionEvent> abductionSubscribers = new ArrayList<abductionEvent>();
  ArrayList<playerSpawnedEvent> playerSpawnedSubscribers = new ArrayList<playerSpawnedEvent>();
  ArrayList<playerDiedEvent> playerDiedSubscribers = new ArrayList<playerDiedEvent>();
  
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
  
  void playerSpawned(Player p) {
    for(playerSpawnedEvent s : playerSpawnedSubscribers) s.playerSpawnedHandle(p);
  }
  
  void dispatchPlayerDied(PVector position) {
    for(playerDiedEvent s: playerDiedSubscribers) s.playerDiedHandle(position);
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

interface playerSpawnedEvent {
  void playerSpawnedHandle(Player p);
}

interface playerDiedEvent {
  void playerDiedHandle(PVector position);
}
