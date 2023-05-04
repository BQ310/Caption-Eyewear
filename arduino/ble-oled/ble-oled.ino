// Brian Quach
// takes input from serial monitor and outputs to oled
#include <ArduinoBLE.h>
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define BUF_SIZE 256
#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

#define OLED_RESET -1       // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

const char *ServiceUUID = "fd4733c0-def3-11ed-b5ea-0242ac120002";
const char *examplCharUUID = "fd4733c1-def3-11ed-b5ea-0242ac120002";
BLEService ExBLE(ServiceUUID);
BLECharacteristic speechText(examplCharUUID, BLEWrite, 50, false);

void setup()
{
  Serial.begin(9600);
  // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
  if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS))
  {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;)
      ; // Don't proceed, loop forever
  }

  if (!BLE.begin())
  {
    Serial.println("Error: BLUETOOTH NOT STARTING");
    while (1)
      ;
  }
  Serial.println("BLE on");
  BLE.setLocalName("Text Test For App");
  BLE.setAdvertisedService(ExBLE);
  ExBLE.addCharacteristic(speechText);
  BLE.addService(ExBLE);
  BLE.advertise();

  // Show initial display buffer contents on the screen --
  // the library initializes this with an Adafruit splash screen.
  display.display();
  delay(2000);                         // Pause for 2 seconds
  display.setTextSize(1);              // Normal 1:1 pixel scale
  display.setTextColor(SSD1306_WHITE); // Draw white text
  display.cp437(true);
}

void loop()
{
  char buf[BUF_SIZE];
  int counter = 0;
  BLEDevice central = BLE.central();
  delay(500);
  bool prevResult = false;
  if (central)
  {
    Serial.println("Connected to Central");
    while (central.connected())
    {
      if (speechText.written())
      {

        if (counter > BUF_SIZE - 100)
        {
          counter = 0;
        }

        for (int i = 0; i < speechText.valueLength(); i++)
        {
          buf[counter] = (char(speechText.value()[i]));
          counter++;
        }
        Serial.println(counter);
        writeBuf(buf, counter);

        // writeStringBLE();
      }
      delay(20);
    }
  }
}

// writes
void writeStringBLE(void)
{
  display.clearDisplay();
  display.setCursor(0, 0); // Start at top-left corner
  for (int i = 0; i < speechText.valueLength(); i++)
  {
    display.write(char(speechText.value()[i]));
  }
  display.display();
  delay(500);
}

void testdrawchar(void)
{
  display.clearDisplay();

  display.setTextSize(1);              // Normal 1:1 pixel scale
  display.setTextColor(SSD1306_WHITE); // Draw white text
  display.setCursor(0, 0);             // Start at top-left corner
  display.cp437(true);                 // Use full 256 char 'Code Page 437' font

  // Not all the characters will fit on the display. This is normal.
  // Library will draw what it can and the rest will be clipped.
  for (int16_t i = 0; i < 256; i++)
  {
    if (i == '\n')
      display.write(' ');
    else
      display.write(i);
  }

  display.display();
  delay(2000);
}

void writeString(String s)
{
  display.setCursor(0, 0); // Start at top-left corner
  display.clearDisplay();
  for (int i = 0; i < s.length(); i++)
  {
    display.write(s[i]);
  }
  display.display();
  delay(2000);
}

void writeBuf(char *buf, int length)
{
  display.clearDisplay();
  display.setCursor(0, 0); // Start at top-left corner
  for (int i = 0; i < length; i++)
  {
    display.write(buf[i]);
  }
  display.display();
  delay(500);
}
