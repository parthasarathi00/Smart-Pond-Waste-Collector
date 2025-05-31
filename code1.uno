#include <LiquidCrystal_I2C.h>

// LCD setup for 16x2, address 0x3f
LiquidCrystal_I2C lcd(0x3f, 16, 2);

char t;  // variable to store serial input char

int sensorPin = A0;  // turbidity sensor input pin

void setup() {
  // Serial and LCD setup
  Serial.begin(9600);
  lcd.begin();
  
  // Pins for serial command outputs
  pinMode(13, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(10, OUTPUT);
  
  // Pins for turbidity output indicators
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);

  lcd.clear();
  lcd.print("System Starting");
  delay(2000);
}

void loop() {
  // Read serial input and store it in t
  if (Serial.available()) {
    t = Serial.read();
    Serial.println(t);
  }

  // Control digital pins based on serial commands
  if (t == 'A') {
    digitalWrite(13, HIGH);
    digitalWrite(11, HIGH);
  } 
  else if (t == 'B') {
    digitalWrite(12, HIGH);
    digitalWrite(10, HIGH);
  } 
  else if (t == '1') {
    digitalWrite(11, HIGH);
  } 
  else if (t == '2') {
    digitalWrite(13, HIGH);
  } 
  else if (t == 'S') {
    digitalWrite(13, LOW);
    digitalWrite(12, LOW);
    digitalWrite(11, LOW);
    digitalWrite(10, LOW);
  }

  // Read turbidity sensor and map value
  int sensorValue = analogRead(sensorPin);
  int turbidity = map(sensorValue, 0, 640, 100, 0);  // Inverse mapping
  
  lcd.setCursor(0, 0);
  lcd.print("Turbidity:     ");
  lcd.setCursor(10, 0);
  lcd.print(turbidity);
  
  // Display water clarity and set LEDs
  if (turbidity < 20) {
    digitalWrite(7, HIGH);
    digitalWrite(8, LOW);
    digitalWrite(9, LOW);
    lcd.setCursor(0, 1);
    lcd.print("  It's CLEAR  ");
  } 
  else if (turbidity >= 20 && turbidity < 50) {
    digitalWrite(7, LOW);
    digitalWrite(8, HIGH);
    digitalWrite(9, LOW);
    lcd.setCursor(0, 1);
    lcd.print("  It's CLOUDY ");
  } 
  else if (turbidity >= 50) {
    digitalWrite(7, LOW);
    digitalWrite(8, LOW);
    digitalWrite(9, HIGH);
    lcd.setCursor(0, 1);
    lcd.print("  It's DIRTY  ");
  }

  delay(200);
}
