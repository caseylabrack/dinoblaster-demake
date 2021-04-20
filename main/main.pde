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
JSONObject inputs;

boolean jurassicUnlocked, cretaceousUnlocked;
char leftkey, rightkey, leftkey2p, rightkey2p, triassicSelect, jurassicSelect, cretaceousSelect;

float SCALE;
float WIDTH_REFERENCE = 1024;
float WIDTH_REF_HALF = WIDTH_REFERENCE/2;
float HEIGHT_REFERENCE = 768;
float HEIGHT_REF_HALF = HEIGHT_REFERENCE/2;

void setup () {
  size(1024, 768, P2D);
  //fullScreen(P2D);
  orientation(LANDSCAPE);
  //pixelDensity(displayDensity());

  SCALE = (float)height / HEIGHT_REFERENCE;
  
  //surface.setTitle("DinoBlaster DX");

  colorMode(HSB, 360, 100, 100, 1);
  imageMode(CENTER);

  //noCursor();
  assets.load();
  glow = loadShader("glow.glsl");

  try {
    settings = loadJSONObject("game-settings.txt");
  }
  catch(Exception e) {
    settings = new JSONObject();
    PrintWriter output;
    output = createWriter("game-settings.txt"); 
    output.println("{");
    settings.setBoolean("roidsEnabled", true);
    output.println("\t\"roidsEnabled\": true,");
    settings.setBoolean("trexEnabled", true);
    output.println("\t\"trexEnabled\": true,");
    settings.setBoolean("hypercubesEnabled", true);
    output.println("\t\"hypercubesEnabled\": true,");
    settings.setBoolean("ufosEnabled", true);
    output.println("\t\"ufosEnabled\": true,");
    settings.setFloat("defaultTimeScale", 1);
    output.println("\t\"defaultTimeScale\": 1,");
    settings.setInt("extraLives", 0);
    output.println("\t\"extraLives\": 0,");
    settings.setFloat("earthRotationSpeed", Earth.DEFAULT_EARTH_ROTATION);
    output.println("\t\"earthRotationSpeed\": " + Earth.DEFAULT_EARTH_ROTATION + ",");
    settings.setFloat("playerSpeed", Player.DEFAULT_RUNSPEED);
    output.println("\t\"playerSpeed\": " + Player.DEFAULT_RUNSPEED + ",");
    settings.setFloat("roidImpactRateInMilliseconds", RoidManager.DEFAULT_SPAWN_RATE);
    output.println("\t\"roidImpactRateInMilliseconds\": " + (int)(RoidManager.DEFAULT_SPAWN_RATE) + ",");
    settings.setFloat("roidImpactRateVariation", RoidManager.DEFAULT_SPAWN_DEVIATION);
    output.println("\t\"roidImpactRateVariation\": " + (int)(RoidManager.DEFAULT_SPAWN_DEVIATION) + ",");
    settings.setBoolean("JurassicUnlocked", true);
    output.println("\t\"JurassicUnlocked\": true,");
    settings.setBoolean("CretaceousUnlocked", true);
    output.println("\t\"CretaceousUnlocked\": true,");
    settings.setBoolean("hideHelpButton", true);
    output.println("\t\"hideHelpButton\": true");
    output.println("}");
    output.flush();
    output.close();
  }

  try {
    inputs = loadJSONObject("controls-settings.txt");
  }
  catch(Exception e) {
    inputs = new JSONObject();
    PrintWriter output;
    output = createWriter("controls-settings.txt"); 
    output.println("{");
    inputs.setString("player1LeftKey", "a");
    output.println("\t\"player1LeftKey\": \"a\",");
    inputs.setString("player1RightKey", "d");
    output.println("\t\"player1RightKey\": \"d\",");
    inputs.setString("player2LeftKey", "k");
    output.println("\t\"player2LeftKey\": \"k\",");
    inputs.setString("player2RightKey", "l");
    output.println("\t\"player2RightKey\": \"l\",");
    inputs.setBoolean("player2UsesArrowKeys", false);
    output.println("\t\"player2UsesArrowKeys\": false,");
    inputs.setString("triassicSelect", "1");
    output.println("\t\"triassicSelect\": \"1\",");
    inputs.setString("jurassicSelect", "2");
    output.println("\t\"jurassicSelect\": \"2\",");
    inputs.setString("cretaceousSelect", "3");
    output.println("\t\"cretaceousSelect\": \"3\"");    
    output.println("}");
    output.flush();
    output.close();
  }

  jurassicUnlocked = settings.getBoolean("JurassicUnlocked", false);
  cretaceousUnlocked = settings.getBoolean("CretaceousUnlocked", false);
  leftkey = inputs.getString("player1LeftKey", "a").charAt(0);
  rightkey = inputs.getString("player1RightKey", "d").charAt(0);
  triassicSelect = inputs.getString("triassicSelect", "1").charAt(0);
  jurassicSelect = inputs.getString("jurassicSelect", "2").charAt(0);
  cretaceousSelect = inputs.getString("cretaceousSelect", "3").charAt(0);  

  currentScene = new SinglePlayer(UIStory.TRIASSIC);
}

void keyPressed() {

  //println(key, keyCode);
  //println(key==CODED);

  if (key==CODED) {
    if (keyCode==LEFT) keys.setKey(Keys.LEFT, true);
    if (keyCode==RIGHT) keys.setKey(Keys.RIGHT, true);
  } else {
    if (key=='1' || key==triassicSelect) currentScene = new SinglePlayer(UIStory.TRIASSIC);
    if (key=='2' || key==jurassicSelect) currentScene = new SinglePlayer(UIStory.JURASSIC);
    if (key=='3' || key==cretaceousSelect) currentScene = new SinglePlayer(UIStory.CRETACEOUS);
    if (key==leftkey) keys.setKey(Keys.LEFT, true);
    if (key==rightkey) keys.setKey(Keys.RIGHT, true);
    if (key=='r') {
      rec = true;
      println("recording");
    }
  }
}

void touchStarted() {
  //println("touch started");
  
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
//  frameRate(5);
}

//void mouseReleased () {
//  frameRate(60);
//  //rec = true;
//}

void draw () {
  
  //if(touches.length==0) {
  //  keys.setKey(Keys.LEFT, false);
  //  keys.setKey(Keys.RIGHT, false);
  //} else {
  //  keys.setKey(touches[0].x < width/2 ? Keys.LEFT : Keys.RIGHT, true);
  //}

  if (!paused) {
    background(0,0,0,1);
    //fill(0,0,0,.3);
    //rect(0,0,width,height);
    if (currentScene.status==Scene.DONE) {
      println("oh shit");
    }
    currentScene.update();
    currentScene.render();
  }
  //filter(glow);

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
