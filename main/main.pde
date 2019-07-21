Earth earth;
Player player;

void setup () {
  //fullScreen();
  size(640,480);
  colorMode(HSB, 360, 100, 100);
  earth = new Earth(width/2,height/2);
  player = new Player(width/2, 105);
  earth.addChild(player);
}

void draw () {
  
  background(0);
  
  earth.update();
  earth.render();
  player.update();
  player.render();
  
  //saveFrame("output/dino-####.png");
  //if(frameCount==180) exit();
}
