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
  size(1024, 768, P2D);
  //fullScreen(P2D);
  surface.setTitle("DinoBlaster DX");

  colorMode(HSB, 360, 100, 100, 1);
  imageMode(CENTER);

  //noCursor();

  assets.load();
  glow = loadShader("glow2.glsl");
  currentScene = new SinglePlayer();
  //currentScene = new testScene();
}

void keyPressed() {

  //println(key, keyCode);
  //println(key==CODED);

  switch (keyCode) {   

  case 49:
    currentScene = new SinglePlayer();
    break;

  case 50:
    currentScene = new testScene();
    break;

  case 82:
    rec = true;
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
    if (frameCount % 1 == 0) {
      saveFrame("spoofs-and-goofs/frames/dino-" + nf(fcount, 4) + ".png");
      fcount++;
    }
    if (fcount==360) exit();
  }

  //if(frameCount % 200 == 0) { println(frameRate); }
  //if(frameCount % 4 == 0) saveFrame("spoofs-and-goofs/frames/dino-####.png");
  //if(frameCount==360) exit();
}

class Keys {

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
