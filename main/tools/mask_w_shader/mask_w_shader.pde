/**
 * Image Mask
 * 
 * Move the mouse to reveal the image through the dynamic mask.
 */

PShader maskShader;
//PImage srcImage;
PGraphics srcImage;
PGraphics img2;
PGraphics maskImage;

void setup() {
  size(600, 600, P2D);
  colorMode(HSB, 360, 100, 100, 1);
  background(0, 0, 100, 1);
  imageMode(CENTER);
  noStroke();
  fill(290, 60, 70, .1);

  srcImage = createGraphics(300, 300);
  srcImage.beginDraw();
  srcImage.noStroke();
  srcImage.colorMode(HSB, 360, 100, 100, 1);
  srcImage.fill(60, 60, 60, 1);
  srcImage.circle(150, 150, 100);
  //srcImage.rect(0, 0, 300, 300);
  srcImage.endDraw();

  //img2 = createGraphics(300, 300);
  //img2.beginDraw();
  //img2.noStroke();
  //img2.colorMode(HSB, 360, 100, 100, 1);
  //img2.fill(80, 60, 90, 1);
  //img2.rect(0, 0, 200, 200);
  //img2.endDraw();

  maskImage = createGraphics(srcImage.width, srcImage.height, P2D);
  maskImage.noSmooth();
  maskImage.beginDraw();
  maskImage.colorMode(HSB, 360, 100, 100, 1);
  //maskImage.noStroke();
  maskImage.strokeWeight(3);
  maskImage.fill(0, 0, 0, 1);
  maskImage.arc(150, 150, 100, 100, radians(0), radians(0 + 45), CHORD);
  //maskImage.translate(50, 50);
  //maskImage.rotate(PI/8);
  //maskImage.rect(0, 0, 100, 100);
  maskImage.endDraw();

  maskShader = loadShader("mask.glsl");
  maskShader.set("mask", maskImage);
}

void draw() { 

  background(0, 0, 100, 1);

  shader(maskShader);    
  translate(width/2, height/2);
  rotate(radians(frameCount));
  image(srcImage, 0, 0);
  ////image(img2, width/2 - mouseX, 0);
  resetShader();

  //image(srcImage, 100, 100);

  if(mousePressed) image(maskImage, 0, 0);

  //image(maskImage, 0, 0);

  //circle(0, 0, 500);
}
