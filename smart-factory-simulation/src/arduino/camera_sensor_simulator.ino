#include <Javino.h>
#include <arduino-timer.h>
#include <time.h>
#include <stdlib.h>



Javino javino;
auto timer = timer_create_default();
char *colors[] = {"red", "green", "blue", "yellow", "black", "white"};
String cameraMeasure;

void serialEvent(){
 /*
 * The serialEvent() function handles interruptions coming from the serial port.
 * 
 * NOTE: The serialEvent() feature is not available on the Leonardo, Micro, or other ATmega32U4 based boards. 
 * https://docs.arduino.cc/built-in-examples/communication/SerialEvent 
 * 
 */
  javino.readSerial();
}

void setup() {
 javino.start(9600);
 pinMode(LED_BUILTIN ,OUTPUT);
 ledOn();
 timer.in(5000, ledOff);
 updateCameraMeasure();
 timer.every(30000, updateCameraMeasure);
 srand(time(0));   // Initialization, should only be called once.
 // cameraMeasure = getCameraMeasure();
}

void loop() {
 timer.tick();
 if(javino.availableMsg()){
  if(javino.getMsg() == "getPercepts")javino.sendMsg(getPercepts());
  else if(javino.getMsg() == "ledOn") ledOn();
  else if(javino.getMsg() == "ledOff")ledOff();
 }
}

/* It sends the exogenous environment's perceptions to the agent. */
String getPercepts(){
  String beliefs = 
    "resourceName(myArduino);"+
    getLedStatus()+
    cameraMeasure; 
            
  return beliefs;
}

String getLedStatus(){
  if(digitalRead(LED_BUILTIN)==1) return "ledStatus(on);";
  else return "ledStatus(off);";
}

String getCameraMeasure(){
  String measure = 
    getFrontLeftMeasure()+
    getFrontRightMeasure()+
    getBackLeftMeasure()+
    getBackRightMeasure();

  return measure;
}

void updateCameraMeasure(){
  String measure = 
    getFrontLeftMeasure()+
    getFrontRightMeasure()+
    getBackLeftMeasure()+
    getBackRightMeasure();

  cameraMeasure = measure;  
}

String getFrontLeftMeasure(){
  int c = rand() % 6;
  char belief[50];
  int r = 80 + (rand() % 21);
  sprintf(belief, "frontLeftMeasure(%s,%d);", colors[c], r);
  return belief;
}

String getFrontRightMeasure(){
  int c = rand() % 6;
  char belief[50];
  int r = 80 + (rand() % 21);
  sprintf(belief, "frontRightMeasure(%s,%d);", colors[c], r);
  return belief;
}

String getBackLeftMeasure(){
  int c = rand() % 6;
  char belief[50];
  int r = 80 + (rand() % 21);
  sprintf(belief, "backLeftMeasure(%s,%d);", colors[c], r);
  return belief;
}

String getBackRightMeasure(){
  int c = rand() % 6;
  char belief[50];
  int r = 80 + (rand() % 21);
  sprintf(belief, "backRightMeasure(%s,%d);", colors[c], r);
  return belief;
}


/* It implements the command to be executed in the exogenous environment. 
*
* NOTE: Every command must reflect in a function. 
*
*/
void ledOn(){
  digitalWrite(LED_BUILTIN,HIGH); 
}

/* It implements the command to be executed in the exogenous environment. */
void ledOff(){
  digitalWrite(LED_BUILTIN,LOW); 
}