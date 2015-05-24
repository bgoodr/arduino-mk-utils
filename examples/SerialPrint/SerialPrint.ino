// -*-mode: c++; indent-tabs-mode: nil; -*-

void setup() {
  Serial.begin(9600);
  Serial.print("Press any key: ");
}

void loop() {
  if (Serial.available()) {
    Serial.println(Serial.read());
  }
}
