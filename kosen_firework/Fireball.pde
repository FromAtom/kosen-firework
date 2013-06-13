public class Fireball{
  float x = 0;
  float y = 0;
  float ballSize = 0;
  color ballColor;
  
  public Fireball(float x, float y, float ballSize, color ballColor){
    this.x = x;
    this.y = y;
    this.ballSize = ballSize;
    this.ballColor = ballColor;
  }
  
  public Fireball(float x, float y, float ballSize){
    this.x = x;
    this.y = y;
    this.ballSize = ballSize;
  }
  
  public float getX(){ return this.x; }
  public float getY(){ return this.y; }
  public color getColor(){ return this.ballColor; }
  
  public void setColor(color ballColor){
    this.ballColor = ballColor;
  }
  
  public void changeLocation(float difX, float difY){
    this.x += difX;
    this.y += difY;
  }
  
  void drawBall(){ drawBall(this.x, this.y, this.ballSize, this.ballColor); }
  
  void drawBallShade(float x, float y, float shade){
    drawBall(x, y, this.ballSize, color(hue(this.ballColor), saturation(this.ballColor), brightness(this.ballColor), 255*shade)); 
  }
  
  void drawBall(float x, float y, float ballSize, color ballColor){
    pushMatrix();
      ellipseMode(CENTER);
      fill(ballColor);
      stroke(ballColor);
      ellipse(x, y, ballSize, ballSize);
    popMatrix();
  }
}
