import ddf.minim.*;

public class Fireworks{
  ArrayList works;
  float sizeOfFireball = 0.5;
  float sizeOfLounchball = 1;
  float initSpeed = -15;
  float gravity = 0.007;
  float maxFireSpeed = 1.0;
  Minim minim;
//  AudioPlayer lounch, bomb;
  
  public Fireworks(){
    works = new ArrayList();
  }
  
  public Fireworks(Minim minim){
    works = new ArrayList();
    this.minim = minim;
  }
  
//  public Fireworks(AudioPlayer lounch, AudioPlayer bomb){
//    works = new ArrayList();
//    this.lounch = lounch;
//    this.bomb = bomb;
//  }
  
  public void addNewFirework(float x, float y, PImage icon){
    Firework fw = new Firework(x, y, initSpeed, gravity, sizeOfLounchball, color(0,0,225));
    fw.addLayerByImage(sizeOfFireball, icon, maxFireSpeed);
    if(this.minim != null){
      fw.setAudio(this.minim);
    }
//    if(this.lounch != null && this.bomb != null){
//      fw.setAudio(this.lounch, this.bomb);
//    }
//    fw.addLayer(sizeOfFireball, color((int)random(255), 255, 255), 1.0);
    this.works.add(fw);
  }
  
  public void addNewFireworkTest(float x, float y){
    Firework fw = new Firework(x, y, initSpeed, gravity, sizeOfLounchball, color(0,0,225));
    fw.addLayer(sizeOfFireball, color((int)random(255), 255, 255), maxFireSpeed);
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
