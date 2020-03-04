static class utils {

  static PVector rotateAroundPoint (PVector obj, PVector center, float degrees) {
    float angle = degrees(atan2(center.y - obj.y, center.x - obj.x));
    float dist = dist(center.x, center.y, obj.x, obj.y);
    angle += degrees;
    return new PVector(center.x - cos(radians(angle)) * dist, center.y - sin(radians(angle)) * dist);
  }

  static PImage[] sheetToSprites (PImage sheet, int rows, int cols, int blanks) {
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

  static PImage[] sheetToSprites (PImage sheet, int rows, int cols) {
    return sheetToSprites(sheet, rows, cols, 0);
  }

  static int cycleRangeWithDelay (int framesTotal, int delay, int seed) {
    return floor((seed % floor(framesTotal * delay))/delay);
  }

  public static float unsignedAngleDiff(float alpha, float beta) {
    float phi = Math.abs(beta - alpha) % 360;       
    float distance = phi > 180 ? 360 - phi : phi;
    return distance;
  }

  static float signedAngleDiff (float r1, float r2) {
    float diff = (r2 - r1 + 180) % 360 - 180;
    return diff < -180 ? diff + 360: diff;
  }

  static boolean rectOverlap (PVector l1, PVector r1, PVector l2, PVector r2) {
    if(r1.x < l2.x || r2.x < l1.x) {
      return false;
    }
    
    if(r2.y < l1.y || r1.y < l2.y) {
      return false;
    }
    
    return true;
  }

  static float easeLinear (float t, float b, float c, float d) { 
    return b + c * (t/d);
  }

  static float easeInOutQuad (float t, float b, float c, float d) {
    if ((t/=d/2) < 1) return c/2*t*t + b;
    return -c/2 * ((--t)*(t-2) - 1) + b;
  }

  static float easeInOutQuart (float t, float b, float c, float d) {
    if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
    return -c/2 * ((t-=2)*t*t*t - 2) + b;
  }

  static float easeInOutExpo (float t, float b, float c, float d) {
    if (t==0) return b;
    if (t==d) return b+c;
    if ((t/=d/2) < 1) return (float)(c/2 * Math.pow(2, 10 * (t - 1)) + b);
    return (float)(c/2 * (-Math.pow(2, -10 * --t) + 2) + b);
  }

  static float easeInExpo (float t, float b, float c, float d) {
    return (float)((t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b);
  }
  
  static float easeOutExpo (float t, float b, float c, float d) {
    return (t==d) ? b+c : (float)(c * (-Math.pow(2, -10 * t/d) + 1) + b);
  }
  
  static float easeOutQuad (float t, float b, float c, float d) {
    return -c *(t/=d)*(t-2) + b;
  }
  
  static float easeInQuad (float t, float b, float c, float d) {
    return c*(t/=d)*t + b;
  }
} 
