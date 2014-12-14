


#include <Custom_stepper.h>

Stepper_Motor my_stepper(200, 8,9,10,11,2); // steps_per_rev, the four pins, the timer number.

int solenoid_button_pin = 4;
int solenoid_control_pin = 6;

void setup()
{
  my_stepper.initialize(); // set up all the timer stuff.
  my_stepper.set_RPM_range(6); // this is the default anyway, and it is good for speeds ~40 - 250 (and CAN go much
  // further in either direction). only play with this if you want really slow or really high speeds. It only affects
  // the accuracy of the timer at the given range, not the speed itself.
  my_stepper.set_speed(1); // RPMs 
  Serial.begin(9600);
  pinMode(solenoid_control_pin, OUTPUT);
  delay(1000);
}

int motor_speed_raw_read;
boolean solenoid_button_state;
void loop()
{
  motor_speed_raw_read = analogRead(0);
  if ((motor_speed_raw_read > 400) && (motor_speed_raw_read < 600)) { // stop rotation
    my_stepper.stop_rotation();}
  else { // we want to be moving
    if (my_stepper.is_spinning() < 1000) { // make sure the stepper has sufficient steps left
      my_stepper.add_steps(2000); }
  }
  
  if (motor_speed_raw_read < 400) { my_stepper.set_direction(true);} // move one direction 
  if (motor_speed_raw_read > 600) { my_stepper.set_direction(false);} // move the other direction 
   
  if ((motor_speed_raw_read < 400) && (motor_speed_raw_read > 300)) {my_stepper.set_speed(40); } // pick speed range
  else if ((motor_speed_raw_read < 300) && (motor_speed_raw_read > 200)) {my_stepper.set_speed(20); }
  else if ((motor_speed_raw_read < 200) && (motor_speed_raw_read > 100)) {my_stepper.set_speed(100); }
  else if (motor_speed_raw_read < 100) {my_stepper.set_speed(100); }
  else if ((motor_speed_raw_read > 600) && (motor_speed_raw_read < 700)) {my_stepper.set_speed(40); }
  else if ((motor_speed_raw_read > 700) && (motor_speed_raw_read < 800)) {my_stepper.set_speed(20); }
  else if ((motor_speed_raw_read > 800) && (motor_speed_raw_read < 900)) {my_stepper.set_speed(100); }
  else if (motor_speed_raw_read > 900) {my_stepper.set_speed(100); }
  
  solenoid_button_state = digitalRead(solenoid_button_pin);
  Serial.println(solenoid_button_state);
  digitalWrite(solenoid_control_pin, solenoid_button_state);
              


  delay(100);
}


// This exists because I haven't played around with having interrupt routines inside a class yet.
// ideally this function would take place behind the scenes- then the methods (and variables)
// used by it could be private, since you really should never mess with them.
// For now, just copy and paste it and include it with any code that uses this library. change the
// timer based on which one you are using.
ISR(TIMER2_OVF_vect) {
  /* Reload the timer */
  TCNT2 = my_stepper.timer_preload;
  my_stepper.take_step();
}

