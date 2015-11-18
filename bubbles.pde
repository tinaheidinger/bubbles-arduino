int numBalls = 12;
float spring = 0.05;
float gravity = 0.01;
float friction = -0.9;
int colorR, colorG, colorB;

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

class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  float opacity;
  int id;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, float opac, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    opacity = opac;
    others = oin;
  } 
  
  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }   
  }
  
  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
  
  void display() {
    noStroke();
    fill(colorR,colorG,colorB,opacity);
    ellipse(x, y, diameter, diameter);
  }
}