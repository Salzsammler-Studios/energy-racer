int pressure = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  pressure = map(analogRead(0),1023,0,0,15);  
  if(pressure >= 4)
  {
    Serial.println("HelloGodot");
  }
}
