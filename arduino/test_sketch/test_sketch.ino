int switchPin = 2;
int heatPin = 5;
String outgoingMessage, imcomingMessage;
int val;

// Heat Plate variables
int pressure = 0;
int temperature = 1; //this is not in celsius, but I'll call it temperature anyway
int temperatureRise = 40; //same

//Bike variables
volatile long temp = 0;
volatile long duration = 0; //Laufzeit in Millisekunden
float diameter = 2000; //Raddurchmesser - Magnet
volatile float velocity = 0; // v = s/t
int velocityOut = 0;


void setup() {
  Serial.begin(9600);
  Serial.flush(); //empty serial
  pinMode(switchPin, INPUT);    // sets the digital pin as input to read switch
  pinMode(heatPin, OUTPUT);
  digitalWrite(switchPin, HIGH);
  pinMode(13,OUTPUT);
  attachInterrupt(0, iRWheel, CHANGE);
}

void loop() {

  pressure = map(analogRead(0),1023,0,0,15);  
  
  if (millis()-temp > 3000) 
  {
     velocity = 0;
  }
  
  velocityOut = int(velocity);  
  outgoingMessage = String(pressure) + "|" + String(velocityOut);

  delay(50);
  Serial.println(outgoingMessage);

    if(Serial.read() == '1') //'1' is sent when refuelling and handOnPlate
    {
       analogWrite(heatPin, temperature);
       temperature += temperatureRise;
       temperature = min(temperature, 255);
    }
    if(Serial.read() == '0') //'0' is sent when handOnPlate == false
    {
      analogWrite(heatPin, 0);
      temperature = 0;
    }
}

void iRWheel(){
  val = digitalRead(switchPin);
  Serial.print(val);
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
