public class Fireworks{
  ArrayList works;
  float sizeOfFireball = 0.2;
  float sizeOfLounchball = 3;
  
  public Fireworks(){
    works = new ArrayList();
  }
  
  public void addNewFirework(float x, float y, PImage icon){
    Firework fw = new Firework(x, y, -50, 0.007, sizeOfLounchball, color(0,0,225));
    fw.addLayerByImage(sizeOfFireball, icon, 1.0);
//    fw.addLayer(sizeOfFireball, color((int)random(255), 255, 255), 1.0);
    this.works.add(fw);
  }
  
  public void addNewFireworkTest(float x, float y){
    Firework fw = new Firework(x, y, -50, 0.007, sizeOfLounchball, color(0,0,225));
    fw.addLayer(sizeOfFireball, color((int)random(255), 255, 255), 1.0);
    this.works.add(fw);
  }
  
  public void drawAndReflesh(){
    for(int i = works.size()-1; i >= 0; i--){
      ((Firework)works.get(i)).drawAndReflesh();
      if(((Firework)works.get(i)).getNumOfLayers() == 0){
        works.remove(i);
      }
    }
  }
}
