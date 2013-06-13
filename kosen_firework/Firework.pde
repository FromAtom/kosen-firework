public class Firework{
  ArrayList layers;
  float gravity = 0;
  FallingFireball starter;
  PImage image = null;
  float x = 0, y = 0;
  float heightI = 50;
  float widthI = 50;
  int numOfBall = 50;
  float digOfLounch = 20;
  
  public Firework(float x, float y, float initSpeed, float gravity, float ballSize, color startColor){
    layers = new ArrayList();
    this.gravity = gravity;
    Point3Df p3d = new Point3Df(0, initSpeed, 0);
    p3d.rotateX(radians(random(digOfLounch)-digOfLounch/2));
    p3d.rotateZ(radians(random(digOfLounch)-digOfLounch/2));
    starter = new FallingFireball(x, y, ballSize, p3d.getX(), p3d.getY(), p3d.getZ(), 0, gravity, 0);
    starter.setColor(startColor);
    starter.setLogLen(10);
  }
  
  public int getNumOfLayers(){
    return this.layers.size();
  }
  
  public void addLayerByImage(float ballSize, PImage image, float maxSpeed){
    this.image = image;
    addLayer(ballSize, detectImageColor(image), maxSpeed);
  }
  
  public color detectImageColor(PImage image){
    return color(255, 255, 255);
  }
  
  public void addLayer(float ballSize, color ballColor, float maxSpeed){
    Firelayer fl = new Firelayer();
    fl.setSize(ballSize);
    fl.setColor(ballColor);
    fl.setMaxSpeed(maxSpeed);
    fl.setGravity(this.gravity);
//    fl.setTimeFunction(new CubDec(100));
    fl.setTimeFunction(new KeepFlash(150, 100));
    layers.add(fl);
  }
  
  public void drawAndReflesh(){
    if(starter != null){
      starter.drawAndReflesh();
      if(starter.getVY() > 0.3){
        Fireball ball = starter.getFireball();
        for(int i = layers.size()-1; i >= 0; i--){
          ((Firelayer)layers.get(i)).generateSphere(this.numOfBall, ball.getX(), ball.getY());
        }
        this.x = ball.getX();
        this.y = ball.getY();
        starter = null;
      }
    }
    else{
//      int totalBalls = 0;
      float totalTimeFunc = 0;
      for(int i = layers.size()-1; i >= 0; i--){
        ((Firelayer)layers.get(i)).drawAndReflesh();
        totalTimeFunc += ((Firelayer)layers.get(i)).getTimeFunc();
        if(((Firelayer)layers.get(i)).getNumOfBalls() == 0){
          layers.remove(i);
        }
      }
//      println(totalBalls);
//      println(totalTimeFunc);
      if(this.image != null){
//        totalBalls /= layers.size();
        totalTimeFunc /= layers.size();
        tint(255, totalTimeFunc * 255); 
        image(this.image, this.x - widthI/2, this.y - heightI/2, widthI, heightI); 
      }
    }
  }
}
