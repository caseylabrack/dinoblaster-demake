import processing.sound.*;

boolean paused = false;
Scene currentScene;
PShader glow;

// recording
int fcount = 0;
boolean rec = false;

Keys keys = new Keys();
AssetManager assets = new AssetManager();

void setup () {
  //size(1024, 768, P2D);
  size(1024, 768, P2D);
  //fullScreen(P2D);
  surface.setTitle("DinoBlaster DX");

  colorMode(HSB, 360, 100, 100, 1);
  imageMode(CENTER);

  noCursor();

  assets.load();
  glow = loadShader("glow.glsl");
  currentScene = new SinglePlayer(10);
  //currentScene = new testScene();
}

void keyPressed() {

  //println(key, keyCode);
  //println(key==CODED);

  switch (keyCode) {   

  case 49:
  case 16:
    currentScene = new SinglePlayer(10);
    break;

  case 50:
    currentScene = new testScene();
    break;

  case 82:
    rec = true;
    println("recording");
    break;

  case 32:
    paused = !paused;
    break;

  case LEFT:
    keys.setKey(Keys.LEFT, true);
    break;

  case RIGHT:
    keys.setKey(Keys.RIGHT, true);
    break;

  default:
    break;
  }
}

void keyReleased() {

  switch (keyCode) {   

  case LEFT:
    keys.setKey(Keys.LEFT, false);
    break;

  case RIGHT:
    keys.setKey(Keys.RIGHT, false);
    break;

  case 82:
    rec = false;
    println("recording stopped");
    break;

  default:
    break;
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
    currentScene.update();
    currentScene.render();
  }

  if (rec) {
    if (frameCount % 8 == 0) {
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
