class StarManager {

  float [] as;
  float [] rs;
  float AU = 100000;
  PVector sun;
  float minAngle;
  float maxAngle;

  StarManager () {

    sun = new PVector(width/2, height/2 + AU);
    
    minAngle = atan2(height - sun.y, 0 - sun.x);
    maxAngle = atan2(height - sun.y, width - sun.x);
    //println(degrees(minAngle), degrees(maxAngle));
  }
}
