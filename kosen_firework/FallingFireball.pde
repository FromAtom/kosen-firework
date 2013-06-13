import java.awt.geom.*;

public class FallingFireball{
  float vX = 0;
  float vY = 0;
  float vZ = 0;
  float aX = 0;
  float aY = 0;
  float aZ = 0;
  int logLen = 0;
  Fireball myBall;
  ArrayList pointsLogs;
  float ground = height*0.95;
  float against = 0.01;
  
  public FallingFireball(float x, float y, float ballSize, float vX, float vY, float vZ, float aX, float aY, float aZ){
    myBall = new Fireball(x, y, ballSize);
    this.vX = vX;
    this.vY = vY;
    this.vZ = vZ;
    this.aX = aX;
    this.aY = aY;
    this.aZ = aZ;
    pointsLogs = new ArrayList();
  }
  
  public boolean isOutOfScreen(){
    if(this.myBall.x > width || this.myBall.y > ground)
      return true;
    else
      return false;
  }
  public float getVY(){
    return this.vY;
  }
  public Fireball getFireball(){
    return this.myBall;
  }
  
  public void setColor(color starColor){
    this.myBall.setColor(starColor);
  }
  public void setGround(float ground){
    this.ground = ground;
  }
  public void setAgainst(float against){
    this.against = against;
  }
  public void setLogLen(int logLen){
    this.logLen = logLen;
  }
  
  void drawAndReflesh(){
    myBall.drawBall();
    fill(myBall.ballColor);
    stroke(myBall.ballColor);
    for(int i = pointsLogs.size()-1; i >= 0; i--){
      Point2D.Float cPnt = (Point2D.Float)pointsLogs.get(i);
//      Point2D.Float nPnt = (Point2D.Float)pointsLogs.get(i+1);
//      line(cPnt.x, cPnt.y, nPnt.x, nPnt.y);
      myBall.drawBallShade(cPnt.x, cPnt.y, pow(0.7, pointsLogs.size()-i));
    }
    pointsLogs.add(new Point2D.Float(myBall.getX(), myBall.getY()));
    if(pointsLogs.size() > logLen) pointsLogs.remove(0);
    this.Reflesh();
  }
    
  void Reflesh(){
    myBall.changeLocation(this.vX, this.vY);
    float against = calcAgainst();
    this.vX += this.aX + (-this.vX) * calcAgainst();
    this.vY += this.aY + (-this.vY) * calcAgainst();
    this.vZ += this.aZ + (-this.vZ) * calcAgainst();
  }
  
  private float calcAgainst(){
    float r = this.against * sqrt(sq(this.vX) + sq(this.vY) + sq(this.vZ));
    return (r > 1) ? (this.against *2) : r;
//    return (this.against * sq(v) * (v >= 0 ? -1:1));
//    return 0;
  }
}
