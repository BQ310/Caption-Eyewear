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
#define SCREEN_ADDRESS 0x7A ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

queue_t textbuf = {0, 0, QUEUE_SIZE, malloc(sizeof(void *) * QUEUE_SIZE)};

void loop()
{
	if (textbuf.size < 10)
	{
		push(&textbuf, "This is a test...");
		push(&textbuf, "This is aASFDADA...");
		push(&textbuf, "ThASDFSAFSAFSADFis is a test...");
		push(&textbuf, "ThisADSFSAFSF is a test...");
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
}

void scroll_text()
{
	char *t = (char *)pop(&textbuf);
	if (!t)
	{
		return;
	}

	display.clearDisplay();
	display.setCursor(0, 0);

	display.println(t);

	delay(get_scroll());
}

int get_scroll()
{
	switch (scroll_speed)
	{
	case 0:
		return 10;
	case 1:
		return 20;
	case 2:
		return 30;

	default:
		return 10;
		break;
	}
}