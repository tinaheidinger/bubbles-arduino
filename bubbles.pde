int numBalls = 12;
float spring = 0.05;
float gravity = 0.01;
float friction = -0.9;
int colorR, colorG, colorB;
int[][] colors = { {81,189,244}, {154,226,109}, {250,237,115}, {248,103,105}, {64,64,64} };
int currentColor = 0;
int timeout = 0;

Ball[] balls = new Ball[numBalls];

void setup() {
  size(640, 360);
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(30, 70), i, random(255/2, 255), balls);
  }
}

void draw() {
  background(255);
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();
  }
  
  changeColor();
}

void changeColor() {
// change color every 50 milliseconds
  if (timeout >= 50) {
    int newColor = (int)random(0,5);    
    while (newColor == currentColor) {
      newColor = (int)random(0,5);
    }    
    currentColor = newColor;          
    timeout = 0;
  } else { timeout++; }
}