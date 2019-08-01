class StarManager implements updateable, renderable {

  int numStars = 1;
  PVector[] stars = new PVector[numStars];
  //float [] xs = new float[numStars];
  //float [] ys = new float[numStars];
  PVector direction;
  float angle = 0;
  PVector sun;
  float AU;
  float angleStep = PI/4000;
   float minAngle;

  StarManager () {

    AU = 1000;
    angle = 0;
    sun = new PVector(width/2-cos(angle)*AU, height/2-sin(angle)*AU);
    
    direction = new PVector(sun.x + cos(angle) * AU, sun.y + sin(angle) * AU);
    //minAngle = atan2(

      
      PVector topLeft = getTopLeft(angle);

    for (int i = 0; i < numStars; i++) {
    //  float cx = sun.x + cos(angle)*AU;
    //  float cy = sun.y = sin(angle)*AU;
      //stars[i] = new PVector(random(topLeft.x, width), random(topLeft.y, height));
      stars[i] = new PVector(random(topLeft.x, width), 0, angle);
    }
    
    for(PVector star : stars) {
      //println(degrees(atan2(star.y - sun.y, star.x - sun.x)));
    }
  }
  
  PVector getTopLeft (float angle) {
         float cx = sun.x + cos(angle)*AU;
     float cy = sun.y + sin(angle)*AU;
     return new PVector(cx-width/2, cy - height/2);
  }

  void update () {

      PVector oldAngle = new PVector(sun.x + cos(angle - angleStep) * AU, sun.y + sin(angle - angleStep) * AU);
        PVector newAngle = new PVector(sun.x + cos(angle) * AU, sun.y + sin(angle) * AU);
    PVector diff = newAngle.sub(oldAngle);
    
    for (PVector star : stars) {
      //star = star.add(direction);
            star = star.add(diff);
      
    }

    angle += angleStep;
    
    //println(degrees(atan2(stars[0].y - sun.y, stars[0].x - sun.x)));

    //direction.set(suncos(angle), sin(angle));
  }

  void render () {

    for (int i = 0; i < numStars; i++) {
      
      //if(abs(degrees(atan2(stars[i].y - sun.y, stars[i].x - sun.x))) > 13) {
      
      //  println("star left screen?");
      //}

    //println(angle - stars[i].z);

      if(angle - stars[i].z > 1) {
        println("respawn");
        PVector topLeft = getTopLeft(angle);
        //stars[i] = new PVector(random(topLeft.x, topLeft.x + width), random(topLeft.y, topLeft.y + height), angle);
        float cx = sun.x + cos(angle + angleStep * 10) * AU;
        float cy = sun.y + sin(angle + angleStep * 10) * AU;
        stars[i] = new PVector(random(cx - width/2, cx + width/2), random(cy - height/2, cy + height/2), angle);
        
      }
      //println(stars[i]);

      //if (dist(width, height, stars[i].x, stars[i].y) > 1000) {
        //PVector destinationFrame = new PVector(width, height);
        //PVector shift = new PVector.mult(direction
        //stars[i] = stars[i].add(PVector.mult(direction, -100));
      //} else {
        circle(stars[i].x, stars[i].y, 3);
      //}
    }
  }
}
