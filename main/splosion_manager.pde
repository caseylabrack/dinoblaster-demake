class SplosionManager {
  ArrayList<Explosion> splodes = new ArrayList<Explosion>();
  SplosionManager () {
  }

  void update () {
    for (Explosion s : splodes) {
      s.update();
      s.render();
    }
    ArrayList<Explosion> markedForDeletion = new ArrayList<Explosion>();
    for (Explosion s : splodes) {
      if (!s.visible) {
        markedForDeletion.add(s);
      }
    }
    splodes.removeAll(markedForDeletion);
  }
}
