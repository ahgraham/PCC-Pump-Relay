# MATLAB-Arduino Pump Relay
**Note:** This is an extension of the pump relay project found [here](https://github.com/ProfessorKazarinoff/MATLAB-pump-relay).

This is a student project for ENGR114 at Portland Community College. Using MATLAB and an Arduino connected over serial, we will switch on and off a pump using a relay. Expanding upon the previous work done, we will do two things: record the state of the pump on ThingSpeak, and pull from another groups' connected pH sensor to turn the pump on and off. There will be a user side script to override the pump (for a certain time period), as well as provide a visual plot of the pump's state over time.

## Problem Statement
We will create a user input controlled pump. This will be controlled through the cloud (client ThingSpeak) via the command line in MATLAB, which will be accessed by the server computer at the fish tank. The server side program will keep the pump on or off, according to data read from the pH sensor group. If there is an override recorded on the thingspeak server, it will: read the override, act on it, and set the override status on thingspeak back to its initial state. On the user side, there will be a script that will get the current pump state and allow the user to update the ThingSpeak override field. The override field takes the input on/off and the duration (in hours) that the user would like that state to be active.


## Hardware Setup

### Bill of Materials
|component|vendor|
|---|---|
|Arduino|[SparkFun RedBoard - Programmed with Arduino](https://www.sparkfun.com/products/13975)|
|Relay|[SparkFun Beefcake Relay Control Kit (Ver. 2.0)](https://www.sparkfun.com/products/13815)|
|Jumper wires|[Jumper Wires Premium 6" M/M Pack of 10](https://www.sparkfun.com/products/8431 )|
|Mini-B USB cable|[SparkFun USB Mini-B Cable - 6 Foot](https://www.sparkfun.com/products/11301)|
|Enclosure|[Big Red Box - Enclosure](https://www.sparkfun.com/products/11366)|
|extension cord male end|Recieved from PCC Engineering Lab|
|extension cord female end|Recieved from PCC Engineering Lab|
|zip ties for strain relief|Recieved from PCC Engineering Lab|
|Wire Nuts|Recieved from PCC Engineering Lab|
|Standoffs|[Black Nylon Screw and Stand-off Set – M2.5 Thread](https://www.adafruit.com/product/3299)|

### Assembly of Pump Relay Components :

![Alt text](/doc/fritzing_pump_relay.jpg?raw=true "Fritzing Connection Diagram")

**Step 1:** Lay out all the components on the relay board following the instruction from 
https://learn.sparkfun.com/tutorials/beefcake-relay-control-hookup-guide?_ga=2.126438346.678827907.1495830299-657127905.1456517273
and solder all components in place. 

![Alt text](/doc/top_view.jpg?raw=true "Birds Eye View - Connection")


**Step 2:** Make two holes on either end for the power cord. Also cut out two access holes for the USB and adapter cables.

![Alt text](/doc/pump-relay2.jpg?raw=true "Connection")

**Step 3:** Install the power cables . Connect the two white (neutral) wires together and the two green (ground) wires together with wire nuts. Then feed the two black (hot) wires into the blue terminal block (high voltage side) of the relay into the two right-hand most slots (order depends on the code order, but CO - common and NO - normally open are the best options).

![Alt text](/doc/pump-relay3.jpg?raw=true "Relay Connection")

**Step 4:** Connect the low voltage jumper wires between the Arduino and relay (low voltage side) as shown in the birds eye view: 5V to 5V, GND to GND and CTRL to Pin13.

**Step 5:** Tuck in all loose wires and create a loop in the power cord and secure with zip ties to provide strain relief.

![Alt text](/doc/top_view.jpg?raw=true "Birds Eye View - Connection")

The red jumper wire (in the picture, not diagram) is the wire that is providing 5 volts to the relay (low voltage side).  When the relay is “off” it is switched in the position that connects the circuit to the red wire.  This black jumper wire completes the circuit by grounding the connection.  When the relay is switched on, the power is sent out the relay via the yellow jumper wire, which comes from pin 13 on the Arduino.  The relay is also in the circuit of the extension cord.  When the relay is open, the two parts of the electrical cord are not connected, so the power is not supplied to the water pump.  When the relay is turned on, the block (hot) wires are connected which completes the electrical circuit in the electrical cord.  This supplies power to the pump, turning it on.  The Arduino board is just supplying a low voltage "signal" to the relay, which is what turns the extension cord “on” and “off”.

## Arduino Code

The [arduino-code.ino](arduino-code.ino) sketch was uploaded on the Arduino using the Arduino IDE.

## MATLAB Code

The [matlab.m](matlab.m) script is run on MATLAB, on the server computer (connected to the arduino and always on).
The [relay_user_input_override.m](relay_user_input_override.m) script is run on the user's computer, to override the pump state or get a visual representation of the pump state.

## Results
This is a view of the user side script that plots the pump's state. 0 is off override, 1 is on override, 2 is no override. 

![Alt text](/doc/results.jpg?raw=true)

## Future Work
Future groups could improve on this project in three simple ways: 
1) Guarantee minimum pump run time to water plants
2) Add in temperature sensor data to make better decisions
3) Hook up an arduino wireless shield to eliminate the need for a server computer