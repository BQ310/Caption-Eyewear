/*
Alonso Diaz
OLED Program to test projection
*/
#include "queue.h"

// #include <ArduinoBLE.h>
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define QUEUE_SIZE 16

int scroll_speed = 0;

#define BUF_SIZE 256
#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

#define OLED_RESET -1		// Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

myqueue textbuf = {0, 0, QUEUE_SIZE, (void**) malloc(sizeof(void *) * QUEUE_SIZE)};

void loop()
{
	if (getsize(&textbuf) < 10)
	{
  	mypush(&textbuf, (void*) "This is aASFDADA...");
		mypush(&textbuf, (void*) "ThASDFSAFSAFSADFis is a test...");
		mypush(&textbuf, (void*) "ThisADSFSAFSF is a test...");
	}

	scroll_text();
}

void setup()
{
	Serial.begin(9600);
	if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS))
	{
		Serial.println(F("SSD1306 allocation failed!"));
		for (;;)
			;
	}

  display.display();
  display.setTextSize(1);              // Normal 1:1 pixel scale
  display.setTextColor(SSD1306_WHITE); // Draw white text
  display.cp437(true);
}

void scroll_text()
{
	char *t = (char *)mypop(&textbuf);
	if (t == NULL)
	{
    Serial.println("Null pointer!\n");
		return;
	}

  Serial.println(t);

	display.clearDisplay();
	display.setCursor(0, 0);

  Serial.println("Updating screen\n");
	display.println(F(t));

  display.display();

  free(t);

	delay(get_scroll());
}

int get_scroll()
{
	switch (scroll_speed)
	{
	case 0:
		return 1000;
	case 1:
		return 2000;
	case 2:
		return 3000;

	default:
		return 1000;
		break;
	}
}