import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main extends PApplet {



Earth earth;
Player player;
SplosionManager splodesManager;
EventManager eventManager;
StarManager starManager;
SoundManager soundManager;
Camera camera;
UIStuff ui;
ColorDecider currentColor;
Trex trex;
ArrayList<updateable> updaters;
ArrayList<renderable> renderers;

public void setup () {
  //fullScreen(P2D);
  
  colorMode(HSB, 360, 100, 100);
  noCursor();
  init();
}

public void init () {
  updaters = new ArrayList<updateable>();
  renderers = new ArrayList<renderable>();
  eventManager = new EventManager();
  soundManager = new SoundManager(this);
  earth = new Earth(width/2, height/2);
  player = new Player(2);
  RoidManager roids = new RoidManager(70, 400, 100);
  splodesManager = new SplosionManager();
  StarManager starManager = new StarManager();
  camera = new Camera();
  //earthOrbit = new Orbiter(100, 100, 0, 0, TWO_PI/360);
  ui = new UIStuff();
  currentColor = new ColorDecider();
  trex = new Trex();
  earth.addChild(trex);
  updaters.add(ui);
  updaters.add(earth);
  updaters.add(roids);
  updaters.add(camera);
  updaters.add(player);
  updaters.add(splodesManager);
  updaters.add(currentColor);
  updaters.add(trex);
  updaters.add(starManager);
  renderers.add(ui);
  renderers.add(player);
  renderers.add(earth);
  renderers.add(starManager);
  renderers.add(splodesManager);
  renderers.add(trex);  
}

public void keyPressed() {
  if (key=='1') {
    init();
  } else {
    player.setMove(keyCode, true);
  }
}

public void keyReleased() {
  player.setMove(keyCode, false);
}

public void draw () {

  background(0);
  for (updateable u : updaters) u.update();
  for (renderable r : renderers) r.render();

  //if(frameCount % 200 == 0) { println(frameRate); }
  //saveFrame("spoofs-and-goofs/frames2/dino-####.png");
  //if(frameCount==300) exit();
}
class Camera extends Entity implements updateable {
  Camera () {

    setPosition(earth.getPosition());
    //earth.addChild(this);
  }

  public void update () {
    x += dx;
    y += dy;
    r += dr;

    dx = 0;
    dy = 0;
  }
}

class ColorDecider implements updateable {
  int currentHue = 0;
  int[] hues = new int[]{0xffff3800,0xffffff00,0xff00ff00,0xff00ffff,0xffff57ff};
  ColorDecider () { }

  public void update () {
    currentHue = hues[utils.cycleRangeWithDelay(hues.length, 10, frameCount)];
  }

  public int getColor () {
    return currentHue;
  }
}
class Entity {
  float x, y, r, dx, dy, dr;
  Entity parent;
  boolean delete = false;
  ArrayList<Entity> children = new ArrayList<Entity>();

  public void setParent (Entity p) {
    parent = p;
  }

  public void addChild (Entity obj) {
    children.add(obj);
  } 

  public void setPosition (PVector pos) {
    x = pos.x;
    y = pos.y;
  }
  
  public void updateChildren () {
  
    for(Entity c : children) {
    
        c.dx += dx;
        c.dy += dy;
        c.dr += dr;
        c.setPosition(utils.rotateAroundPoint(c.getPosition(), getPosition(), dr));
        c.updateChildren();    
    }
  }

  public PVector getPosition () {
    return new PVector(x, y);
  }
}
class EventManager {
  ArrayList<gameOverEvent> gameOverSubscribers = new ArrayList<gameOverEvent>();
  ArrayList<roidImpactEvent> roidImpactSubscribers = new ArrayList<roidImpactEvent>();
  
  EventManager () {
  
  }
  
  public void dispatchGameOver () {
    for(gameOverEvent g : gameOverSubscribers) g.gameOverHandle();
  }
  
  public void dispatchRoidImpact(PVector p) {
    for(roidImpactEvent r : roidImpactSubscribers) r.roidImpactHandle(p);
  }
} 

interface gameOverEvent {
  public void gameOverHandle();
}

interface roidImpactEvent {
  public void roidImpactHandle(PVector p);
}
class PlayerIntro extends Entity {
  PImage model;
  PlayerIntro (int whichPlayer) {
    PImage sheet = whichPlayer==1 ? loadImage("bronto-run.png") : loadImage("oviraptor-frames.png");
    PImage[] frames = whichPlayer==1 ? utils.sheetToSprites(sheet, 3, 1) : utils.sheetToSprites(sheet, 2, 2, 1);
    model = frames[0];
  }

  public void update () {
  }

  public void render () {
  }
}

class Player extends Entity implements gameOverEvent, updateable, renderable {
  PImage model;
  PImage[] runFrames = new PImage[2];
  PImage idle;
  float runSpeed = 5;
  int direction = 1;
  String state = "idle";
  Boolean leftKey = false;
  Boolean rightKey = false;
  Boolean visible = true;
  int playerNum = 1;
  int framesTotal = 8;
  float delay = 100;  

  Player (int whichPlayer) {
    PImage sheet = whichPlayer==1 ? loadImage("bronto-run.png") : loadImage("oviraptor-frames.png");
    PImage[] frames = whichPlayer==1 ? utils.sheetToSprites(sheet, 3, 1) : utils.sheetToSprites(sheet, 2, 2, 1);
    idle = frames[0];
    runFrames[0] = frames[1];
    runFrames[1] = frames[2];
    model = idle;
    eventManager.gameOverSubscribers.add(this);
    earth.addChild(this);
    x = earth.x + cos(radians(-90)) * earth.radius;
    y = earth.y + sin(radians(-90)) * earth.radius;
  }

  public void die () {
    eventManager.dispatchGameOver();
  }

  public void gameOverHandle () {
    visible = false;
  }

  public void setMove (int keyevent, boolean set) {
    switch(keyevent) {
    case LEFT: 
      leftKey = set;
      break;
    case RIGHT:
      rightKey = set;
      break;
    }
  } 

  public void update () {
    //if (frameCount==1) init();

    if (leftKey != rightKey) { // logical XOR
      model = runFrames[utils.cycleRangeWithDelay(runFrames.length, 4, frameCount)];
      if (leftKey) {
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), runSpeed * -1));
        dr -= runSpeed;
        direction = -1;
      } else {
        setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), runSpeed * 1));
        dr += runSpeed;
        direction = 1;
      }
    } else {
      model = idle;
    }

    x += dx;
    y += dy;
    r += dr;


    dx = 0;
    dy = 0;
    dr = 0;
  }

  public void render () {

    if (!visible) return;
    pushMatrix();
    scale(direction, 1);    
    translate((width/2 + x - camera.x) * direction, height/2 + y - camera.y);
    rotate(radians(r  * direction));
    imageMode(CENTER);
    pushStyle();
    tint(currentColor.getColor());
    image(model, 0, 0, model.width * .5f, model.height * .5f);
    popStyle();
    popMatrix();
  }
}
class SoundManager implements roidImpactEvent {
 
