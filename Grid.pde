class Grid {

  String[][] data = new String[30][30];

  // constr 
  Grid() {

    for (int j=0; j<30; j++) {
      for (int i=0; i<30; i++) {

        /*data[j][i] = "2";

        int a = int(random(4));
        data[j][i] = str(a); // any*/

        // screen border
        if (0==i || 0==j || 29==i || 29==j) { 
          data[j][i] = "1"; // wall
        } 
      }
    }

    data[5][10] = "3";
  }//constr

  void draw() {
    for (int j=0; j < height/20; j++) {
      for (int i=0; i < width/20; i++) {
        noFill();      
        if (data[j][i].equals("1")) { 
          fill(0, 0, 255); // blue
          stroke(0, 0, 255);
          strokeWeight(12);
          pushMatrix();
          translate(20*i, 20*j);
          line(10, 10, 10, 10);
          if (i<29 && data[j][i+1] .equals("1")) {
            line(10, 10, 30, 10);
          }
          if (j<29 && data[j+1][i] .equals("1")) {
            line(10, 10, 10, 30);
          }
          popMatrix();
        }
      }
    }
  }

  boolean is_wall(float ix, float iy) {
    try{
      int i = int(ix/20);
      int j = int(iy/20);
      return (data[j][i] .equals("1"));
    } catch(Exception e) { return false; }
  }

  void on_keyPressed() {
    if (key == 's' ) { 
      save_level();
    }
    if (key == 'l' ) {
      load_level();
    }
  }

  void save_level() {
    String[] temp = new String[30];
    int t = 0;
    for (int j = 0; j < 30; j++) {
      temp[j] = "";
      for (int i = 0; i < 30; i++) {
        temp[j] += data[j][i];
      }
    } 
    saveStrings("world.txt", temp);
    println("Level saved.");
  }  

  void load_level() {
    String[] temp = loadStrings("world.txt");
    //int t = 0;
    // Loading successful?
    if (temp!=null) {
      // success in loading 
      for (int j = 0; j < 30; j++) {
        for (int i = 0; i < 30; i++) {
          data[j][i] = "" + temp[j].charAt(i);
         }
      }
      println("Level loaded.");
    }
  }
}
