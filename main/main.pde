import processing.sound.*;

boolean paused = false;
Scene currentScene;
PShader glow;

// recording
int fcount = 0;
boolean rec = false;

Keys keys = new Keys();
AssetManager assets = new AssetManager();
JSONObject settings;

boolean jurassicUnlocked, cretaceousUnlocked;
char leftkey, rightkey, leftkey2p, rightkey2p;

void setup () {
  //size(1024, 768, P2D);
  size(1024, 768, P2D);
  pixelDensity(displayDensity());

  //fullScreen(P2D);
  surface.setTitle("DinoBlaster DX");

  colorMode(HSB, 360, 100, 100, 1);
  imageMode(CENTER);

  noCursor();
  assets.load();
  glow = loadShader("glow.glsl");

  try {
    settings = loadJSONObject("user-settings.json");
  }
  catch(Exception e) {
    settings = new JSONObject();
    settings.setBoolean("roidsEnabled", true);
    settings.setBoolean("hypercubesEnabled", true);
    settings.setBoolean("ufosEnabled", true);
    settings.setFloat("defaultTimeScale", 1);
    settings.setInt("extraLives", 0);
    settings.setFloat("earthRotationSpeed", 2.3);
    settings.setFloat("playerSpeed", 5);
    settings.setBoolean("JurassicUnlocked", true);
    settings.setBoolean("CretaceousUnlocked", true);
    settings.setBoolean("hideHelpButton", true);
    settings.setString("player1LeftKey", "a");
    settings.setString("player1RightKey", "d");
    settings.setString("player2LeftKey", "l");
    settings.setString("player2RightKey", "k");
    saveJSONObject(settings, "user-settings.json");
  }

  jurassicUnlocked = settings.getBoolean("JurassicUnlocked", false);
  cretaceousUnlocked = settings.getBoolean("CretaceousUnlocked", false);
  leftkey = settings.getString("player1LeftKey", "a").charAt(0);
  rightkey = settings.getString("player1RightKey", "d").charAt(0);

  currentScene = new SinglePlayer(UIStory.TRIASSIC);
}

void keyPressed() {

  //println(key, keyCode);
  //println(key==CODED);

  if (key==CODED) {
    if (keyCode==LEFT) keys.setKey(Keys.LEFT, true);
    if (keyCode==RIGHT) keys.setKey(Keys.RIGHT, true);  
  } else {
    if (key=='1') currentScene = new SinglePlayer(UIStory.TRIASSIC);
    if (key=='2') currentScene = new SinglePlayer(UIStory.JURASSIC);
    if (key=='3') currentScene = new SinglePlayer(UIStory.CRETACEOUS);
    if (key==leftkey) keys.setKey(Keys.LEFT, true);
    if (key==rightkey) keys.setKey(Keys.RIGHT, true);
    if (key=='r') {
      rec = true;
      println("recording");
    }
  }
}

void keyReleased() {

  if (key==CODED) {
    if (keyCode==LEFT) keys.setKey(Keys.LEFT, false);
    if (keyCode==RIGHT) keys.setKey(Keys.RIGHT, false);
  } else {
    if (key==leftkey) keys.setKey(Keys.LEFT, false);
    if (key==rightkey) keys.setKey(Keys.RIGHT, false);
    if (key=='r') {
      rec = false;
      println("stopped recording");
    }
  }
}

void mousePressed () {
  frameRate(5);
}

void mouseReleased () {
  frameRate(60);
  //rec = true;
}

void draw () {

  if (!paused) {
    background(0);
    if(currentScene.status==Scene.DONE) {
      println("oh shit");
    }
    currentScene.update();
    currentScene.render();
  }

  if (rec) {
    if (frameCount % 1 == 0) {
      saveFrame("spoofs-and-goofs/frames/dino-" + nf(fcount, 4) + ".png");
      fcount++;
    }
    //if (fcount==360) exit();
    pushStyle();
    stroke(0, 0, 100);
    strokeWeight(2);
    fill(0, 70, 80);
    circle(width - 20, 20, 20);
    popStyle();
  }
}

class Keys {

  // keys on picade console:
  // |joy|    |16| |90| |88|
  //          |17| |18| |32|

  // front panel:
  // |27|      |79|

  static final int LEFT = 0;
  static final int RIGHT = 1;
  boolean left = false;
  boolean right = false;
  boolean anykey = false;

  void setKey(int _key, boolean _value) {

    switch(_key) {

    case LEFT:
      left = _value;
      break;

    case RIGHT:
      right = _value;
      break;

    default:
      println("unknown key press/release");
      break;
    }

    anykey = left || right;
  }
}
