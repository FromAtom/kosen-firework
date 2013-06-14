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
    currentImage = loadImage(heldSiteMap.get(currentSiteInfo[2]));
  }
  
  public int getCurrentHeldNumber(){
    return currentHeldNumber;
  }

  
  public void nextHeldSite(){
    currentHeldNumber++;
    currentSiteInfo = heldInfoList.get(currentHeldNumber);
    currentImage = loadImage(heldSiteMap.get(currentSiteInfo[2]));
  }
  
  public void update(){
    noTint();
    image(backGroundImage,0,0);

    textSize(32);
    text(currentSiteInfo[1], 10, 40); 
    text(currentSiteInfo[0], 10, 70); 


    degree += degreeStep;
    alphaDepth = abs(sin(radians(degree))*255);
    
    if(degree >= 360 || degree <= 0){
      degreeStep *= -1;
    }

    tint(255, alphaDepth);
    image(currentImage,0,0);
    }
}
