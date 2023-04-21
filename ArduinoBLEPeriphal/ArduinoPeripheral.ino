
#include <ArduinoBLE.h>
// For Bluetooth
  const char* ServiceUUID = "fd4733c0-def3-11ed-b5ea-0242ac120002";
  const char* examplCharUUID = "fd4733c1-def3-11ed-b5ea-0242ac120002";
  BLEService ExBLE(ServiceUUID);
  BLECharacteristic speechText(examplCharUUID, BLEWrite, 50, false);

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  while(!Serial);

  if (!BLE.begin()) {
    Serial.println("Error: BLUETOOTH NOT STARTING");
    while(1);
  }
  Serial.println("BLE on");
  BLE.setLocalName("Text Test For App");
  BLE.setAdvertisedService(ExBLE);
  ExBLE.addCharacteristic(speechText);
  BLE.addService(ExBLE);
  BLE.advertise();
}

void loop() {
  // put your main code here, to run repeatedly:
  BLEDevice central = BLE.central();
  delay(500);
  bool prevResult = false;
  if(central) {
    Serial.println("Connected to Central");
    while(central.connected()){
      if (speechText.written()) {
        for (int i = 0; i < speechText.valueLength(); ++i) {
          Serial.print(char(speechText.value()[i]));
        }
      }
      delay(20);
    }
  }
}
