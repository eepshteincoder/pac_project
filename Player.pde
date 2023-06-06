class Player extends Sprite{
  int d;
  public Player(String filename, float scale, float x, float y){
   super(filename, scale, x, y);   
   d = -1;
  }
  void draw(){
   if(change_x > 0){
    d = 0; 
   }
   else if(change_x < 0){
    d = 2; 
   }
   else if(change_y > 0){
    d = 1; 
   }
   else if(change_y < 0){
     d = 3;
   }
   simulate(); 
   super.display(center_x, center_y);
  }
  void simulate(){
   float px = center_x;
   float py = center_y;
   if ( 0 == d ) 
     { center_x += change_x; }
    if (1 == d) 
     { center_y += change_y; }
    if (2 == d) 
     { center_x += change_x; }
    if (3 == d) 
     { center_y += change_y; }
     println("checking is_wall");
     if (grid.is_wall(center_x, center_y)) {
      center_x = px;
      center_y = py;
     }
  } 
}
