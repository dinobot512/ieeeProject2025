const int A_PIN = 2;
const int B_PIN = 3;
bool enable = true;  // set true to start cycling

void setup() {
  // Initialize serial for output
  Serial.begin(9600); 
  while (!Serial) {
    ; // wait for serial port to be ready (optional)
  }

  pinMode(A_PIN, OUTPUT);
  pinMode(B_PIN, OUTPUT);
  digitalWrite(A_PIN, LOW);
  digitalWrite(B_PIN, LOW);
  Serial.println("Starting half-adder test...");
}

void loop() {
  if (enable) {
    digitalWrite(A_PIN, LOW);
    digitalWrite(B_PIN, LOW);
    Serial.println("A=0, B=0");
    delay(1000);

    digitalWrite(A_PIN, HIGH);
    digitalWrite(B_PIN, LOW);
    Serial.println("A=1, B=0");
    delay(1000);

    digitalWrite(A_PIN, LOW);
    digitalWrite(B_PIN, HIGH);
    Serial.println("A=0, B=1");
    delay(1000);

    digitalWrite(A_PIN, HIGH);
    digitalWrite(B_PIN, HIGH);
    Serial.println("A=1, B=1");
    delay(1000);
  }
}

