class Grid {
  String[][] data;
  Grid() {
    data = new String[32][32];
  }

  void draw() {
      for (int j = 1; j < 31; j++) {
        for (int i = 1; i < 31; i++) {
          noFill();
          if (data[j][i].equals("1")) {
            fill(150, 100, 255); // purple
            stroke(150, 100, 255);
            strokeWeight(12);
            pushMatrix();
            translate(20 * (i - 1), 20 * (j-1));
            line(10, 10, 10, 10);
            if (i < 30 && data[j][i + 1] .equals("1")) {
              line(10, 10, 30, 10);
            }
            if (j < 30 && data[j + 1][i] .equals("1")) {
              line(10, 10, 10, 30);
            }
            popMatrix();
          }
        }
      }
  }

  boolean is_wall(float ix, float iy) {
    try {
      int i = int(ix/20) + 1;
      int j = int(iy/20) + 1;
      return (data[j][i] .equals("1"));
    }
    catch(Exception e) {
      return false;
    }
  }

  void load_level() {
    String[] temp = loadStrings("world.txt");
    // Loading successful?
    if (temp!=null) {
      // success in loading
      for (int j = 0; j < 32; j++) {
        for (int i = 0; i < 32; i++) {
          data[j][i] = "" + temp[j].charAt(i);
        }
      }
    }
  }
}
