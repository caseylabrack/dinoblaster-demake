Earth earth;
Player player;
Roid testRoid;
Roid[] roids = new Roid[100];

void setup () {
  //fullScreen();
  size(640, 480, P2D);
  colorMode(HSB, 360, 100, 100);
  earth = new Earth(width/2, height/2);
  player = new Player(width/2, 105);
  earth.addChild(player);
  for(int r = 0; r < roids.length; r++) roids[r] = new Roid();
  //testRoid = new Roid(100, 200);
}

void draw () {

  background(0);

  earth.update();
  earth.render();
  player.update();
  player.render();
  for (Roid r : roids) {
    r.update();
  }
  for (Roid r : roids) {
    r.render();
  }
  //testRoid.update();
  //testRoid.render();
  if(frameCount % 200 == 0) { println(frameRate); }

  //saveFrame("output/dino-####.png");
  //if(frameCount==180) exit();
}
