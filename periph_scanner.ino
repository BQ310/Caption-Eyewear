/*
Brian Quach
BLE peripheral scanner for arduino nano 33 ble
*/
#include <ArduinoBLE.h>

void setup() {
  Serial.begin(9600);
  while (!Serial);

  if (!BLE.begin()) {
    Serial.println("bluetooth failed to start.");
    while (true);
  }

  Serial.println("bluetooth periphal scanner");

  BLE.scan();
}

void loop() {
  BLEDevice peripheral = BLE.available();
  if (peripheral) {
    Serial.println("Peripheral found");
    Serial.print(peripheral.localName());
  }

  if (peripheral.localName() != "phone") {
    BLE.disconnect();
  } else {
    BLE.stopScan();
  }
}
