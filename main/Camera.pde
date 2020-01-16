class Camera extends Entity implements updateable {
  
  Camera () {

    //setPosition(earth.getPosition());
    //earth.addChild(this);
  }

  void update () {
    x += dx;
    y += dy;
    r += dr;

    dx = 0;
    dy = 0;
  }
}

//static class ColorDecider implements updateable {
//  int currentHue = 0;
//  color[] hues = new color[]{#ff3800,#ffff00,#00ff00,#00ffff,#ff57ff};
  
//  ColorDecider () { }
  
//  private static ColorDecider single_instance = null; 
  
//    // variable of type String 
//    public String s; 
    
//    // static method to create instance of Singleton class 
//    public static ColorDecider getInstance() 
//    { 
//        if (single_instance == null) 
//            single_instance = new ColorDecider(); 
  
//        return single_instance; 
//    } 

//  void update () {
//    currentHue = hues[utils.cycleRangeWithDelay(hues.length, 10, frameCount)];
//  }

//  color getColor () {
//    return currentHue;
//  }
//}

//static class MySingleton {
//  static final int ROUNDY = 7;
 
//  private static MySingleton inst;
//  private static PApplet p;
 
//  private MySingleton() {
//  } 
 
//  static MySingleton getInstance(PApplet papp) { 
//    if (inst == null) {
//      inst = new MySingleton();
//      p = papp;
//    }
//    return inst;
//  }
 
//  void layout() {
//    method1();
//  }
 
//  void method1() {
//    final int w = p.width, h = p.height;
 
//    p.fill(0x80);
//    p.rect(0, 0, 100, h, ROUNDY);
//    p.rect(w - 100, 0, w - 100, h, ROUNDY);
//    p.rect(100, h - 100, w - 200, 100, ROUNDY);
 
//    p.fill(0);
//    p.rect(100, 0, w - 200, h - 100, ROUNDY);
//  }
//}
