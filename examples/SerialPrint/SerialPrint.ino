void setup() {
	// initialize the digital pin as an output.
	// Pin 13 has an LED connected on most Arduino boards:
	pinMode(13, OUTPUT);     

	Serial.begin(9600);
	Serial.print("Press any key: ");
}

void loop() {
	// digitalWrite(13, HIGH);   // set the LED on
	// delay(1000);              // wait for a second
	// digitalWrite(13, LOW);    // set the LED off
	// delay(1000);              // wait for a second
	if (Serial.available()) {
		Serial.println(Serial.read());
	}
}
