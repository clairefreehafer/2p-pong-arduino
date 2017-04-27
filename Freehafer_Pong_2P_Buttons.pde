import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
int buttonPin = 2;
int buttonPin1 = 4;
int buttonPin2 = 7;
int buttonPin3 = 8;

boolean ballbounce;
boolean P2press = false;
boolean pause = false;
boolean gameStart = false;

//Ball ball1, ball2;

int P1Y = 250;
int P2Y = 250;

int speedX = -5;
int speedY = 5;
// ball starting position
int ballX = 500;
int ballY = 250;

void setup() {
  size(1000,500);
  ellipseMode(CENTER);
  //ball2 = new Ball(500,250, 30, -5, -5); 
  //ball1 = new Ball(500,250,30, 5, 5); 
  
  for(int i = 0; i < Arduino.list().length; i ++){
    println(i + "  " + Arduino.list()[i]); // prints your USB bus
  }
  arduino = new Arduino(this, Arduino.list()[5], 57600); //[] change the number tty.usb
  arduino.pinMode(buttonPin, Arduino.INPUT);// sets port 2 to input
  arduino.pinMode(buttonPin1, Arduino.INPUT);// sets port 4 to input
  arduino.pinMode(buttonPin2, Arduino.INPUT);// sets port 7 to input
  arduino.pinMode(buttonPin3, Arduino.INPUT);// sets port 8 to input
  arduino.digitalWrite(buttonPin, 1);
  arduino.digitalWrite(buttonPin1, 1); 
  arduino.digitalWrite(buttonPin2, 1);
  arduino.digitalWrite(buttonPin3, 1);// optional line to turn on the internal pullup resistors
}

void mouseClicked() {
  gameStart = true;
}

void keyPressed() {
  P2press = true;
}

void keyReleased() {
  P2press = false;
}

void draw() {
  background(0);
  noStroke();
  P1paddle();
  P2paddle();
  fill(255);
  rect(960,P2Y,20,100);
  //ball();
  gameOver();
  P1bounce();
  P2bounce();
  if (gameStart == false) {
    fill(255);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Click to start",500,250);
    textSize(25);
    text("P1 control with mouse",500,300);
    text("P2 control with arrow keys",500,325);
  }
  else if (gameStart == true) {
    ball();
    //ball1.update();
    //ball2.update();
  }
}

void P1paddle() {
  fill(255);
  int P1X = 20;
  if (arduino.digitalRead(buttonPin1) == 0) { // if the button is not pressed
    P1Y = P1Y - 5;
  } 
  else if (arduino.digitalRead(buttonPin) == 0) { // if the button is not pressed
   P1Y = P1Y + 5;
  }
  rect(P1X,P1Y,20,100);
}

//void keyPressed() {
  //int P2Y = 250;

//}
class Ball {
  float xpos;
  float ypos;
  float xspeed;
  float yspeed;
  float raduis; 

  Ball(float x, float y, float r, float sx, float sy) {
    xpos = x; 
    ypos = y; 
    xspeed = sx;
    yspeed = sy; 
    raduis = r; 
 }

  void update(){
    xpos = xpos + xspeed;
    ypos = yspeed + ypos; 
    ellipse(xpos, ypos, raduis, raduis);
  
    if (ypos > 500) {
      yspeed = yspeed * (-1);
     }
    else if (ypos == 0) {
      yspeed = yspeed * (-1);
    }
    if (xpos > 960) {
      xspeed = xspeed * (-1);
    }
    else if (xpos == 40) {
      xspeed = xspeed * (-1);
    }
  }
}

void ball() {
  fill(255);
  ellipseMode(CENTER);
  ellipse(ballX,ballY,30,30);
  ballX = ballX + speedX;
  // y movement
  if (ballY >= 0) {
    ballY = ballY + speedY;
  }
  // y bounce
  if (ballY > 500) {
    speedY = speedY * (-1);
  }
  else if (ballY == 0) {
    speedY = speedY * (-1);
  }
  // x bounce
  //if (ballX > 960) {
    //speedX = speedX * (-1);
  //}
}

void P2paddle() {
  if (arduino.digitalRead(buttonPin3) == 0) { // if the button is not pressed
    P2Y = P2Y - 5;
  } 
  else if (arduino.digitalRead(buttonPin2) == 0) { // if the button is not pressed
   P2Y = P2Y + 5;
  }
  /*
  if (P2press == true) {
    if (key == CODED) {
      if (keyCode == UP) {
        loop();
        P2Y = P2Y - 5;
      }
      else if (keyCode == DOWN) {
        P2Y = P2Y + 5;
      }
      //else {
      //  P2Y = P2Y;
      //}
    }
  }
  */
}

void P1bounce() {
  // P1 paddle bounce
  //int P1Y = mouseY - 50;
  if (ballX == 40 && ballY >= P1Y - 100 && ballY <= P1Y + 100) {
    speedX = speedX * (-1);
    ballX = ballX + speedX;
  }
}

void P2bounce() {
  // P2 paddle bounce
  if (ballX == 960 && ballY >= P2Y - 100 && ballY <= P2Y + 100) {
    speedX = speedX * (-1);
    ballX = ballX + speedX;
  }
}
  
void gameOver() {
  if (ballX <= 0) {
    speedX = 0;
    speedY = 0;
    fill(255);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("P2 WINS",500,250);
  }
  else if (ballX >= 1000) {
    speedX = 0;
    speedY = 0;
    fill(255);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("P1 WINS",500,250);
  }
}
