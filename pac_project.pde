static float MOVE_SPEED = 2;
static int stage = 1;
final static float COIN_SCALE = 0.1;
final static float TANK_SCALE = 0.28;

final static int NEUTRAL_FACING = 0; 
final static int RIGHT_FACING = 1; 
final static int LEFT_FACING = 2; 

Grid grid;
Player player;
PImage c;
ArrayList<Sprite> coins; 
int score = 0;
boolean beat;
int direction;

void setup(){
  size(600, 600);
  imageMode(CENTER);
  player = new Player("tank.png", TANK_SCALE, width / 2, height / 2 + 100);
  c = loadImage("gold1.png");
  grid = new Grid();
  grid.load_level();
  beat = false;
  direction = 1;
  coins = new ArrayList<Sprite>();
  for(int i = 0; i < stage; i++){
    Coin coin = new Coin(c, COIN_SCALE);
    coin.center_x = (float)(Math.random()*width);
    coin.center_y = (float)(Math.random()*height);
    while(grid.is_wall(coin.center_x, coin.center_y) && (coin.center_x != player.center_x) && (coin.center_y != player.center_y)){
      coin.center_x = (float)(Math.random() * width);
      coin.center_y = (float)(Math.random() * height);
    }
    coins.add(coin);
  }
}



void draw(){
  fill(0);
  rect(mouseX, mouseY, 10, 10, 10, 10, 10, 10);
  background(0);
  
  if(player.getLeft() > width){
    player.center_x = 0;
  }
  if(player.getRight() < 0){
    player.center_x = width;
  }
  if(player.getTop() > height){
    player.center_y = 0;
  }
  if(player.getBottom() < 0){
    player.center_y = height;
  }
  
  
  grid.draw();
  player.draw();
  textSize(22);
  fill(255, 0, 0);
  text("Score: " + score, 30, 30);
  text("Speed: " + MOVE_SPEED, 30, 50);
  
  if(coins.size() == 0){
    beat = true;
    background(0);
    fill(255);
    noStroke();
    rect(width / 2 - 170, height / 2 + 40, 350, 50);
    if(mouseX > width / 2 - 170 && mouseX < width / 2 - 170 + 350 && mouseY > height / 2 + 40 && mouseY < height / 2 + 40 + 50){
     fill(255, 200, 0); 
     noStroke();
     rect(width / 2 - 170, height / 2 + 40, 350, 50);
    }
    fill(255, 0, 0);
    textAlign(CENTER);
    textSize(32);
    text("Congratulations! You have beat stage " + stage, width / 2, height / 2);
    text("click to go to next level", width / 2, height / 2 + 70);
    if(mousePressed){
      if(mouseX > width / 2 - 170 && mouseX < width / 2 - 170 + 350 && mouseY > height / 2 + 40 && mouseY < height / 2 + 40 + 50){
        beat = false;
        stage++;
        MOVE_SPEED++;
        if(MOVE_SPEED > 6){
         MOVE_SPEED = 6; 
        }
        setup();
      }
    }
  }

  // use for each loop to display coins
  for(Sprite coin: coins){    
    coin.display();
    ((AnimatedSprite)coin).updateAnimation();
  }
  // call checkCollisionList and 
  // store the returned collision list(arraylist) of coin Sprites that collide with player.
  // if collision list not empty
  //   for loop through collision list
  //     remove each coin, add 1 to score
  ArrayList<Sprite> collision_list = checkCollisionList(player, coins);
  if(collision_list.size() > 0){
    for(Sprite coin: collision_list){
        coins.remove(coin);
        score++;
       }
  }
}

// returns whether the two Sprites s1 and s2 collide.
public boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }
  else{
    return true;
  }
}

/**
   This method accepts a Sprite s and an ArrayList of Sprites and returns
   the collision list(ArrayList) which consists of the Sprites that collide with the given Sprite. 
   MUST CALL THE METHOD checkCollision ABOVE!
*/ 
public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}


void keyPressed(){
  if(keyCode == RIGHT || keyCode == 'D'){
    player.change_x = MOVE_SPEED;
    player.change_y = 0;
    player.image = loadImage("tank.png");
}
  else if(keyCode == LEFT || keyCode == 'A'){
    direction = 2;
    player.change_x = -MOVE_SPEED;
    player.change_y = 0;
    player.image = loadImage("tankL.png");
}
  else if(keyCode == UP || keyCode == 'W'){
    direction = 3;
    player.change_y = -MOVE_SPEED;
    player.change_x = 0;
    player.image = loadImage("tankU.png");
}
  else if(keyCode == DOWN || keyCode == 'S'){
    direction = 4;
    player.change_y = MOVE_SPEED;
    player.change_x = 0;
    player.image = loadImage("tankD.png");
  } 
}

void keyReleased(){
  if(coins.size() == 0){
  if(keyCode == RIGHT || keyCode == 'D')
    player.change_x = 0;
  else if(keyCode == LEFT || keyCode == 'A')
    player.change_x = 0;
  else if(keyCode == UP || keyCode == 'W')
    player.change_y = 0;
  else if(keyCode == DOWN || keyCode == 'S' )
    player.change_y = 0;
  }
}
