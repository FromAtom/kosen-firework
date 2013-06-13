//FallingFireball ffb;
//Firelayer fl;
//Firelayer fl2;
//Firework fw;
Fireworks fws;

void setup(){
  //noStroke();
  colorMode(HSB, 255);
  smooth();
  background(0, 0, 0);
  size(640, 480);
  fws = new Fireworks();
  for(int i = 0; i < 20; i++){
    fws.addNewFireworkTest(width/2.0, height/1.1);
  }
}

void draw(){
  fill(0, 0, 0);
  background(0, 0, 0);
  if(random(1) < 0.2){
//      fmStars.addNewStar(1);
  }
//  ffb.drawAndReflesh();
//  fl.Reflesh();
//  fl2.Reflesh();
//  fw.drawAndReflesh();
  fws.drawAndReflesh();
}

