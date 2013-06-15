public class MapRenderClass {
  int currentHeldNumber = 0;
  float alphaDepth = 0;
  float degree = 0.0;
  float degreeStep = 5.0;
  PImage backGroundImage;
  PImage currentImage;
  String[] currentSiteInfo;
  
  public MapRenderClass(){
    backGroundImage = loadImage("map_default.png");           
    currentSiteInfo = heldInfoList.get(currentHeldNumber);
    currentImage = loadImage("map_" + heldSiteMap.get(currentSiteInfo[3]));
  }
  
  public int getCurrentHeldNumber(){
    return currentHeldNumber;
  }
  
  public void nextHeldSite(){
    currentHeldNumber++;
    if(currentHeldNumber >= heldInfoList.size())
      currentHeldNumber = heldInfoList.size()-1;
    currentSiteInfo = heldInfoList.get(currentHeldNumber);
    currentImage = loadImage("map_" + heldSiteMap.get(currentSiteInfo[3]));
  }
  
  public void writeInfoData(){
    PFont font = createFont("rounded-mplus-1p-thin",48,true);
    textFont(font, 32);
    textAlign(LEFT);
    text(currentSiteInfo[0], 20, 50); 

    textFont(font, 23);
    text(currentSiteInfo[1], 20, 80); 

    textFont(font, 23);
    text("@"+currentSiteInfo[2], 20, 120); 

  }

  
  public void update(){
    noTint();
    image(backGroundImage,0,0);

    writeInfoData();

    degree += degreeStep;
    alphaDepth = abs(sin(radians(degree))*255);
    
    if(degree >= 360 || degree <= 0){
      degreeStep *= -1;
    }

    tint(255, alphaDepth);
    image(currentImage,0,0);
    }
}
