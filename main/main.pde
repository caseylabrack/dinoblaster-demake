import processing.sound.*;

boolean paused = false;
GameMode game;
long prev;
PShader glow;

// recording
int fcount = 0;
boolean rec = false;

Keys keys = new Keys();
AssetManager assets = new AssetManager();

void setup () {
  size(1024, 768, P2D);
  //fullScreen(P2D);

  colorMode(HSB, 360, 100, 100);
  //noCursor();

  assets.load();

  glow = loadShader("glow2.glsl");
  //game = new OviraptorMode(this);
  game = new StoryMode(this);
  prev = frameRateLastNanos;
}

void keyPressed() {

  switch (keyCode) {   
    case 49:
      game = new StoryMode(this);
      break;

    //case '2':
    //  game = new OviraptorMode(this);
    //  break;

    case 32:
      paused = !paused;
      break;

    //case '3':
    //  if (frameRate < 30) {
    //    frameRate(60);
    //  } else {
    //    frameRate(10);
    //  }
    //  break;

  case 37:
    //keys.left = true;
    keys.setKey(Keys.LEFT, true);
    break;

  case 39:
  keys.setKey(Keys.RIGHT, true);
    //keys.right = true;
    break;

  default:
    break;
  }
}

void keyReleased() {
  
  switch (keyCode) {   

  case 37:
    //keys.left = false;
    keys.setKey(Keys.LEFT, false);
    break;

  case 39:
    //keys.right = false;
    keys.setKey(Keys.RIGHT, false);
    break;

  default:
    break;
  }
}

//void mousePressed () {
//  frameRate(5);
//}

//void mouseReleased () {
//  frameRate(60);
//  //rec = true;
//}

void draw () {

  //tint(0,0,50);
  if (!paused) {
    background(0);
    game.update();
  }

  //if(frameCount % 60==0) println((frameRateLastNanos - prev)/1e6/16.666);
  prev = frameRateLastNanos;
  //if(mousePressed) 
  //filter(glow);

  if (rec) {
    if (frameCount % 4 == 0) {
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
