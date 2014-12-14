

#include <AccelStepper.h>
#include <Servo.h> 

// Define a stepper and the pins it will use
AccelStepper longAxis(AccelStepper::FULL3WIRE, 10, 11, 12);
AccelStepper shortAxis(AccelStepper::FULL4WIRE, 3, 4, 5, 6);
Servo AlphaAxis;
int solenoidPin = 13;

boolean debugging = true;

char ch = -1;
char raw_command[8];
char buffer_to_int[7];
int argument;
int serialBuffer_size;



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
  Serial.setTimeout(2000000000); // in ms, a VERY long time! basically, wait forever to get a serial input

  delay(1000);
  if (debugging) {
    Serial.println("The contents of array buffer_to_int before using them for anything: ");
    for (int counter = 0; counter < 7; counter ++) {Serial.write(buffer_to_int[counter]); Serial.print(',');}
    Serial.println();}

  delay(5000);
  if (debugging){ Serial.println("Setup Delay Finished");}
}



void loop()
{    
  // let the computer know we are ready for a command
  Serial.println("CMD: RDY");
  
  // clear the input buffers in case the last command was longer than this command.
  for (int counter = 0; counter < 7; counter ++) {buffer_to_int[counter] = ' ';}
  for (int counter = 0; counter < 7; counter ++) {raw_command[counter] = ' ';}
  
  if (debugging){delay(1500);}
  Serial.print("BUFF: ");
  serialBuffer_size = Serial.available();
  Serial.println(serialBuffer_size);  
  
  if (debugging){delay(1500);}
  
  while(ch == -1){ // delay until the next command comes over serial. if the delay takes too long, reprint buffer size, in case the other end
  // of the connection is sitting waiting for the buffer to clear, and doesn't know the buffer size is already small enough. note that this won't work
  // if there are characters in the buffer that don't terminate with a comma.
    ch = Serial.peek(); 
  }
 
  while(ch == ' ' || ch == '\n'){ // get rid of leading spaces and new lines
    ch = Serial.read();
    if (debugging) {Serial.println("Character removed from serial buffer");}
  }
    
  Serial.readBytesUntil(',', raw_command, 8); // get the next command into an array
  
  if (debugging) {Serial.println("Next command recieved!"); Serial.print("Raw command: "); Serial.println(raw_command); }
  if (debugging){delay(1500);}
  
  buffer_to_int[0] = raw_command[1];
  buffer_to_int[1] = raw_command[2];
  buffer_to_int[2] = raw_command[3];
  buffer_to_int[3] = raw_command[4];
  buffer_to_int[4] = raw_command[5];
  buffer_to_int[5] = raw_command[6];
  buffer_to_int[6] = '\0';
  
  argument = atoi(buffer_to_int); //convert the contents of buffer to an integer
  
  if (debugging) {Serial.print("filtered Value: "); Serial.println(argument);}
  
  // now, execute the current statement
  if (raw_command[0] == 'X') {
    if (debugging){ delay(1000); Serial.println("Moving Long Axis");}
    longAxis.runToNewPosition(argument);}
  else if (raw_command[0] == 'Y') {
    if (debugging){ delay(1000); Serial.println("Moving Short Axis");}
    shortAxis.runToNewPosition(argument);}
  else if (raw_command[0] == 'Z') {
    if (argument == 0){
      if (debugging){ delay(1000); Serial.println("Solenoid Down!");}
      solenoidDown();
    }
    else{
      if (debugging){ delay(1000); Serial.println("Solenoid Up!");}
      solenoidUp();
    }
  } 
  else if (raw_command[0] == 'A') {
    if (debugging){ delay(1000); Serial.println("Twisting Alpha Axis");}
    AlphaAxis.write(argument);
  }
  else { 
    Serial.println("ERROR!! Bad command recieved. No failsafe built in. No idea what will happen"); }
  
  if (debugging) {delay(1000);}
}
    
  
  
  
void solenoidDown() {
  delay(1000);
  digitalWrite(solenoidPin, LOW);
  delay(1000);
}

void solenoidUp() {
  delay(1000);
  digitalWrite(solenoidPin, HIGH);
  delay(3000); // yes, 3000, this is not a typo. this is also not symetric to down. it has to do with not having enough power to raise it forcefully.
}
