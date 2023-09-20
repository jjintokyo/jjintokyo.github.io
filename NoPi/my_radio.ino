/*

####################################################
#                                                  #
#                   my_radio.ino                   #
#                                                  #
#        FM / DAB+ / INTERNET / MP3 Player         #
#                                                  #
#--------------------------------------------------#
#                                                  #
#                JJR / August 2023                 #
#                                                  #
####################################################

*/

#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C LCD(0x3F, 16, 2);

const int LED1 = 12;
const int LED2 = 11;
const int LED3 = 10;
const int LED4 = 9;
const int LED5 = 8;
const int SCROLL_SPEED = 6;
const String BLANKS16 = "                ";
const String BLANKS13 = "             ";
const String BLANKS3  = "   ";
const char SMILEY_ARRAY[6][2] = { ")", "|", "O", "]", "D", ">" };
const byte HAPPY_ALIEN[]      = { B11111, B10101, B11111, B11111, B01110, B01010, B01010, B11011 };
const byte SAD_DUDE[]         = { B11111, B10101, B11111, B11011, B11011, B11111, B10001, B11111 };
const byte C_REVERSE[]        = { B11111, B11111, B11001, B10111, B10111, B11001, B11111, B11111 };
const byte I_REVERSE[]        = { B11111, B11111, B10001, B11011, B11011, B10001, B11111, B11111 };
const byte O_REVERSE[]        = { B11111, B11111, B10001, B10101, B10101, B10001, B11111, B11111 };
const byte DEGREE_CELSIUS[]   = { B11100, B10100, B11100, B00000, B00011, B00100, B00100, B00011 };

int leds = 0;
int smiley = 0;
int scrolling = 0;
int separator = 0;
int song_text_length = 0;
int song_text_position = 0;
int led1 = 0;
int led2 = 0;
int led3 = 0;
int led4 = 0;
int led5 = 0;

long random_smiley;
long random_delay;

boolean blink_leds = true;
boolean display_smiley = false;
boolean scroll_text = false;

String data_string = "";
String operation = "";
String parameter = "";
String song_text_1 = "";
String song_text_2 = "";

void setup()
{
   Serial.begin(9600);
   randomSeed(analogRead(0));
   pinMode(LED_BUILTIN, OUTPUT);
   pinMode(LED1, OUTPUT);
   pinMode(LED2, OUTPUT);
   pinMode(LED3, OUTPUT);
   pinMode(LED4, OUTPUT);
   pinMode(LED5, OUTPUT);
   digitalWrite(LED_BUILTIN, LOW);
   set_leds_off();
   LCD.begin();
   LCD.backlight();
   LCD.noCursor();
   LCD.clear();
   LCD.createChar(1, HAPPY_ALIEN);
   LCD.createChar(2, SAD_DUDE);
   LCD.createChar(3, C_REVERSE);
   LCD.createChar(4, I_REVERSE);
   LCD.createChar(5, O_REVERSE);
   LCD.createChar(6, DEGREE_CELSIUS);
   LCD.setCursor(0, 0);
   LCD.print("WELCOME!");
   LCD.setCursor(0, 1);
   LCD.print("Please Wait...");
}

void loop()
{
   receive_data_and_execute();
   scroll_text_on_display();
   do_display_smiley();
   do_blink_leds();
   delay(100);
}

