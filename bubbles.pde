import processing.serial.*;

Serial serialPort; 
String serialVal;
int serialX = 0;
int serialY = 0;
int serialZ = 0;
 float dpsX = 0;
  float dpsY = 0;
  float dpsZ = 0;
int numBalls = 12;
float spring = 0.01;
float gravity = 0.2;
float friction = -0.9;
int colorR, colorG, colorB;

int[][] colors = { {81,189,244}, {154,226,109}, {250,237,115}, {248,103,105}, {64,64,64} };
int currentColor = 0;
int backgroundColor = 255;
int timeout = 0;

int gravityDirection = 0;
int thresholdX = 15000;
int thresholdY = 13000;
int canvasWidth = 640;
int canvasHeight = 360;

int millisCounter = millis();

Ball[] balls = new Ball[numBalls];

void setup() {
  String portName = Serial.list()[1];
  serialPort = new Serial(this, portName, 9600);
  
  size(1000, 650);
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(70, 110), i, random(255/2, 255), balls);
  }
}

void draw() {
  background(backgroundColor);
  
  if ( serialPort.available() > 0) {
    serialVal = serialPort.readStringUntil('\n');
    if (serialVal != null) {
      String[] XYZ = split(serialVal, ",") ;
      if (XYZ.length == 3) {
        serialX = parseInt(XYZ[0]);
        serialY = parseInt(XYZ[1]);
        serialZ = parseInt(XYZ[2]);

         if (millis() - millisCounter > 500) {
           millisCounter = millis();
           println("X: " + serialX + " Y: " + serialY);
           
           if (serialX > thresholdX) {
             gravityDirection = 0;
             println("UNTEN");
             changeColor();
           }
           else if (serialX < -thresholdX) {
             gravityDirection = 180;
             println("OBEN");
             changeColor();
           }
           else if (serialY < -thresholdY) {
             gravityDirection = 270;
             println("LINKS");
             changeColor();
           }
           else if (serialY >thresholdY) {
             gravityDirection = 90;
             println("RECHTS");
             changeColor();
           }
         }
      }
    }
  }
  
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();
  }
  
  // debugging: draw a circle with an angle marker
  ellipseMode(CENTER);
  stroke(255,255,255);
  //ellipse(canvasWidth / 2, canvasHeight / 2, 30, 30);
  float centerX = canvasWidth / 2;
  float centerY= canvasHeight / 2;
  float distance = 30;
  
  float markerX = centerX + distance * sin(gravityDirection);
  float markerY = centerY + distance * cos(gravityDirection);
}

void darkenBackground(int newBackground) {
  if (backgroundColor > newBackground) {
    backgroundColor--;
  }
}

void brightenBackground(int newBackground) {
  if (backgroundColor < newBackground) {
    backgroundColor++;
  }
}

void changeColor() {
    int newColor = (int)random(0,colors.length);    
    while (newColor == currentColor) {
      newColor = (int)random(0,colors.length);
    }    
    currentColor = newColor;
    timeout = 0;
}