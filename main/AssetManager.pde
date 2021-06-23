class AssetManager {

  final float STROKE_WIDTH = 2;
  final int DEFAULT_BLURINESS = 6;

  PShader blur;
  boolean blurring = true;

  StringList motds;
  int motdsIndex;

  UFOstuff ufostuff = new UFOstuff();
  UIStuff uiStuff = new UIStuff();
  VolcanoStuff volcanoStuff = new VolcanoStuff();
  RoidStuff roidStuff = new RoidStuff();
  PlayerStuff playerStuff = new PlayerStuff();
  TrexStuff trexStuff = new TrexStuff();
  EarthStuff earthStuff = new EarthStuff();
  MusicStuff musicStuff = new MusicStuff();
  ArrayList<SoundPlayable> sounds = new ArrayList<SoundPlayable>(); 
  ArrayList<SoundPlayable> musics = new ArrayList<SoundPlayable>(); 

  void load (PApplet context) {

    blur = loadShader("blur.glsl");

    motds = new StringList();
    motds.append("Real Winners Say No to Drugs");
    motds.append("This is Fine");
    motds.append("Life Finds a Way");
    motds.append("Tough Out There for Sauropods"); 
    motds.append("rawr");
    motds.append("hold on to your butts");
    motds.shuffle();

    ufostuff.ufoFrames = utils.sheetToSprites(loadImage("ufo-resizing-sheet.png"), 3, 3);
    ufostuff.brontoAbductionFrames = utils.sheetToSprites(loadImage("bronto-abduction-sheet.png"), 3, 3);    
    ufostuff.ufoSVG = loadShape("UFO.svg");
    ufostuff.ufoSVG.disableStyle();

    uiStuff.extinctType = createFont("Hyperspace.otf", 150);
    //uiStuff.extinctSign = loadImage("gameover-lettering.png");
    uiStuff.letterbox = loadImage("letterboxes2.png");
    uiStuff.MOTD = createFont("Hyperspace Bold.otf", 32);
    uiStuff.progressBG = loadImage("progress-bg.png");
    uiStuff.extraDinosBG = loadImage("extra-life-bg.png");
    uiStuff.tick = loadImage("progress-tick.png");
    uiStuff.extraDinoActive = loadImage("extra-dino-active.png");
    uiStuff.extraDinoInactive = loadImage("extra-dino-deactive.png");

    volcanoStuff.volcanoFrames = utils.sheetToSprites(loadImage("volcanos.png"), 4, 1);

    roidStuff.explosionFrames = utils.sheetToSprites(loadImage("explosion.png"), 3, 1);
    roidStuff.roidFrames = utils.sheetToSprites(loadImage("roids.png"), 2, 2);
    roidStuff.trail = loadImage("roid-trail.png");
    for (int i = 0; i < roidStuff.hits.length; i++) {
      roidStuff.hits[i] = raspi ? new SoundM("impact" + (i + 1) + ".wav") : new SoundP("impact" + (i + 1) + ".wav", context);
      sounds.add(roidStuff.hits[i]);
    }

    playerStuff.dethSVG = loadShape("bronto-death.svg");
    playerStuff.dethSVG.disableStyle();
    playerStuff.brontoSVG = loadShape("bronto-idle.svg");
    playerStuff.brontoSVG.disableStyle();
    playerStuff.brontoFrames = utils.sheetToSprites(loadImage("bronto-frames.png"), 3, 1);
    playerStuff.oviFrames = utils.sheetToSprites(loadImage("oviraptor-frames.png"), 2, 2, 1);
    playerStuff.extinct = raspi ? new SoundM("audio/player/extinct.wav") : new SoundP("audio/player/extinct.wav", context);
    sounds.add(playerStuff.extinct);
    playerStuff.spawn = raspi ? new SoundM("audio/player/spawn.wav") : new SoundP("audio/player/spawn.wav", context);
    sounds.add(playerStuff.spawn);

    trexStuff.trexIdle = loadImage("trex-idle.png");
    trexStuff.trexRun1 = loadImage("trex-run1.png");
    trexStuff.trexRun2 = loadImage("trex-run2.png");
    trexStuff.eggCracked = loadImage("egg-cracked.png");
    trexStuff.eggBurst = loadImage("egg-burst.png");

    earthStuff.earth = loadImage("earth.png");
    earthStuff.mask = loadShader("pixelmask.glsl");
    //earthStuff.mask.set("mask", earthStuff.tarpitMask);
    earthStuff.doodadBone = loadImage("doodad-bone.png");
    earthStuff.doodadFemur = loadImage("doodad-femur.png");
    earthStuff.doodadHead = loadImage("doodad-head.png");
    earthStuff.doodadRibs = loadImage("doodad-ribcage.png");

    musicStuff.lvl1a = raspi ? new SoundM("data/music/Track 1 (Seek Position)_No Fade_DinoBlaster_JoshuaSzweda_031117.wav") : new SoundP("data/music/Track 1 (Seek Position)_No Fade_DinoBlaster_JoshuaSzweda_031117.wav", context);
    musicStuff.lvl1b = raspi ? new SoundM("data/music/Track 1_No Fade_DinoBlaster_JoshuaSzweda_031117.wav") : new SoundP("data/music/Track 1_No Fade_DinoBlaster_JoshuaSzweda_031117.wav", context);
    musicStuff.lvl2a = raspi ? new SoundM("data/music/Track 2 (Seek Position)_No Fade_DinoBlaster_JoshuaSzweda_081117.wav") : new SoundP("data/music/Track 2 (Seek Position)_No Fade_DinoBlaster_JoshuaSzweda_081117.wav", context);
    musicStuff.lvl2b = raspi ? new SoundM("data/music/Track 2_No Fade_DinoBlaster_JoshuaSzweda_071117.wav") : new SoundP("data/music/Track 2_No Fade_DinoBlaster_JoshuaSzweda_071117.wav", context);
    musicStuff.lvl3 = raspi ? new SoundM("data/music/Track 3_Long Loop_DinoBlaster_JoshuaSzweda_081117.wav") : new SoundP("data/music/Track 3_Long Loop_DinoBlaster_JoshuaSzweda_081117.wav", context);
    musics.add(musicStuff.lvl1a);
    musics.add(musicStuff.lvl1b);
    musics.add(musicStuff.lvl2a);
    musics.add(musicStuff.lvl2b);
    musics.add(musicStuff.lvl3);
  }

  void setBlur (int blurriness) {
    if (blurriness != 0) {
      assets.blur.set("blurSize", blurriness);
      assets.blur.set("sigma", (float)blurriness/2);
      blurring = true;
    } else {
      blurring = false;
    }
  }

  void applyBlur () {
    if (!blurring) return;
    blur.set("horizontalPass", 0);
    filter(blur);
    blur.set("horizontalPass", 1);
    filter(blur);
  }

  void muteSFX (boolean mute) {
    for (SoundPlayable s : sounds) s.mute(mute);
  }

  void muteMusic (boolean mute) {
    for (SoundPlayable m : musics) m.mute(mute);
  }

  void stopAllMusic () {
    for (SoundPlayable s : musics) s.stop_();
  }

  String getMOTD () {

    String m = motds.get(motdsIndex);

    motdsIndex++;
    if (motdsIndex > motds.size() - 1) {
      motds.shuffle();
      motdsIndex = 0;
    }

    return m;
  }

  class UFOstuff {
    PImage[] ufoFrames;  
    PImage[] brontoAbductionFrames;
    PShape ufoSVG;
  }

  class UIStuff {
    //PImage extinctSign;
    PImage letterbox;
    PFont MOTD;
    PImage progressBG;
    PImage extraDinosBG;
    PImage tick;
    PImage extraDinoActive;
    PImage extraDinoInactive;
    PFont extinctType;
  }

  class VolcanoStuff {
    PImage[] volcanoFrames;
  }

  class RoidStuff {
    PImage[] explosionFrames;
    PImage[] roidFrames;
    PImage trail;
    SoundPlayable[] hits = new SoundPlayable[5];
  }

  class PlayerStuff {
    PShape dethSVG;
    PShape brontoSVG;
    PImage[] brontoFrames;
    PImage[] oviFrames;
    SoundPlayable extinct;
    SoundPlayable spawn;
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
    PImage doodadBone;
    PImage doodadFemur;
    PImage doodadHead;
    PImage doodadRibs;
  }

  class MusicStuff {
    SoundPlayable lvl1a;
    SoundPlayable lvl1b;
    SoundPlayable lvl2a;
    SoundPlayable lvl2b;
    SoundPlayable lvl3;
  }
}

interface SoundPlayable {
  void play(boolean loop);
  void mute(Boolean m);
  void stop_();
  void rate(float r);
}

// the Minim library for Processing (Picade needs)
class SoundM implements SoundPlayable {

  AudioPlayer player;
  TickRate rateControl;
  FilePlayer filePlayer;
  AudioOutput out;

  SoundM (String file) {
    player = minim.loadFile(file);
  }

  void play(boolean loop) {
    player.rewind();
    if (loop) {
      player.loop();
    } else {
      player.play();
    }
  }

  void stop_ () {
    player.pause();
  }

  void rate(float r) {
  }

  void mute(Boolean m) {
    if (m) {
      player.mute();
    } else {
      player.unmute();
    }
  }
}

// the Processing 3.0 official sound library (Android needs)
class SoundP implements SoundPlayable {

  SoundFile player;

  SoundP (String file, PApplet context) {
    player = new SoundFile(context, file);
  }

  void play(boolean loop) {
    if (loop) {
      player.loop();
    } else {
      player.play();
    }
  }

  void stop_ () {
    player.stop();
  }

  void rate (float r) {
    player.rate(r);
  }

  void mute(Boolean m) {
    if (m) {
      player.amp(0);
    } else {
      player.amp(1);
    }
  }
}
