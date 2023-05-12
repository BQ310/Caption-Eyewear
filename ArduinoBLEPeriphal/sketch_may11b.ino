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
#define FAST 200
#define SLOW 500
#define TOP 0
#define BOTTOM 40
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// For Bluetooth
  const char* ServiceUUID = "fd4733c0-def3-11ed-b5ea-0242ac120002";
  const char* SpeechTextCharUUID = "fd4733c1-def3-11ed-b5ea-0242ac120002";
  const char* TextAlignmentCharUUID = "fd4733c2-def3-11ed-b5ea-0242ac120002";
  BLEService ExBLE(ServiceUUID);
  BLECharacteristic speechText(SpeechTextCharUUID, BLEWrite, 100, false);
  BLEBoolCharacteristic textAlignment(TextAlignmentCharUUID, BLEWrite);  // false:  Upper 3 rows,   True:  Lower 3 rows


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

  if (!BLE.begin()) {
    Serial.println("Error: BLUETOOTH NOT STARTING");
    while(1);
  }
  Serial.println("BLE on");
  BLE.setLocalName("Glasses: Device");
  BLE.setAdvertisedService(ExBLE);
  ExBLE.addCharacteristic(speechText);
  ExBLE.addCharacteristic(textAlignment);
  BLE.addService(ExBLE);
  BLE.advertise();

  // Show initial display buffer contents on the screen --
  // the library initializes this with an Adafruit splash screen.
  display.display();
  delay(2000);                         // Pause for 2 seconds
  display.setTextSize(1);              // Normal 1:1 pixel scale
  display.setTextColor(WHITE); // Draw white text
  display.display();

}

int speedText = FAST;  //  500 slow    200 fast
int cursorPlacement = 0; // Initial is top
void loop()
{
  BLEDevice central = BLE.central();
  delay(500);

  if(central) {
    Serial.println("Connected to Central");
    while(central.connected()){

      /*Text Alignment for screen*/
      if (textAlignment.written()) {
        if (textAlignment.value() == true) {
          // Do Something here
          cursorPlacement = BOTTOM;
          Serial.println("Text Alignment lower three rows.");
        } else {
          // Do Something here
          cursorPlacement = TOP;
          Serial.println("Text Alignment upper three rows.");
        }
        
        if (!speechText.written()) {
          writeBuf(speechText.value(), speechText.valueLength());
        }
      }
      
      /*Speech to text from phone */ 
      if (speechText.written()) {
        writeBuf(speechText.value(), speechText.valueLength());
      }
      delay(20);
    }
  }
}



// Writes
// void writeBuf(const unsigned char *buffer, unsigned int length)
// {
//   display.clearDisplay();
//   Serial.println("Heu");
//   display.setCursor(0, cursorPlacement); // Start at top-left corner
//   int nextLine = cursorPlacement;
//   int screenWidth = 128; // Width of your OLED screen
//   char currentLine[screenWidth/6 + 1]; // Current line of text being constructed (plus one for null termination)
//   int currentLineLength = 0; // Length of the current line of text
  
//   for (unsigned int i = 0; i != length; i++) {
//     char currentChar = buffer[i];

//     if (currentChar == ' ') {
//       currentLine[currentLineLength++] = ' ';
//       currentLine[currentLineLength] = '\0';
//       int lineWidth = currentLineLength * 6;
//       int wordLength = 0;
//       for (int j = i + 1; buffer[j] != ' ' && buffer[j] != '\0'; j++) {
//         wordLength++;
//       }
//       int wordWidth = (wordLength + 1) * 6;

//       if (lineWidth + wordWidth <= SCREEN_WIDTH) {
//         // Do nothing, continue adding characters to the current line
//       } else {
//         // Output the current line to the OLED screen
//         display.println(currentLine);
//         display.display(); // Show the updated display
//         currentLine[0] = '\0';
//         currentLineLength = 0;
//         nextLine += 7;
//         display.setCursor(0,nextLine); // Move the cursor to the next line
//       }
//     } else {
//       currentLine[currentLineLength++] = currentChar;
//       currentLine[currentLineLength] = '\0';
//     }
//   }
//   display.println(currentLine);
//   display.display(); // Show the updated display
// }

void writeBuf(const unsigned char *buffer, unsigned int length)
{
  display.clearDisplay();
  display.setCursor(0, cursorPlacement); // Start at top-left corner
  int nextLine = cursorPlacement;
  int screenWidth = 128; // Width of your OLED screen
  char currentLine[screenWidth/6 + 1]; // Current line of text being constructed (plus one for null termination)
  int currentLineLength = 0; // Length of the current line of text
  int extraChars = 0;
  int extraSpace = 0;
  int currentLineSize;
  bool removeSpace = false;
  for (unsigned int i = 0; i != length; i++) {
    char currentChar = buffer[i];
    if (currentLineSize == 20) {
      if (currentChar == ' ') {
        display.write(currentChar);
        currentLineSize = 0;
        continue;
      }
      if (i + 1 < length) {
        if (buffer[i+1] != ' ') {
          //extraChars += 1;
          display.write(buffer[i-1] == ' '? ' ': '-');
          display.write(currentChar);
          currentLineSize = 1;
        } else {
          display.write(currentChar);
          currentLineSize = 0;
        }
      } else {
        display.write(currentChar);
        currentLineSize = 0;
      }
    } else {
      if (currentLineSize == 0 && currentChar == ' ') {
          continue;
        }
      currentLineSize += 1;
      display.write(currentChar);
    }
  }
  display.display(); // Show the updated display
}
