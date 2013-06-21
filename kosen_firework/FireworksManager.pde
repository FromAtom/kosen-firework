import ddf.minim.*;

public class FireworksManager{
  ArrayList works;
  float sizeOfFireball = 0.5;
  float sizeOfLounchball = 1;
  float initSpeed = -15;
  float gravity = 0.007;
  float maxFireSpeed = 1.0;
  Minim minim;
  
  float colorMax = 255;
  
  public FireworksManager(){
    works = new ArrayList();
  }
  
  public FireworksManager(Minim minim){
    works = new ArrayList();
    this.minim = minim;
  }
  
  public void addNewFirework(float x, float y, PImage icon){
    Firework fw = new Firework(x, y, initSpeed, gravity, sizeOfLounchball, color(0,0,colorMax));
    fw.addLayerByImage(sizeOfFireball, icon, maxFireSpeed);
    if(this.minim != null){
      fw.setAudio(this.minim);
    }
    this.works.add(fw);
  }
  
  public void addNewFireworkTest(float x, float y){
    Firework fw = new Firework(x, y, initSpeed, gravity, sizeOfLounchball, color(0,0,colorMax));
    fw.addLayer(sizeOfFireball, color((int)random(colorMax), colorMax, colorMax), maxFireSpeed);
    if(this.minim != null){
      fw.setAudio(this.minim);
    }
    this.works.add(fw);
  }
  
  public void drawAndReflesh(){
    for(int i = works.size()-1; i >= 0; i--){
      ((Firework)works.get(i)).drawAndReflesh();
      if(((Firework)works.get(i)).getNumOfLayers() == 0){
        ((Firework)works.get(i)).stop();
        works.remove(i);
      }
    }
  }
}