  SoundFile[] roid_impacts = new SoundFile[5];
  PApplet main;
  
  SoundManager (PApplet _p) {
    main = _p;
    
    eventManager.roidImpactSubscribers.add(this);
    
    for(int i = 1; i <= 5; i++) {
      roid_impacts[i-1] = new SoundFile(main, "impact"+i+".wav");
    }
  }
  
  public void roidImpactHandle(PVector p) {
    roid_impacts[PApplet.parseInt(random(roid_impacts.length-1))].play();
  }
}
class StarManager implements updateable, renderable {

  PVector[] stars = new PVector[800];
  float r = 2000;
  float a = 0;
  float x, y;

  PImage[] nebulaFrames;
  PImage nebulaModel;
  PVector nebulaVec;
  boolean nebulaActive = false;
  float nebulaLead = 15;
  float nebulaOffset = 0;

  StarManager () {

    int k = 0;
    for (int j = 0; j < 360; j+= 9) {
      for (int i = 0; i < 20; i++) {
        stars[k] = new PVector(cos(a+j) * r + random(-width/2, width/2), sin(a+j)*r + random(-height/2, height/2));
        k++;
      }
    }

    PImage sheet = loadImage("nebula.png");
    nebulaFrames = utils.sheetToSprites(sheet, 7, 5);
    spawnNeb();
  }

  public void spawnNeb () {
    nebulaActive = true;
    nebulaOffset = random(1)<.5f ? 200 : -200; 
    nebulaVec = new PVector(cos(a + radians(nebulaLead)) * (r + nebulaOffset), sin(a + radians(nebulaLead)) * (r + nebulaOffset));
  }

