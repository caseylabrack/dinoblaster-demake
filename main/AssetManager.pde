class AssetManager {

  UFOstuff ufostuff = new UFOstuff();
    
  void load () {
    ufostuff.ufoFrames = utils.sheetToSprites(loadImage("ufo-resizing-sheet.png"), 3, 3);
    ufostuff.brontoAbductionFrames = utils.sheetToSprites(loadImage("bronto-abduction-sheet.png"), 3, 3);    
  }
  
  class UFOstuff {
    PImage[] ufoFrames;  
    PImage[] brontoAbductionFrames;
  }
}
