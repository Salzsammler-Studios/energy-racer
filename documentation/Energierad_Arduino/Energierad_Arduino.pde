int switchPin = 2;     // Switch connected to digital pin 2
int heatPin = 5;
int val;
volatile long temp = 0;
volatile long duration = 0; //Laufzeit in Millisekunden
float diameter = 2000; //Raddurchmesser - Magnet
volatile float velocity = 0; // v = s/t
int velocityOut = 0;
int incomingByte, outgoingByte;
int pressure = 0;

void setup() {
  Serial.begin(1200);           // set up Serial library at 9600 bps
  pinMode(switchPin, INPUT);    // sets the digital pin as input to read switch
  pinMode(heatPin, OUTPUT);
  digitalWrite(switchPin, HIGH);
  pinMode(13,OUTPUT);
  attachInterrupt(0, iRWheel, CHANGE);
}

void loop() {
   pressure = map(analogRead(0),1023,0,0,15);  

   if (millis()-temp > 3000) {
     velocity = 0;
   }
   
   velocityOut = int(velocity);  
   outgoingByte = (pressure << 4) | velocityOut;
   
   Serial.print(outgoingByte, BYTE);
  
   if (Serial.available() > 0){
     incomingByte = Serial.read();
     analogWrite(heatPin, incomingByte);
   }
}

void iRWheel(){
  val = digitalRead(switchPin);
  if (val==HIGH){  
    digitalWrite(13,LOW);
    temp = millis();
  }
  if (val==LOW) { 
    digitalWrite(13,HIGH);
    duration = millis()-temp;
    velocity = diameter / duration;
    velocity = min(15,velocity);
  }  
}