  public void update () {
    a += TWO_PI / (360 * 40);

    nebulaModel = nebulaFrames[utils.cycleRangeWithDelay(nebulaFrames.length, 8, frameCount)];
  }

  public void render () {
    for (PVector s : stars) {
      x = s.x - (cos(a) * r - width / 2);
      y = s.y - (sin(a) * r - height / 2);
      if (x>0 && x < width && y > 0 && y < height) {
        pushMatrix();
        translate(x, y);
        rotate(TWO_PI/8);
        square(0, 0, 2);
        popMatrix();
      }
    }

    if (nebulaActive) {
      x = nebulaVec.x - (cos(a) * r - width / 2);
      y = nebulaVec.y - (sin(a) * r - height / 2);

      if (x>-640 && x < width + 640 && y > -640 && y < height + 640) {
        pushStyle();
        pushMatrix();
        translate(x, y);
        tint(currentColor.getColor());
        image(nebulaModel, 0, 0);
        popMatrix();
        popStyle();
      }
    }
  }
}
class UIStuff implements gameOverEvent, updateable, renderable {
  PFont EXTINCT;
  PFont body;
  boolean isGameOver = false;
  float score = 0;
  int stage = 1;
  int lastScoreTick = 0;
  String currentStage = "Triassic";
  String nextStage = "Jurassic";

  UIStuff () {
    EXTINCT = loadFont("Hyperspace-92.vlw");
    body = loadFont("Hyperspace-Bold-18.vlw");
    textFont(body);

    eventManager.gameOverSubscribers.add(this);
  }

  public void gameOverHandle() {
    isGameOver = true;
  }

  public void update () {
    if(isGameOver) return;
    
    if (millis() - lastScoreTick > 1000) {
      score++;
      lastScoreTick = millis();
    }

    if (score==100) {
      stage++;
      currentStage = "Jurassic";
      nextStage = "Cretaceous";
    }
  }

  public void render () {

    pushStyle();
    textFont(body);
    textAlign(LEFT, TOP);
    text(currentStage, 5, 5);
    popStyle();

    stroke(0, 0, 100);
    strokeWeight(1);
    line(5, 25, score/100 * stage * width-5, 25);

    if (isGameOver) {
      pushStyle();
      textFont(EXTINCT);
      textAlign(CENTER, CENTER);
      fill(currentColor.getColor()); 
      text("EXTINCT", width/2, height/2);
      popStyle();
    }
  }
} 


class Orbiter extends Entity implements updateable {
  float cx, cy, radius, angle, angleStep;
  Orbiter (float _x, float _y, float _cx, float _cy, float _step) {
    x = _x;
    y = _y;
    cx = _cx;
    cy = _cy;
    angleStep = _step;
    angle = atan2(y - cy, x - cx);
    radius = dist(x, y, cx, cy);
  }

  public void update () {
    dx = cos(angle) * radius - x;
    dy = sin(angle) * radius - y;
    angle += angleStep;

    x += dx;
    y += dy;

    updateChildren();
    //for (Entity child : children) {
    //  child.dx += dx;
    //  child.dy += dy;
    //}

    //pushMatrix();
    //translate(width/2 + x - camera.x, height/2 + y - camera.y);
    //circle(width/2, height/2, 10);
    //popMatrix();
  }
}

class Earth extends Entity implements gameOverEvent, updateable, renderable {
  PImage model;
  float radius;

  float shakeAngle;
  boolean shake = false;
  float shakeMag;

  boolean shaking = false;
  float shakingDur;
  float shakingMag;
  float shakingStart;

  Earth (float xpos, float ypos) {
    x = xpos;
    y = ypos;
    dx = 0;
    dy = 0;
    dr = 2.3f;
    model = loadImage("earth.png");
    radius = (model.width/2) * .5f - 5;
    eventManager.gameOverSubscribers.add(this);
  }

  public void gameOverHandle () {
    //rx = 0;
  }

  public void shake (float _mag) {
    shakeMag += _mag;
    shake = true;
  }

  public void shakeContinous (float _dur, float _mag) {
    shakingDur += _dur;
    shakingMag = _mag;
    shakingStart = millis();
    shaking = true;
  }

