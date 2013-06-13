public class Firelayer {
  int counter = 0;
  float maxSpeed = 10;
  ArrayList balls;
  color ballColor;
  float ballSize = 1;
  float gravity = 0;
  TimeFunction tf = null;
  
  public Firelayer() {
    balls = new ArrayList();
    this.counter = 0;
  }

  public void setMaxSpeed(float maxSpeed) {
    this.maxSpeed = maxSpeed;
    
  }

  public void setColor(color ballColor){
    this.ballColor = ballColor;
  }
  
  public void setSize(float ballSize){
    this.ballSize = ballSize;
  }
  
  public void setTimeFunction(TimeFunction tf){
    this.tf = tf;
  }
  
  public void setGravity(float gravity){
    this.gravity = gravity;
  }

  public void setGround(float ground) {
    if (balls.size() > 0) {
      for (int i = balls.size()-1; i >= 0; i--) {
        ((FallingFireball)balls.get(i)).setGround(ground);
      }
    }
  }
  
  public int getNumOfBalls() {
    return this.balls.size();
  }
  
  public float getTimeFunc(){
    return this.tf.function(this.counter);
  }

  public void generateSphere(int num, float x, float y) {
    generateSphere(num, x, y, this.ballSize, this.ballColor, this.maxSpeed);
  }

  public void generateSphere(int num, float x, float y, float ballSize, color ballColor, float maxSpeed) {
    for (int i = 0; i < num; i++) {
      balls.add(genereteBall(x, y, ballSize, ballColor, maxSpeed));
    }
  }

  public FallingFireball genereteBall(float x, float y, float ballSize, color ballColor, float maxSpeed) {
    float rx = random(360), ry = random(360), rz = random(360);
    Point3Df p3d = new Point3Df(maxSpeed);
    p3d.rotateX(radians(random(360)));
    p3d.rotateY(radians(random(360)));
    p3d.rotateZ(radians(random(360)));

    FallingFireball ffb = new FallingFireball(x, y, ballSize, p3d.x, p3d.y, p3d.z, 0, this.gravity, 0);
    //    FallingFireball ffb = new FallingFireball(x, y, ballSize, p3d.x, p3d.y, p3d.z, 0, 0.02, 0);
    ffb.setColor(ballColor);

    return ffb;
  }

  public void drawAndReflesh() {
    if (balls.size() > 0) {
      FallingFireball ffb;
      color fbc;
      for (int i = balls.size()-1; i >= 0; i--) {
        ffb = (FallingFireball)balls.get(i);
        float alpha = 255*this.tf.function(this.counter);
        if(this.tf != null){
//          println(this.tf.function(this.counter));
          fbc = ffb.getFireball().getColor();
          ffb.setColor(color(hue(fbc), saturation(fbc), brightness(fbc), alpha));
        }
        if(alpha == 0){
          balls.remove(i);
        }
        else{
          ffb.drawAndReflesh();
          if (ffb.isOutOfScreen()) balls.remove(i);
        }
      }
    }
    this.counter++;
  }
}

public class Point3Df {
  float x = 0;
  float y = 0;
  float z = 0;

  public Point3Df(float intVal) {
    _Point3Df(intVal, intVal, intVal);
  }

  public Point3Df(float x, float y, float z) {
    _Point3Df(x, y, z);
  }  
  private void _Point3Df(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public float getX(){ return this.x; }
  public float getY(){ return this.y; }
  public float getZ(){ return this.z; } 

  public void rotateX(float rad) {
    float py = this.y;
    float pz = this.z;
    this.y = py * cos(rad) - pz * sin(rad);
    this.z = py * sin(rad) + pz * cos(rad);
  }

  public void rotateY(float rad) {
    float px = this.x;
    float pz = this.z;
    this.x = px * cos(rad) + pz * sin(rad);
    this.z = -px * sin(rad) + pz * cos(rad);
  }

  public void rotateZ(float rad) {
    float px = this.x;
    float py = this.y;
    this.x = px * cos(rad) - py * sin(rad);
    this.y = px * sin(rad) + py * cos(rad);
  }
}

