static float MOVE_SPEED = 2;
static float BALL_SPEED = 1.25;
static int lives = 3;
final static float COIN_SCALE = 0.1;
final static float TANK_SCALE = 0.28;
final static float BALL_SCALE = 0.1;
final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;

Grid grid;
Timer timer;
Player player, ball;
PImage c;
ArrayList<Sprite> coins;
ArrayList<Player> cannons;
int score = 0;
boolean beat;
boolean dead;
int num_coins = 3;
int stage = 1;
int original;

void setup() {
  size(600, 600);
  frameRate(60);
  imageMode(CENTER);
  player = new Player("tank.png", TANK_SCALE, width / 2, height / 2 + 100);
  ball = new Player("ball.png", BALL_SCALE, 30, 30);
  c = loadImage("gold1.png");
  original = stage;
  grid = new Grid();
  grid.load_level();
  timer = new Timer(1);
  beat = false;
  dead = false;
  ball.change_x = BALL_SPEED;
  ball.change_y = BALL_SPEED;
  coins = new ArrayList<Sprite>();
  cannons = new ArrayList<Player>();
  for (int i = 0; i < (stage * num_coins) + num_coins; i++) {
    if(stage > original){
     num_coins--; 
     original = stage;
     if(num_coins <= 1){
      num_coins = 1; 
     }
    }
    Coin coin = new Coin(c, COIN_SCALE);
    coin.center_x = (float)(Math.random()*width);
    coin.center_y = (float)(Math.random()*height);
    while (grid.is_wall(coin.center_x, coin.center_y) || (coin.center_x == player.center_x) && (coin.center_y == player.center_y)) {
      coin.center_x = (float)(Math.random() * width);
      coin.center_y = (float)(Math.random() * height);
    }
    println(coins.size());
    coins.add(coin);
  }
  cannons.add(ball);
}