  public void update() {

    dx = width/2 - x;
    dy = height/2 - y;

    if (shake) {
      shakeAngle = random(0, TWO_PI);
      dx += cos(shakeAngle) * shakeMag;
      dy += sin(shakeAngle) * shakeMag;
      shakeMag *= .9f;
      if (shakeMag < .1f) {
        shakeMag =0;
        shake = false;
      }
    } 

    if (shaking) {
      shakeAngle = random(0, TWO_PI);
      dx += cos(shakeAngle) * shakingMag;
      dy += sin(shakeAngle) * shakingMag;
      if (millis() - shakingStart > shakingDur) {
        shaking = false;
      }
    }

    x += dx;
    y += dy;
    r += dr;
    updateChildren();
  }

  public void render () {
    pushMatrix();
    translate(width/2 + x - camera.x, height/2 + y - camera.y);
    rotate(radians(r));
    imageMode(CENTER);
    image(model, 0, 0, model.width*.5f, model.height*.5f);
    popMatrix();
  }
}
class Explosion extends Entity {
  PImage model;
  float start;
  float duration = 300;
  boolean visible = false;
  PImage[] frames;

  Explosion (PImage[] _frames) {

    frames = _frames;
  }

  public void fire(float xpos, float ypos) {
    visible = true;
    x = xpos;
    y = ypos;
    start = millis();
    r = degrees(atan2(y - earth.y, x - earth.x)) + 90;
  }

  public void update () {

    if (!visible) return;

    if (millis() - start > duration) {
      visible = false;
    }
    int frameNum = floor(map((millis() - start) / duration, 0, 1, 0, frames.length)); // animation progress is proportional to duration progress
    model = frames[frameNum > 2 ? 2 : frameNum]; // mapping above is not clamped to frames.length, can create array out of index error 

    x += dx;
    y += dy;
    r += dr;

    dx = 0;
    dy = 0;
    dr = 0;
  }

  public void render () {
    if (!visible) return;
    pushMatrix();
    translate(width/2 + x - camera.x, height/2 + y - camera.y);
    rotate(radians(r));
    imageMode(CENTER);
    image(model, 0, 0, model.width*.5f, model.height*.5f);
    popMatrix();
  }
}
// non-event interfaces in one place

interface updateable {

  public void update();
}

interface renderable {
  public void render();
} 
class Roid extends Entity {
  PImage sheet;
  PImage[] roids;
  PImage model;
  float speed = 2.5f;
  boolean enabled = false;
  float radius;
  PImage trail;
  float angle;
  PVector trailPosition;

  Roid () {
    dr = .1f;
    sheet = loadImage("asteroids-ss.png");
    trail = loadImage("roid-trail.png");
    roids = utils.sheetToSprites(sheet, 2, 2);
    model = roids[floor(random(0, 4))];
    radius = sqrt(sq(width/2) + sq(height/2)) + model.width;
  }

  public void fire () {
    enabled = true;
    angle = random(0, 359);
    x = earth.x + cos(radians(angle)) * radius;
    y = earth.y + sin(radians(angle)) * radius;

    dx = cos(radians(angle+180)) * speed;
    dy = sin(radians(angle+180)) * speed;
  }

  public void update () {
 
    if (!enabled) return; 
    x += dx;
    y += dy;
    r += dr;

    if (dist(x, y, earth.x, earth.y) < earth.radius) {
      enabled = false;
      if (dist(x, y, player.x, player.y) < 26) {
        player.die();
      } 
      splodesManager.newSplode(x, y);
      eventManager.dispatchRoidImpact(new PVector(x,y));
    }
  }

  public void render() {
    if (!enabled) return;
    pushMatrix();
    imageMode(CENTER);
    translate(width/2 + x - camera.x, height/2 + y - camera.y);
    pushMatrix();
    rotate(radians(angle+90));
    image(trail, 0, -25, trail.width/2, trail.height/2);
    popMatrix();
    rotate(r);
    image(model, 0, 0, model.width/2, model.height/2);
    popMatrix();
  }
}
class RoidManager implements updateable {
  float wait;
  int min;
  int max;
  Roid[] roids;
  float lastFire;
  int index = 0;

  RoidManager (int _min, int _max, int poolsize) {
    min = _min;
    max = _max;
    roids = new Roid[poolsize];
    for (int i = 0; i < poolsize; i++) {
      roids[i] = new Roid();
    }
  }

  public void update () {
    if (millis() - lastFire > wait) {
      lastFire = millis();
      wait = random(min, max);
      roids[index % roids.length].fire();
      index++;
    };

    for (Roid r : roids) r.update();
    for (Roid r : roids) r.render();
  }
}
class ScoreManager {
  ScoreManager () {
  
  } 
}
class SplosionManager implements updateable, renderable {
  Explosion[] splodes = new Explosion[25];
  PImage sheet;
  PImage[] frames;
  int index = 0;

