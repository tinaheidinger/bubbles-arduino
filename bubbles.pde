int numBalls = 12;
float spring = 0.01;
float gravity = 0.2;
float friction = -0.9;
int colorR, colorG, colorB;

int[][] colors = { {81,189,244}, {154,226,109}, {250,237,115}, {248,103,105}, {64,64,64} };
int currentColor = 0;
int backgroundColor = 255;
int timeout = 0;

int gravityDirection = 180;

Ball[] balls = new Ball[numBalls];

void setup() {
  size(640, 360);
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(30, 70), i, random(255/2, 255), balls);
  }
}

void draw() {
  background(backgroundColor);
  
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();
  }
  changeColor();
  
  darkenBackground(0);
  //brightenBackground(255);
}

void darkenBackground(int newBackground) {
  if (backgroundColor > newBackground) {
    backgroundColor--;
    //println(backgroundColor);
  }
}

void brightenBackground(int newBackground) {
  if (backgroundColor < newBackground) {
    backgroundColor++;
    //println(backgroundColor);
  }
}

void changeColor() {
// change color every 50 milliseconds
  if (timeout >= 50) {
    int newColor = (int)random(0,colors.length);    
    while (newColor == currentColor) {
      newColor = (int)random(0,colors.length);
    }    
    currentColor = newColor;
    timeout = 0;
  } else { timeout++; }
}

void keyPressed() {
  gravityDirection = (gravityDirection + 45) % 360;
}