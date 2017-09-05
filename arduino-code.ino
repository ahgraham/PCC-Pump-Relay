const int relayPin = 13; // initialize relay pin value
int state = 0; // initialize initial state of relay as open/pump off

void setup()
{
  pinMode(relayPin, OUTPUT); // set relay pin mode to output
  Serial.begin(9600); // open serial port at 9600 baud
}


void loop() // begin loop
{
  Serial.print(state); // output state value to serial output
  while (Serial.available() == 0) {}  // wait for serial input
    state= Serial.parseInt(); // accept serial input to state variable
    if (state == 1) {
      digitalWrite(relayPin, HIGH); // state==1, turn pump on
    }
    if (state == 0) {
      digitalWrite(relayPin, LOW); // state==0, turn pump off
    }
}