void receive_data_and_execute()
{
   if (Serial.available() > 0)
   {
      data_string = "";
      data_string = Serial.readStringUntil('\n');
      data_string.trim();
      separator = data_string.indexOf('=');
      operation = data_string.substring(0, separator);
      parameter = data_string.substring(separator + 1);
      // Serial.println("operation = " + operation);
      // Serial.println("parameter = " + parameter);
      if (operation == "LCD_DISPLAY")
      {
         if      (parameter == "1") LCD.display();
         else if (parameter == "0") LCD.noDisplay();
         return;
      }
      if (operation == "LCD_BACKLIGHT")
      {
         if      (parameter == "1") LCD.setBacklight(HIGH);
         else if (parameter == "0") LCD.setBacklight(LOW);
         return;
      }
      if (operation == "LED1" || operation == "LED2" || operation == "LED3" || operation == "LED4" || operation == "LED5")
      {
         blink_leds = false; leds = 0; set_leds_off(); led1 = 0; led2 = 0; led3 = 0; led4 = 0; led5 = 0;
         if (operation == "LED1" && parameter == "1") { digitalWrite(LED1, HIGH); led1 = digitalRead(LED1); return; }
         if (operation == "LED2" && parameter == "1") { digitalWrite(LED2, HIGH); led2 = digitalRead(LED2); return; }
         if (operation == "LED3" && parameter == "1") { digitalWrite(LED3, HIGH); led3 = digitalRead(LED3); return; }
         if (operation == "LED4" && parameter == "1") { digitalWrite(LED4, HIGH); led4 = digitalRead(LED4); return; }
         if (operation == "LED5" && parameter == "1") { digitalWrite(LED5, HIGH); led5 = digitalRead(LED5); return; }
      }
      if (operation == "BLINKLEDS")
      {
         if      (parameter == "1") { blink_leds = true;  leds = 0; }
         else if (parameter == "0") { blink_leds = false; leds = 0;
                                      digitalWrite(LED1, led1);
                                      digitalWrite(LED2, led2);
                                      digitalWrite(LED3, led3);
                                      digitalWrite(LED4, led4);
                                      digitalWrite(LED5, led5); }
         return;
      }
      if (operation == "SMILEY")
      {
         if      (parameter == "1") { display_smiley = true;  LCD.setCursor(13, 0); LCD.print(":-)");   }
         else if (parameter == "0") { display_smiley = false; LCD.setCursor(13, 0); LCD.print(BLANKS3); }
         return;
      }
      if (operation == "VOLUME")
      {
         scroll_text = false; LCD.setCursor(0, 1); LCD.print(BLANKS16); LCD.setCursor(0, 1); LCD.print(parameter); return;
      }
      if (operation == "EQUALIZER" && blink_leds == false)
      {
         scroll_text = false; LCD.setCursor(0, 1); LCD.print(BLANKS16); LCD.setCursor(0, 1);
         if      (parameter == "1") LCD.print("EQUALIZER ON");
         else if (parameter == "0") LCD.print("EQUALIZER OFF");
         return;
      }
      if (operation == "LCD_L1")
      {
         LCD.setCursor(0, 0); LCD.print(BLANKS13); LCD.setCursor(0, 0); LCD.print(parameter); return;
      }
      if (operation == "LCD_L2")
      {
         scroll_text = false;
         if (parameter == "BLANKS") { LCD.setCursor(0, 1); LCD.print(BLANKS16); return; }
         else
         {
            LCD.setCursor(0, 1); LCD.print(BLANKS16); LCD.setCursor(0, 1); LCD.print(parameter);
            if      (parameter == "Radio play!") { LCD.setCursor(12, 1); LCD.write(1); }
            else if (parameter == "Radio stop!") { LCD.setCursor(12, 1); LCD.write(2); }
            return;
         }
      }
      if (operation == "SONG")
      {
         song_text_1 = "";
         song_text_2 = "";
         song_text_1 = parameter;
         if (song_text_1 == "" || song_text_1 == " ") return;
         if (song_text_1.length() <= 16)
         {
            LCD.setCursor(0, 1); LCD.print(BLANKS16); LCD.setCursor(0, 1); LCD.print(song_text_1); scroll_text = false;
         }
         else
         {
            song_text_1 = song_text_1 + "   ";
            song_text_length = song_text_1.length();
            song_text_2 = song_text_1.substring(0, 16);
            LCD.setCursor(0, 1);
            LCD.print(song_text_2);
            delay(2000);
            scroll_text = true;
            scrolling = 0;
            song_text_position = 15;
         }
         return;
      }
      if (operation == "TEMP")
      {
         int c = 0, i = 0, o = 0, x = 0, y = 0;
         c = parameter.indexOf('c');
         i = parameter.indexOf('i');
         o = parameter.indexOf('o');
         x = parameter.indexOf('x');
         y = parameter.indexOf('y');
         scroll_text = false;
         LCD.setCursor(0, 1); LCD.print(BLANKS16);
         LCD.setCursor(0, 1); LCD.print(parameter);
         if (c != -1) { LCD.setCursor(c, 1); LCD.write(3); }
         if (i != -1) { LCD.setCursor(i, 1); LCD.write(4); }
         if (o != -1) { LCD.setCursor(o, 1); LCD.write(5); }
         if (x != -1) { LCD.setCursor(x, 1); LCD.write(6); }
         if (y != -1) { LCD.setCursor(y, 1); LCD.write(6); }
         return;
      }
   }
}

void scroll_text_on_display()
{
   if (scroll_text == true)
   {
      scrolling++;
      if (scrolling == SCROLL_SPEED)
      {
         scrolling = 0;
         song_text_position++;
         if (song_text_position >= song_text_length) song_text_position = 0;
         song_text_2 = song_text_2.substring(1, 16) + song_text_1.substring(song_text_position, song_text_position + 1);
         LCD.setCursor(0, 1);
         LCD.print(song_text_2);
      }
   }
}

void set_leds_off()
{
   digitalWrite(LED1, LOW);
   digitalWrite(LED2, LOW);
   digitalWrite(LED3, LOW);
   digitalWrite(LED4, LOW);
   digitalWrite(LED5, LOW);
}

void do_blink_leds()
{
   if (blink_leds == true)
   {
      leds++;
      if (leds ==  1) { set_leds_off(); digitalWrite(LED1, HIGH); return; }
      if (leds == 10) { set_leds_off(); digitalWrite(LED2, HIGH); return; }
      if (leds == 19) { set_leds_off(); digitalWrite(LED3, HIGH); return; }
      if (leds == 28) { set_leds_off(); digitalWrite(LED4, HIGH); return; }
      if (leds == 37) { set_leds_off(); digitalWrite(LED5, HIGH); return; }
      if (leds == 46) leds = 0;
   }
}

void do_display_smiley()
{
   if (display_smiley == true)
   {
      smiley++;
      if (smiley == 1)
      {
         random_smiley = random(6);
         random_delay  = random(2, 9);
         LCD.setCursor(15, 0);
         LCD.print(SMILEY_ARRAY[random_smiley]);
         return;
      }
      if (smiley == random_delay) smiley = 0;
   }
}
