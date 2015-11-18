int numBalls = 12;
float spring = 0.05;
float gravity = 0.01;
float friction = -0.9;
int colorR, colorG, colorB;
int gravityDirection = 180;

Ball[] balls = new Ball[numBalls];

void setup() {
  size(640, 360);
  colorR = 0;
  colorG = 100;
  colorB = 255;
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
}

void keyPressed() {
  gravityDirection = (gravityDirection + 45) % 360;
  println(gravityDirection);
}