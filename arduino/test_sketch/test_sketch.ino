int switchPin = 2;
int heatPin = 5;

// Heat Plate variables
int pressure = 0;
int temperature = 1; //this is not in celsius, but I'll call it temperature anyway
int temperatureRise = 20; //same

//Bike variables
volatile long temp = 0;
volatile long duration = 0; //Laufzeit in Millisekunden
float diameter = 2000; //Raddurchmesser - Magnet
volatile float velocity = 0; // v = s/t
int velocityOut = 0;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(heatPin, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  pressure = map(analogRead(0),1023,0,0,15);  
  if(pressure >= 4)
  {
    Serial.println("HelloGodot"); //Godot 'answers' by setting handOnPlate == true
  }
  
  if(Serial.read() == '1') //'1' is send when refuelling and handOnPlate
  {
     analogWrite(heatPin, temperature);
     temperature += temperatureRise;
  }
  if(Serial.read() == '0') //'0' is send when handOnPlate == false
  {
    analogWrite(heatPin, 0);
    temperature = 0;
  }
}
