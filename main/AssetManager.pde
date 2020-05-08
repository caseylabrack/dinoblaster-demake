class AssetManager {

  UFOstuff ufostuff = new UFOstuff();
  UIStuff uiStuff = new UIStuff();
  VolcanoStuff volcanoStuff = new VolcanoStuff();
  RoidStuff roidStuff = new RoidStuff();
  
  
  void load () {
    ufostuff.ufoFrames = utils.sheetToSprites(loadImage("ufo-resizing-sheet.png"), 3, 3);
    ufostuff.brontoAbductionFrames = utils.sheetToSprites(loadImage("bronto-abduction-sheet.png"), 3, 3);    
    
    uiStuff.extinctSign = loadImage("gameover-lettering.png");
    
    volcanoStuff.volcanoFrames = utils.sheetToSprites(loadImage("volcanos.png"), 4, 1);
    roidStuff.explosionFrames = utils.sheetToSprites(loadImage("explosion.png"), 3, 1);
  }
  
  class UFOstuff {
    PImage[] ufoFrames;  
    PImage[] brontoAbductionFrames;
  }
  
  class UIStuff {
    PImage extinctSign;
  }
  
  class VolcanoStuff {
    PImage[] volcanoFrames;
  }
  
  class RoidStuff {
    PImage[] explosionFrames;
  }
}