void draw() {

  if (checkCollision(ball, player) && coins.size() > 0) {
    background(255, 0, 0);
    lives--;
    player.center_x = width / 2;
    player.center_y = height / 2 + 100;
    ball.center_x = 30;
    ball.center_y = 30;
    ball.change_x = BALL_SPEED;
    ball.change_y = BALL_SPEED;
  }
  if (lives == 0) {
    textAlign(CENTER);
    dead = true;
    background(0);
    textSize(32);
    fill(255);
    text("You lost", width / 2, height / 2 - 50);
    text("Your score was " + score, width / 2, height / 2);
    text("Click enter to restart", width / 2, height / 2 + 50);
  } else if (!dead) {
    background(0);
    for (Sprite coin : coins) {
      coin.display();
      ((AnimatedSprite)coin).updateAnimation();
    }
    grid.draw();
    player.draw();
    ball.draw();
    textSize(22);
    fill(255, 0, 0);
    text("Score: " + score, 30, 30);
    text("Stage: " + stage, 30, 50);
    text("Lives: " + lives, 30, 70);

    if (coins.size() == 0 && !dead) {
      beat = true;
      background(0);
      fill(255);
      noStroke();
      rect(width / 2 - 170, height / 2 + 40, 350, 50);
      fill(255, 0, 0);
      textAlign(CENTER);
      textSize(32);
      text("Congratulations! You have beat stage " + stage, width / 2, height / 2);
      text("click to go to next level", width / 2, height / 2 + 70);
      if (mouseX > width / 2 - 170 && mouseX < width / 2 - 170 + 350 && mouseY > height / 2 + 40 && mouseY < height / 2 + 40 + 50) {
        fill(255, 200, 0);
        noStroke();
        rect(width / 2 - 170, height / 2 + 40, 350, 50);
        fill(0);
        textSize(32);
        text("click to go to next level", width / 2, height / 2 + 70);
      }
      if (mousePressed) {
        if (mouseX > width / 2 - 170 && mouseX < width / 2 - 170 + 350 && mouseY > height / 2 + 40 && mouseY < height / 2 + 40 + 50) {
          beat = false;
          stage++;
          MOVE_SPEED++;
          BALL_SPEED *= 1.1;
          if (MOVE_SPEED > 4) {
            MOVE_SPEED = 4;
          }
          if (BALL_SPEED > 3) {
            BALL_SPEED = 3;
          }
          setup();
        }
      }
    }

    if (grid.is_wall(ball.center_x + ball.change_x, ball.center_y)) {
      ball.change_x *= -1 - ((float)Math.random() / 10.0 - 0.025);
      if (abs(ball.change_x) > 3) {
        ball.change_x = 3 * (ball.change_x >= 0 ? 1 : -1);
      }
    }
    if (grid.is_wall(ball.center_x, ball.center_y + ball.change_y)) {
      ball.change_y *= -1 - ((float)Math.random() / 10.0 - 0.025);
      if (abs(ball.change_y) > 3) {
        ball.change_y = 3 * (ball.change_y >= 0 ? 1 : -1);
      }
    }
    ball.center_x += ball.change_x;
    ball.center_y += ball.change_y;

    if (player.getLeft() > width) {
      player.center_x = 0;
    }
    if (player.getRight() < 0) {
      player.center_x = width;
    }
    if (player.getTop() > height) {
      player.center_y = 0;
    }
    if (player.getBottom() < 0) {
      player.center_y = height;
    }


    if (ball.getLeft() > width) {
      ball.center_x = 0;
    }
    if (ball.getRight() < 0) {
      ball.center_x = width;
    }
    if (ball.getTop() > height) {
      ball.center_y = 0;
    }
    if (ball.getBottom() < 0) {
      ball.center_y = height;
    }
  }
  // call checkCollisionList and
  // store the returned collision list(arraylist) of coin Sprites that collide with player.
  // if collision list not empty
  //   for loop through collision list
  //     remove each coin, add 1 to score
  ArrayList<Sprite> collision_list = checkCollisionList(player, coins);
  if (collision_list.size() > 0) {
    for (Sprite coin : collision_list) {
      coins.remove(coin);
      score++;
    }
  }
}
// returns whether the two Sprites s1 and s2 collide.
public boolean checkCollision(Sprite s1, Sprite s2) {
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if (noXOverlap || noYOverlap) {
    return false;
  } else {
    return true;
  }
}

/**
 This method accepts a Sprite s and an ArrayList of Sprites and returns
 the collision list(ArrayList) which consists of the Sprites that collide with the given Sprite.
 MUST CALL THE METHOD checkCollision ABOVE!
 */
public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list) {
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for (Sprite p : list) {
    if (checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}


void keyPressed() {
  if (dead) {
    if (keyCode == ENTER) {
      score = 0;
      stage = 1;
      MOVE_SPEED = 2;
      BALL_SPEED = 1.25;
      lives = 3;
      setup();
    }
  }
  if (keyCode == RIGHT || keyCode == 'D') {
    player.change_x = MOVE_SPEED;
    player.change_y = 0;
    player.image = loadImage("tank.png");
  } else if (keyCode == LEFT || keyCode == 'A') {
    player.change_x = -MOVE_SPEED;
    player.change_y = 0;
    player.image = loadImage("tankL.png");
  } else if (keyCode == UP || keyCode == 'W') {
    player.change_y = -MOVE_SPEED;
    player.change_x = 0;
    player.image = loadImage("tankU.png");
  } else if (keyCode == DOWN || keyCode == 'S') {
    player.change_y = MOVE_SPEED;
    player.change_x = 0;
    player.image = loadImage("tankD.png");
  }
}

void keyReleased() {
  if (coins.size() == 0) {
    if (keyCode == RIGHT || keyCode == 'D')
      player.change_x = 0;
    else if (keyCode == LEFT || keyCode == 'A')
      player.change_x = 0;
    else if (keyCode == UP || keyCode == 'W')
      player.change_y = 0;
    else if (keyCode == DOWN || keyCode == 'S' )
      player.change_y = 0;
  }
}
