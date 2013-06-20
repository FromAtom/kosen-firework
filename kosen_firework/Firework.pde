import ddf.minim.*;
import java.util.*;

public class Firework{
  ArrayList layers;
  AudioPlayer lounch, bomb;
  float gravity = 0;
  FallingFireball starter;
  PImage image = null;
  float x = 0, y = 0;
  
  float heightI = 50;
  float widthI = 50;
  int numOfBall = 50;
  float digOfLounch = 20;
  float triggerOfFiring = 0;
  LightEffectFunction lef;
  int deley = 30;
  float colorMax = 255;
  private boolean isFirst = true;
  
  public Firework(float x, float y, float initSpeed, float gravity, float ballSize, color startColor){
    layers = new ArrayList();
    this.gravity = gravity;
    Point3Df p3d = new Point3Df(0, initSpeed, 0);
    p3d.rotateX(radians(random(digOfLounch)-digOfLounch/2));
    p3d.rotateZ(radians(random(digOfLounch)-digOfLounch/2));
    starter = new FallingFireball(x, y, ballSize, p3d.getX(), p3d.getY(), p3d.getZ(), 0, gravity, 0);
    starter.setColor(startColor);
    starter.setLogLen(10);
    
    this.lef = new Linear(100);
  }
  
  public void stop(){
    this.lounch.close();
    this.bomb.close();
  }
  
  public void setAudio(Minim minim){
    this.lounch = minim.loadFile("lounch.mp3");
    this.bomb = minim.loadFile("bomb.mp3");  
  }
  
  public int getNumOfLayers(){
    return this.layers.size();
  }
  
  public void addLayerByImage(float ballSize, PImage image, float maxSpeed){
    this.image = makeRoundImage(image);
    addLayer(ballSize, detectImageColor(image), maxSpeed);
  }
  
  PImage makeRoundImage(PImage iconImage){
    PGraphics roundedImage;

    roundedImage = createGraphics(iconImage.width+40, iconImage.height+40);
    roundedImage.beginDraw();
    roundedImage.background(255,0);
    roundedImage.image(iconImage,20,20);
    roundedImage.noFill();
    roundedImage.strokeWeight(15);
    roundedImage.ellipse(iconImage.width/2+20, iconImage.height/2+20, iconImage.width+15, iconImage.height+15);
    roundedImage.endDraw();
    
    return roundedImage;
  }
  
  public color detectImageColor(PImage image){
    int numOfColors = 8;
    ArrayList<Float> hVal = new ArrayList<Float>(), sVal = new ArrayList<Float>();
    ArrayList<Float> hSpan = new ArrayList<Float>(), sSpan = new ArrayList<Float>();
    image.loadPixels();
    for(int i = 0; i < image.width * image.height; i++){
      if(saturation(image.pixels[i]) > colorMax * 0.1 && brightness(image.pixels[i]) > colorMax * 0.1){
        hVal.add(hue(image.pixels[i]));
      }
      if(saturation(image.pixels[i]) > colorMax * 0.1){
        sVal.add(saturation(image.pixels[i]));
      }
    }
    
    Collections.sort(hVal);
    Collections.sort(sVal);
    int pointerH = 0, pointerS = 0;
    int maxCountH = 0, maxCountS = 0; 
  
    for(int i = 0; i < (colorMax+1)/numOfColors; i++){
      int counterH = pointerH, counterS = pointerS;
      while(pointerH < hVal.size() && hVal.get(pointerH) < i*numOfColors){
        pointerH++;
      }
      while(pointerS < sVal.size() && sVal.get(pointerS) < i*numOfColors){
        pointerS++;
      }
      if(maxCountH <= pointerH - counterH){
        maxCountH = pointerH - counterH;
        hSpan.clear();
        for(int j = 0; j <= maxCountH; j++){
          if(j != 0) hSpan.add(hVal.get(pointerH - j));
        }
      }
      if(maxCountS <= pointerS - counterS){
        maxCountS = pointerS - counterS;
        sSpan.clear();
        for(int j = 0; j <= maxCountS; j++){
          if(j != 0) sSpan.add(sVal.get(pointerS - j));
        }
      }
    }
    Collections.sort(hSpan);
    Collections.sort(sSpan);
    
    if(hSpan.size() != 0 && sSpan.size() != 0){
      return color(hSpan.get(hSpan.size()/2), sSpan.get(sSpan.size()/2), 255);
    }
    else if(hSpan.size() == 0){
      return color(colorMax, sSpan.get(sSpan.size()/2), colorMax);
    }
    else if(sSpan.size() == 0){
      return color(hSpan.get(hSpan.size()/2), colorMax, colorMax);
    }
    else{
      return color(colorMax, 0, colorMax);
    }
  }
  
  public void addLayer(float ballSize, color ballColor, float maxSpeed){
    Firelayer fl = new Firelayer();
    fl.setSize(ballSize);
    fl.setColor(ballColor);
    fl.setMaxSpeed(maxSpeed);
    fl.setGravity(this.gravity);
    if(random(2) < 1){
      fl.setLEFunc(new CubDec(100));
    }
    else{
      fl.setLEFunc(new KeepFlash(150, 100));
    }
    layers.add(fl);
  }
  
  public void drawAndReflesh(){
    if(starter != null){
      if(this.isFirst){
        lounch.play(0);
        this.isFirst = false;
      }
      starter.drawAndReflesh();
      if(starter.getVY() > triggerOfFiring){
        Fireball ball = starter.getFireball();
        for(int i = layers.size()-1; i >= 0; i--){
          ((Firelayer)layers.get(i)).generateSphere(this.numOfBall, ball.getX(), ball.getY());
        }
        this.x = ball.getX();
        this.y = ball.getY();
        starter = null;
        this.isFirst = true;
      }
    }
    else{
      if(this.image != null){
        tint(colorMax, ((layers.size()>0)?lef.function(((Firelayer)layers.get(0)).getCounter()):0) * colorMax); 
        image(this.image, this.x - widthI/2, this.y - heightI/2, widthI, heightI);
      }
      if(this.isFirst && ((layers.size()>0)?(((Firelayer)layers.get(0)).getCounter()):0) > deley){
        bomb.play(0);
        this.isFirst = false;
      }
      for(int i = layers.size()-1; i >= 0; i--){
        ((Firelayer)layers.get(i)).drawAndReflesh();
        if(((Firelayer)layers.get(i)).getNumOfBalls() == 0){
          layers.remove(i);
        }
      }
    }
  }
}
