// Daniel Shiffman
// http://youtube.com/thecodingtrain
// http://codingtra.in

// Coding Challenge #113: 4D Hypercube
// https://youtu.be/XE3YDVdQSPo

// Matrix Multiplication
// https://youtu.be/tzsgS19RRc8

class Hypercube implements updateable, renderable {

  float angle = 0;
  float angle2 = PI/4;
  ColorDecider colors;

  P4Vector[] points = new P4Vector[16];

  Hypercube(ColorDecider c) {
    
    colors = c;
    
    points[0] = new P4Vector(-1, -1, -1, 1);
    points[1] = new P4Vector(1, -1, -1, 1);
    points[2] = new P4Vector(1, 1, -1, 1);
    points[3] = new P4Vector(-1, 1, -1, 1);
    points[4] = new P4Vector(-1, -1, 1, 1);
    points[5] = new P4Vector(1, -1, 1, 1);
    points[6] = new P4Vector(1, 1, 1, 1);
    points[7] = new P4Vector(-1, 1, 1, 1);
    points[8] = new P4Vector(-1, -1, -1, -1);
    points[9] = new P4Vector(1, -1, -1, -1);
    points[10] = new P4Vector(1, 1, -1, -1);
    points[11] = new P4Vector(-1, 1, -1, -1);
    points[12] = new P4Vector(-1, -1, 1, -1);
    points[13] = new P4Vector(1, -1, 1, -1);
    points[14] = new P4Vector(1, 1, 1, -1);
    points[15] = new P4Vector(-1, 1, 1, -1);
  }

  void update () {
    pushMatrix();
    pushStyle();
    stroke(colors.getColor());
    //translate(width/2, height/2, 100);
    rotateX(-PI/2);
    PVector[] projected3d = new PVector[16];

    for (int i = 0; i < points.length; i++) {
      P4Vector v = points[i];

      float[][] rotationXY = {
        {cos(angle), -sin(angle), 0, 0}, 
        {sin(angle), cos(angle), 0, 0}, 
        {0, 0, 1, 0}, 
        {0, 0, 0, 1}
      };

      //float[][] rotationYZ = {
      //  {1, 0, 0, 0},
      //  {0, cos(angle), -sin(angle), 0},
      //  {0, sin(angle), cos(angle), 0},
      //  {0, 0, 0, 1}
      //};

      float[][] rotationYZ = {
        {1, 0, 0, 0}, 
        {0, cos(angle2), -sin(angle2), 0}, 
        {0, sin(angle2), cos(angle2), 0}, 
        {0, 0, 0, 1}
      };

      float[][] rotationZW = {
        {1, 0, 0, 0}, 
        {0, 1, 0, 0}, 
        {0, 0, cos(angle), -sin(angle)}, 
        {0, 0, sin(angle), cos(angle)}
      };


      P4Vector rotated = matmul4D(rotationYZ, v, true);
      rotated = matmul4D(rotationXY, rotated, true);
      rotated = matmul4D(rotationZW, rotated, true);

      float distance = 4;
      float w = 1 / (distance - rotated.w);

      float[][] projection = {
        {w, 0, 0, 0}, 
        {0, w, 0, 0}, 
        {0, 0, w, 0}
      };

      PVector projected = matmul4D(projection, rotated);
      projected.mult(width/8);
      projected3d[i] = projected;
    }

    // Connecting
    for (int i = 0; i < 4; i++) {
      connect(0, i, (i+1) % 4, projected3d );
      connect(0, i+4, ((i+1) % 4)+4, projected3d);
      connect(0, i, i+4, projected3d);
    }

    for (int i = 0; i < 4; i++) {
      connect(8, i, (i+1) % 4, projected3d );
      connect(8, i+4, ((i+1) % 4)+4, projected3d);
      connect(8, i, i+4, projected3d);
    }

    for (int i = 0; i < 8; i++) {
      connect(0, i, i + 8, projected3d);
    }

    //angle = map(mouseX, 0, width, 0, TWO_PI);
    angle += 0.02;
    //angle2 += 0.02;
    popStyle();
    popMatrix();
  }

  void connect(int offset, int i, int j, PVector[] points) {
    PVector a = points[i+offset];
    PVector b = points[j+offset];
    strokeWeight(1);
    line(a.x, a.y, a.z, b.x, b.y, b.z);
  }
  
  void render () {
  
  }
}


class P4Vector {
  float  x, y, z, w;

  P4Vector(float x, float y, float z, float w) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
  }
}

float[][] vecToMatrix4D(P4Vector v) {
  float[][] m = new float[4][1];
  m[0][0] = v.x;
  m[1][0] = v.y;
  m[2][0] = v.z;
  m[3][0] = v.w;
  return m;
}

PVector matrixToVec4D(float[][] m) {
  PVector v = new PVector();
  v.x = m[0][0];
  v.y = m[1][0];
  v.z = m[2][0];
  return v;
}

P4Vector matrixToVec4D4(float[][] m) {
  P4Vector v = new P4Vector(0, 0, 0, 0);
  v.x = m[0][0];
  v.y = m[1][0];
  v.z = m[2][0];
  v.w = m[3][0];
  return v;
}

PVector matmul4D(float[][] a, P4Vector b) {
  float[][] m = vecToMatrix4D(b);
  return matrixToVec4D(matmul4D(a, m));
}

P4Vector matmul4D(float[][] a, P4Vector b, boolean fourth) {
  float[][] m = vecToMatrix4D(b);
  return matrixToVec4D4(matmul4D(a, m));
}

float[][] matmul4D(float[][] a, float[][] b) {
  int colsA = a[0].length;
  int rowsA = a.length;
  int colsB = b[0].length;
  int rowsB = b.length;

  if (colsA != rowsB) {
    println("Columns of A must match rows of B");
    return null;
  }

  float result[][] = new float[rowsA][colsB];

  for (int i = 0; i < rowsA; i++) {
    for (int j = 0; j < colsB; j++) {
      float sum = 0;
      for (int k = 0; k < colsA; k++) {
        sum += a[i][k] * b[k][j];
      }
      result[i][j] = sum;
    }
  }
  return result;
}
