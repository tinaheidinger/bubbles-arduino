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
    vx += sin(radians(gravityDirection)) * gravity;
    vy += cos(radians(gravityDirection)) * gravity;
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
    fill(colors[currentColor][0],colors[currentColor][1],colors[currentColor][2],opacity);
    ellipse(x, y, diameter, diameter);
  }
}