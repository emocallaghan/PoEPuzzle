

#include <AccelStepper.h>
#include <Servo.h> 

// Define a stepper and the pins it will use
AccelStepper longAxis(AccelStepper::FULL3WIRE, 10, 11, 12);
AccelStepper shortAxis(AccelStepper::FULL4WIRE, 3, 4, 5, 6);
Servo AlphaAxis;

int solenoidPin = 13;

void setup()
{  
  pinMode(solenoidPin, OUTPUT);
  
  AlphaAxis.attach(9);
  
    longAxis.setMaxSpeed(450.0);
    longAxis.setAcceleration(450.0);
    shortAxis.setMaxSpeed(500.0);
    shortAxis.setAcceleration(200.0);
    // speed tests
    // short axis, one motor driving, only one motor on the rod: max speed 600, max accel: 350, consistently working. Speeds up to 800 occasionally work.
    // short axis, one motor driving, both on axis, max speed 300, axel still 350 (accel not played with), still losing some steps at the end
    // short axis, two motors drivinig. max speed 600, max accel 200 (can probably be raised), very consistent. Occasionally loses steps at the VERY edges- outside of usable operation space.

    // max travels: short axis 12000
    // long axis: more than 10000
  Serial.begin(9600);

    delay(3000);
    Serial.println("Setup Delay Finished");
}

void loop()
{    
    
    // test short axis, exaustive.
    /*
    shortAxis.runToNewPosition(12000);
    delay(1000);
    shortAxis.runToNewPosition(0);
    delay(1000);
    shortAxis.runToNewPosition(3000);
    delay(1000);
    shortAxis.runToNewPosition(6000);
    delay(1000);
    shortAxis.runToNewPosition(0);
    delay(1000);
    shortAxis.runToNewPosition(9000);
    delay(1000);
    shortAxis.runToNewPosition(3000);
    delay(1000);
    shortAxis.runToNewPosition(6000);
    delay(1000);
    shortAxis.runToNewPosition(0);
    delay(1000);
    */
    
    // raise solenoid head for motion
    digitalWrite(solenoidPin, HIGH);
    
    // test long axis, down and back. disabled for now because the shaft is slipping.
    longAxis.runToNewPosition(11500);
    delay(1000);
    //longAxis.runToNewPosition(0);
    //delay(1000);
    
    
    
    
    // short axis, down and back
    shortAxis.runToNewPosition(11500);
    delay(1000);
    AlphaAxis.write(0);
    delay(1000);
    
    digitalWrite(solenoidPin, LOW);
    delay(3000);
    digitalWrite(solenoidPin, HIGH);
    delay(2500);
    
    longAxis.runToNewPosition(0);
    delay(1000);
    
    shortAxis.runToNewPosition(0);
    delay(1000);
    
    // servo, twist and back
    AlphaAxis.write(180);
    delay(1000);
    

    
    // Solenoid down, loop finished
    digitalWrite(solenoidPin, LOW);
    delay(5000);
    
    
    
}
