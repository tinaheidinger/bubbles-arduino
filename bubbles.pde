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

int gravityDirection = 180;

int canvasWidth = 640;
int canvasHeight = 360;

Ball[] balls = new Ball[numBalls];
float toRad( float x) {return ((x)*0.01745329252);}; 
float toDeg( float x) {return x*57.2957795131;};
void setup() {
  String portName = Serial.list()[1];
  serialPort = new Serial(this, portName, 9600);
  
  
  size(640, 360);
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(30, 70), i, random(255/2, 255), balls);
  }
}
int frameCounter = 0;
int frameInterval = 30;
void draw() {
  frameCounter ++;
  if (frameCounter > frameInterval) frameCounter = 0;
  
  if ( serialPort.available() > 0) {
    serialVal = serialPort.readStringUntil('\n');
    if (serialVal != null && frameCounter==frameInterval) {
      String[] XYZ = split(serialVal, ",") ;
      if (XYZ.length == 3) {
        serialX = parseInt(XYZ[0]);
        serialY = parseInt(XYZ[1]);
        serialZ = parseInt(XYZ[2]);
        //println(XYZ[2]);
        
         dpsX = round((serialX * 8.75) / 1000);
         dpsY = round((serialY * 8.75) / 1000);
         dpsZ = round((serialZ * 8.75) / 1000);
         
         dpsY = round( toDeg(dpsY) );
         dpsX = dpsX - (dpsX % 10) ;
         dpsY = dpsY - ((dpsX % 30));
         dpsZ = dpsZ - (dpsX % 10);
         //println(dpsX + ", " + dpsY + ", " + dpsZ);
         
      }
    }
  }
  
  if (frameCounter ==frameInterval) {
     int lastGravityDegrees = gravityDirection;
    setGravityDegrees(gravityDirection + dpsY);
    //println(gravityDirection);
    if( abs(gravityDirection - lastGravityDegrees) > 50) println( (gravityDirection - lastGravityDegrees));
   // println(serialX + ", " + serialY + ", " + serialZ);

  }
 
  background(backgroundColor);
  
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();
  }
  changeColor();
  
  darkenBackground(0);
  //brightenBackground(255);
  
  // debugging: draw a circle with an angle marker
  ellipseMode(CENTER);
  stroke(255,255,255);
  ellipse(canvasWidth / 2, canvasHeight / 2, 30, 30);
  float centerX = canvasWidth / 2;
  float centerY= canvasHeight / 2;
  float distance = 30;
  
  float markerX = centerX + distance * sin(gravityDirection);
  float markerY = centerY + distance * cos(gravityDirection);
   
  fill(255,0,0);
  ellipse(markerX, markerY, 10,10 );
  
  
  ellipseMode(CORNER);
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
void setGravityDegrees(float degrees) {
 /* if ((gravityDirection + degrees) >= 360) {
    gravityDirection = round(degrees % 360f);
  } 
  else if  ((gravityDirection + degrees) < 0) {
    gravityDirection = round( abs(gravityDirection + degrees) % 360f);
  }
   else if  ((gravityDirection + degrees) > 360) {
    gravityDirection = round( ((gravityDirection + degrees) - 360) % 360f);
  }
   // println(gravityDirection);
  */
  gravityDirection = (gravityDirection + round(degrees)) % 360;
}
void keyPressed() {
  
  gravityDirection = (gravityDirection + 45) % 360;

}