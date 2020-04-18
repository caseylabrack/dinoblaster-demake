class AssetManager {

  UFOstuff ufostuff = new UFOstuff();
  UIStuff uiStuff = new UIStuff();
  
  void load () {
    ufostuff.ufoFrames = utils.sheetToSprites(loadImage("ufo-resizing-sheet.png"), 3, 3);
    ufostuff.brontoAbductionFrames = utils.sheetToSprites(loadImage("bronto-abduction-sheet.png"), 3, 3);    
    
    uiStuff.extinctSign = loadImage("gameover-lettering.png");
  }
  
  class UFOstuff {
    PImage[] ufoFrames;  
    PImage[] brontoAbductionFrames;
  }
  
  class UIStuff {
    PImage extinctSign;
  }
}
