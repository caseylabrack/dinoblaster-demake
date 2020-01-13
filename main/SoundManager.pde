class SoundManager implements roidImpactEvent {
 
  SoundFile[] roid_impacts = new SoundFile[5];
  PApplet main;
  
  SoundManager (GameMode _mode, PApplet _p) {
    main = _p;
    _mode.eventManager.roidImpactSubscribers.add(this);
    
    for(int i = 1; i <= 5; i++) {
      roid_impacts[i-1] = new SoundFile(main, "impact"+i+".wav");
    }
  }
  
  void roidImpactHandle(PVector p) {
    roid_impacts[int(random(roid_impacts.length-1))].play();
  }
}
