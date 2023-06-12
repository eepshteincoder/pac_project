class Timer{
  float time;
  Timer(float seconds){
    this.time = seconds;
  }
  public void setTime(float t){
   time = t; 
  }
  public float getTime(){
    return time;
  }
  public void countUp(){
   time += 1/frameRate; 
  }
  public void countDown(){
   time -= 1/frameRate; 
  }
}
