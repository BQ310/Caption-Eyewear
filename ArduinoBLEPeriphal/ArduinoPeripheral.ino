#include <ArduinoBLE.h>
// For Bluetooth
  const char* ServiceUUID = "fd4733c0-def3-11ed-b5ea-0242ac120002";
  const char* SpeechTextCharUUID = "fd4733c1-def3-11ed-b5ea-0242ac120002";
  const char* TextAlignmentCharUUID = "fd4733c2-def3-11ed-b5ea-0242ac120002";
  const char* TextSpeedCharUUID = "fd4733c3-def3-11ed-b5ea-0242ac120002";
  BLEService ExBLE(ServiceUUID);
  BLECharacteristic speechText(SpeechTextCharUUID, BLEWrite, 50, false);
  BLEBoolCharacteristic textAlignment(TextAlignmentCharUUID, BLEWrite);  // false:  Upper 3 rows,   True:  Lower 3 rows
  BLEBoolCharacteristic textSpeed(TextSpeedCharUUID, BLEWrite); // false: Normal   True: Slow
void setup() {
  // put your setup code here, to run once:

  Serial.begin(115200);
  while(!Serial); // remove this if you want to run without serial

  if (!BLE.begin()) {
    Serial.println("Error: BLUETOOTH NOT STARTING");
    while(1);
  }
  Serial.println("BLE on");
  BLE.setLocalName("Text Test For App");
  BLE.setAdvertisedService(ExBLE);
  ExBLE.addCharacteristic(speechText);
  ExBLE.addCharacteristic(textAlignment);
  ExBLE.addCharacteristic(textSpeed);
  BLE.addService(ExBLE);
  BLE.advertise();
}

void loop() {
  // put your main code here, to run repeatedly:
  BLEDevice central = BLE.central();
  delay(500);
  if(central) {
    Serial.println("Connected to Central");
    while(central.connected()){

      /*Text Alignment for screen*/
      if (textAlignment.written()) {
        if (textAlignment.value() == true) {
          // Do Something here
          Serial.println("Text Alignment lower three rows.");
        } else {
          // Do Something here
          Serial.println("Text Alignment upper three rows.");
        }
      }


      /*Text Speed for screen*/
      if (textSpeed.written()) {
        if (textSpeed.value() == true) {
          // Do Something here
          Serial.println("Text Speed Char Slow");
        } else {
          // Do Something here
          Serial.println("Text Speed Char Normal");
        }
      }
      
      /*Speech to text from phone */ 
      if (speechText.written()) {
        for (int i = 0; i < speechText.valueLength(); ++i) {
          Serial.print(char(speechText.value()[i]));
        }
      }
      delay(20);
    }
  }
}
