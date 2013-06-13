
interface TimeFunction{
  public float function(float timeCount);
}

public class Linear implements TimeFunction{
  float limit;
  public Linear(float limit){
    this.limit = limit;
  }
  public float function(float timeCount){
    return 1.0 - pow(timeCount/this.limit, 2);
  }
}

public class CubDec implements TimeFunction{
  float limit;
  float bias = 2.0;
  
  public CubDec(float limit){
    this.limit = limit;
  }
  
  public float function(float timeCount){
    float retVal = 1.0 - pow(timeCount/limit, 3);
    retVal += random(retVal*bias) - retVal*bias/2;  
    return (retVal<0) ? ((timeCount > limit*0.5) ? 0 : 0.0001) : ((retVal>1) ? 1 : retVal);
  }
}

public class KeepFlash implements TimeFunction{
  float keep, flash;
  float bias = 2.0;
  
  public KeepFlash(float keep, float flash){
    this.keep = keep;
    this.flash = flash;
  }
  
  public float function(float timeCount){
    if(timeCount < keep){
      return 0.2;
    }
    else{
      float retVal = 0.8 - pow((timeCount-keep)/flash, 1);
      retVal += random(retVal*bias) - retVal*bias/2;  
      return (retVal<0) ? ((timeCount > keep+flash) ? 0 : 0.0001) : ((retVal>1) ? 1 : retVal);
    }
  }
}
