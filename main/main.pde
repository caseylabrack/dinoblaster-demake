Earth earth;
Player player;
RoidManager roids;
ArrayList<Explosion> splodes = new ArrayList<Explosion>();

void setup () {
  //fullScreen();
  size(640, 480, P2D);
  colorMode(HSB, 360, 100, 100);
  earth = new Earth(width/2, height/2);
  player = new Player(width/2, 105);
  earth.addChild(player);
  roids = new RoidManager(3000, 100);
}

void draw () {

  background(0);
  roids.update();
  earth.update();
  earth.render();
  player.update();
  player.render();
  for(Explosion s : splodes) s.update();
  for(Explosion s : splodes) s.render();
  //if(frameCount % 200 == 0) { println(frameRate); }
  saveFrame("spoofs and goofs/frames/dino-####.png");
  if(frameCount==400) exit();
}
