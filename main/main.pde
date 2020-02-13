import processing.sound.*;

boolean testactive = true;
GameMode game;
long prev;
PShader glow;

void setup () {
  size(1024, 768, P2D);
    //size(400, 400, P2D);
  //fullScreen(P2D);

  colorMode(HSB, 360, 100, 100);
  noCursor();
  
  glow = loadShader("glow.glsl");
  //game = new OviraptorMode(this);
  game = new StoryMode(this);
  prev = frameRateLastNanos;
  game.update();
}

void keyPressed() {

  switch (key) {   
  case '1':
    game = new StoryMode(this);
    break;

  case '2':
    game = new OviraptorMode(this);
    break;

  case ' ':
    testactive = !testactive;
    break;

  default:
    game.input(keyCode, true);
    break;
  }
}

void keyReleased() {
  game.input(keyCode, false);
}

void draw () {

  if(testactive) {
    background(0);
    game.update();
  }

  //if(frameCount % 60==0) println((frameRateLastNanos - prev)/1e6/16.666);
  prev = frameRateLastNanos;
  filter(glow);

  //if(frameCount % 200 == 0) { println(frameRate); }
  //if(frameCount % 4 == 0) saveFrame("spoofs-and-goofs/frames/dino-####.png");
  //if(frameCount==240) exit();
}
