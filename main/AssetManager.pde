class AssetManager {

  UFOstuff ufostuff = new UFOstuff();
  UIStuff uiStuff = new UIStuff();
  VolcanoStuff volcanoStuff = new VolcanoStuff();
  RoidStuff roidStuff = new RoidStuff();
  PlayerStuff playerStuff = new PlayerStuff();
  TrexStuff trexStuff = new TrexStuff();
  EarthStuff earthStuff = new EarthStuff();

  void load () {
    ufostuff.ufoFrames = utils.sheetToSprites(loadImage("ufo-resizing-sheet.png"), 3, 3);
    ufostuff.brontoAbductionFrames = utils.sheetToSprites(loadImage("bronto-abduction-sheet.png"), 3, 3);    
    ufostuff.ufoSVG = loadShape("UFO.svg");
    ufostuff.ufoSVG.disableStyle();

    uiStuff.extinctSign = loadImage("gameover-lettering.png");
    uiStuff.letterbox = loadImage("letterboxes2.png");
    //uiStuff.MOTD = createFont("Hyperspace.otf", 32);
    uiStuff.MOTD = createFont("Hyperspace Bold.otf", 32);

    volcanoStuff.volcanoFrames = utils.sheetToSprites(loadImage("volcanos.png"), 4, 1);
    roidStuff.explosionFrames = utils.sheetToSprites(loadImage("explosion.png"), 3, 1);
    roidStuff.roidFrames = utils.sheetToSprites(loadImage("roids.png"), 2, 2);
    roidStuff.trail = loadImage("roid-trail.png");

    playerStuff.dethSVG = loadShape("bronto-death.svg");
    playerStuff.dethSVG.disableStyle();
    playerStuff.brontoSVG = loadShape("bronto-idle.svg");
    playerStuff.brontoSVG.disableStyle();

    trexStuff.trexIdle = loadImage("trex-idle.png");
    trexStuff.trexRun1 = loadImage("trex-run1.png");
    trexStuff.trexRun2 = loadImage("trex-run2.png");
    trexStuff.eggCracked = loadImage("egg-cracked.png");
    trexStuff.eggBurst = loadImage("egg-burst.png");

    earthStuff.earth = loadImage("earth.png");
    earthStuff.tarpitMask = loadImage("earth-mask-test.png");
    earthStuff.mask = loadShader("pixelmask.glsl");
    //earthStuff.mask.set("mask", earthStuff.tarpitMask);
  }

  class UFOstuff {
    PImage[] ufoFrames;  
    PImage[] brontoAbductionFrames;
    PShape ufoSVG;
  }

  class UIStuff {
    PImage extinctSign;
    PImage letterbox;
    PFont MOTD;
  }

  class VolcanoStuff {
    PImage[] volcanoFrames;
  }

  class RoidStuff {
    PImage[] explosionFrames;
    PImage[] roidFrames;
    PImage trail;
  }

  class PlayerStuff {
    PShape dethSVG;
    PShape brontoSVG;
  }

  class TrexStuff {
    PImage trexIdle;
    PImage trexRun1;
    PImage trexRun2;
    PImage eggCracked;
    PImage eggBurst;
  }

  class EarthStuff {
    PImage earth;
    PImage tarpitMask;
    PShader mask;
  }
}
