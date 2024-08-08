int pressure = 0;
int heatPin = 5;
volatile long temp = 0;
volatile long duration = 0;
int temperature = 1;
int temperatureRise = 2;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(heatPin, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  pressure = map(analogRead(0),1023,0,0,15);  
  if(pressure >= 5)
  {
    Serial.println("HelloGodot");
  }
  
  if(Serial.read() == '1')
  {
    analogWrite(heatPin, temperature);
    temperature += temperatureRise;
  }
  if(Serial.read() == '0')
  {
    analogWrite(heatPin, 0);
    temperature = 0;
  }
}