  SplosionManager () {

    sheet = loadImage("explosion-sheet.png");
    frames = utils.sheetToSprites(sheet, 3, 1);

    for (int i = 0; i < splodes.length; i++) {
      splodes[i] = new Explosion(frames);
      earth.addChild(splodes[i]);
    }
  }

  public void newSplode (float x, float y) {
    splodes[index % splodes.length].fire(x, y);
  }

  public void update () {
    for (Explosion s : splodes) s.update();
  }

  public void render () {
    for (Explosion s : splodes) s.render();
  }
}
class Trex extends Entity implements gameOverEvent, updateable, renderable {

  PImage model;
  PImage idle;
  PImage[] runFrames = new PImage[2];
  boolean visible = true;
  int direction = 1;
  float runSpeed = .75f;
  boolean chasing = true;
  float attackAngle = 110;

  Trex () {
    PImage sheet = loadImage("trex.png");
    PImage[] frames = utils.sheetToSprites(sheet, 3, 1);
    idle = frames[0];
    runFrames[0] = frames[1];
    runFrames[1] = frames[2];
    x = earth.x + cos(radians(-90)) * earth.radius;
    y = earth.y + sin(radians(-90)) * earth.radius;
    model = idle;
    direction = -1;
  }

  public void gameOverHandle () {
    chasing = false;
  }

  public void update () {

    float playerDist = utils.signedAngleDiff(r, player.r);
    
    if(abs(playerDist) < attackAngle) {
      chasing = true;
      direction = playerDist > 0 ? 1 : -1;
    } else {
      chasing = false;
    }
    
    if (chasing) {
      model = runFrames[utils.cycleRangeWithDelay(runFrames.length, 12, frameCount)];
      if (model==runFrames[1]) earth.shake(.5f);
      setPosition(utils.rotateAroundPoint(getPosition(), earth.getPosition(), runSpeed * direction));
      dr += runSpeed * direction;
    } else {
      model = idle;
    }

    //if(

    x += dx;
    y += dy;
    r += dr;

    dx = 0;
    dy = 0;
    dr = 0;
  }

  public void render () {

    if (!visible) return;
    pushMatrix();
    scale(direction, 1);    
    translate((width/2 + x - camera.x) * direction, height/2 + y - camera.y);
    rotate(radians(r  * direction));
    imageMode(CENTER);
    pushStyle();
    image(model, 0, 0, model.width * .5f, model.height * .5f);
    popStyle();
    popMatrix();
  }
}
static class utils {

  public static PVector rotateAroundPoint (PVector obj, PVector center, float degrees) {
    float angle = degrees(atan2(center.y - obj.y, center.x - obj.x));
    float dist = dist(center.x, center.y, obj.x, obj.y);
    angle += degrees;
    return new PVector(center.x - cos(radians(angle)) * dist, center.y - sin(radians(angle)) * dist);
  }

  public static PImage[] sheetToSprites (PImage sheet, int rows, int cols, int blanks) {
    PImage[] sprites = new PImage[rows*cols-blanks];
    int cellX = sheet.width / rows;
    int cellY = sheet.height / cols;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (r * cols + c < rows*cols-blanks) sprites[r * cols + c] = sheet.get(r * cellX, c * cellY, cellX, cellY);
      }
    }
    return sprites;
  }

  public static PImage[] sheetToSprites (PImage sheet, int rows, int cols) {
    return sheetToSprites(sheet, rows, cols, 0);
    //PImage[] sprites = new PImage[rows*cols];
    //int cellX = sheet.width / rows;
    //int cellY = sheet.height / cols;
    //for (int r = 0; r < rows; r++) {
    //  for (int c = 0; c < cols; c++) {
    //    sprites[r * cols + c] = sheet.get(r * cellX, c * cellY, cellX, cellY);
    //  }
    //}
    //return sprites;
  }

  public static int cycleRangeWithDelay (int framesTotal, int delay, int seed) {
    return floor((seed % floor(framesTotal * delay))/delay);
  }
  
  public static float signedAngleDiff (float r1, float r2) {
     float diff = (r2 - r1 + 180) % 360 - 180;
     return diff < -180 ? diff + 360: diff;
  }
} 
  public void settings() {  size(640, 480, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
