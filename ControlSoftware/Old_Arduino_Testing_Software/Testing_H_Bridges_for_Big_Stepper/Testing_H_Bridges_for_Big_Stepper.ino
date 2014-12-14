// http://homepage.cs.uiowa.edu/~jones/step/types.html


int state;

//  Terminal 1  +++---+++---
//  Terminal 2  --+++---+++-
//  Terminal 3  +---+++---++

int terminal_1 = 10;
int terminal_2 = 11;
int terminal_3 = 12;

int speed_inverse = 2;

void setup(){
  pinMode(terminal_1, OUTPUT);
  pinMode(terminal_2, OUTPUT);
  pinMode(terminal_3, OUTPUT); 
  
  // state 1. so the loop starts in the right place.
  digitalWrite(terminal_1, LOW);
  digitalWrite(terminal_2, LOW);
  digitalWrite(terminal_3, LOW);
  
  Serial.begin(9600);
 
  state = 1;
}



void loop(){
  // all highs and lows are inverted because of the darlington inverters!!
  // pulse one
  
  Serial.println("Going Direction 1!");
  for (int counter = 0; counter < 50; counter ++) {
  take_step(1);
  delay(speed_inverse);
  }
  for (int counter = 0; counter < 1950; counter ++) {
  take_step(1);
  delayMicroseconds(1500);
  }
  /*
  for (int counter = 0; counter < 1900; counter ++) {
  take_step(1);
  delayMicroseconds(1000);
  }
  */
  
  delay(1000);
  
  Serial.println("Going Direction 2!");
  for (int counter = 0; counter < 2000; counter ++) {
  take_step(0);
  delay(speed_inverse);
  }
  
  delay (1000);

  
  /*
  digitalWrite(terminal_1, HIGH);
  delay(speed_inverse);
  digitalWrite(terminal_1, LOW);
  digitalWrite(terminal_2, HIGH);
  delay(speed_inverse);
  digitalWrite(terminal_2, LOW);
    digitalWrite(terminal_3, HIGH);
  delay(speed_inverse);
  digitalWrite(terminal_3, LOW);
  */
  
  /*
  digitalWrite(10, state);
  state = ~state;
  delay(500);
  */
}

void take_step(int my_direction)
{
  if (my_direction == 0) { state ++;} else { state --;}
  if (state < 0){state = 5;}
  if (state > 5){state = 0;}
  
  switch (state) {
    case 0:
      digitalWrite(terminal_1, LOW);
      break;
    case 1:
      digitalWrite(terminal_3, HIGH);
      break;
    case 2:
      digitalWrite(terminal_2, LOW);
      break;
    case 3:
      digitalWrite(terminal_1, HIGH);
      break;
    case 4:
      digitalWrite(terminal_3, LOW);
      break;
    case 5:
      digitalWrite(terminal_2, HIGH);
      break;
    default:
      Serial.println("ERROR");
      break;
  }
  
}

