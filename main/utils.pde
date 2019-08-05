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

  static int cycleRangeWithDelay (int framesTotal, int delay, int seed) {
    return floor((seed % floor(framesTotal * delay))/delay);
  }
  
  static float signedAngleDiff (float r1, float r2) {
     float diff = (r2 - r1 + 180) % 360 - 180;
     return diff < -180 ? diff + 360: diff;
  }
} 
