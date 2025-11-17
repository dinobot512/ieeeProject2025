// Pin assignments
const int B3_PIN = 2;
const int B2_PIN = 3;
const int B1_PIN = 4;
const int B0_PIN = 5;
const int A3_PIN = 6;
const int A2_PIN = 7;
const int A1_PIN = 8;
const int A0_PIN = 9;
const int OP_PIN = 10;
const int C0_PIN = 14;
const int C1_PIN = 15;
const int C2_PIN = 16;
const int C3_PIN = 17;

void setup() {
  Serial.begin(9600);

  // A outputs
  pinMode(A0_PIN, OUTPUT);
  pinMode(A1_PIN, OUTPUT);
  pinMode(A2_PIN, OUTPUT);
  pinMode(A3_PIN, OUTPUT);

  // B outputs
  pinMode(B0_PIN, OUTPUT);
  pinMode(B1_PIN, OUTPUT);
  pinMode(B2_PIN, OUTPUT);
  pinMode(B3_PIN, OUTPUT);

  // OP output
  pinMode(OP_PIN, OUTPUT);

  // C inputs
  pinMode(C0_PIN, INPUT);
  pinMode(C1_PIN, INPUT);
  pinMode(C2_PIN, INPUT);
  pinMode(C3_PIN, INPUT);

  Serial.println("Ready. Commands:");
  Serial.println("  A <num>");
  Serial.println("  B <num>");
  Serial.println("  OP <0|1>");
  Serial.println("  READ");
}

// Write a 4-bit value to 4 pins
void write4bit(int value, const int pins[4]) {
  value &= 0xF;  // force to 0–15
  for (int i = 0; i < 4; i++) {
    digitalWrite(pins[i], (value >> i) & 1);
  }
}

// Read a 4-bit value from 4 pins
int read4bit(const int pins[4]) {
  int val = 0;
  for (int i = 0; i < 4; i++) {
    val |= (digitalRead(pins[i]) << i);
  }
  return val;
}

// Pin groups for convenience
const int A_PINS[4] = {A0_PIN, A1_PIN, A2_PIN, A3_PIN};
const int B_PINS[4] = {B0_PIN, B1_PIN, B2_PIN, B3_PIN};
const int C_PINS[4] = {C0_PIN, C1_PIN, C2_PIN, C3_PIN};

void loop() {
  if (!Serial.available()) return;

  String cmd = Serial.readStringUntil('\n');
  cmd.trim();

  // SPLIT COMMAND INTO PARTS
  int spaceIndex = cmd.indexOf(' ');
  String label = (spaceIndex == -1) ? cmd : cmd.substring(0, spaceIndex);
  String valueStr = (spaceIndex == -1) ? "" : cmd.substring(spaceIndex + 1);
  int value = valueStr.toInt();

  label.toUpperCase();

  // ==== COMMAND: SET A ====
  if (label == "A") {
    write4bit(value, A_PINS);
    Serial.print("Set A = ");
    Serial.println(value & 0xF);
  }

  // ==== COMMAND: SET B ====
  else if (label == "B") {
    write4bit(value, B_PINS);
    Serial.print("Set B = ");
    Serial.println(value & 0xF);
  }

  // ==== COMMAND: SET OP ====
  else if (label == "OP") {
    digitalWrite(OP_PIN, (value != 0));
    Serial.print("Set OP = ");
    Serial.println(value != 0);
  }

  // ==== COMMAND: READ ====
  else if (label == "READ") {
    int cVal = read4bit(C_PINS);
    Serial.print("C = ");
    Serial.print(cVal);
    Serial.print(" (binary ");
    Serial.print((cVal >> 3) & 1);
    Serial.print((cVal >> 2) & 1);
    Serial.print((cVal >> 1) & 1);
    Serial.print((cVal) & 1);
    Serial.println(")");
  }

  else {
    Serial.println("Unknown command.");
  }
}

