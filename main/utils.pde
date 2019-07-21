static class utils {

  static PVector rotateAroundPoint (PVector obj, PVector center, float degrees) {
    float angle = degrees(atan2(center.y - obj.y, center.x - obj.x));
    float dist = dist(center.x, center.y, obj.x, obj.y);
    angle += degrees;
    return new PVector(center.x - cos(radians(angle)) * dist, center.y - sin(radians(angle)) * dist);
  }
} 
