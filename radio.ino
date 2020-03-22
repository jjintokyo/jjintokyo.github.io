/*
######################################
#                                    #
#             radio.ino              #
#                                    #
######################################
# RADIO / JJR / FEBRUARY 2020        #
#------------------------------------#
# CONTROL                            #
#------------------------------------#
# |--> send commands to raspberry pi #
######################################
*/

#include <IRremote.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 2, 1, 0, 4, 5, 6, 7, 3, POSITIVE);

int ir_receiver_pin = 12;
IRrecv irrecv(ir_receiver_pin);
decode_results results;

int led1 = 11;
int led2 = 10;
int led3 = 9;
int led4 = 8;
int led5 = 7;
int volume = 66;
int mode = 1;
int last_mode = 0;
int preset = 0;
int last_preset = 0;
int smiley = 0;
int leds = 0;
int scrolling = 0;
int data_string_length = 0;
int data_string_position = 0;

unsigned long time_out_check = 0;
unsigned long time_out_value = 0;

boolean blink_leds = false;
boolean mute = false;
boolean equalizer = true;
boolean display = true;
boolean backlight_always_on = false;
boolean backlight_always_off = false;
boolean backlight_timed_out = false;
boolean get_data = false;
boolean do_scrolling = false;

String data_string_1 = "";
String data_string_2 = "";

char preset_array[10][6]  = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};
char random_array[10][12] = {"everything", "talk", "classical", "alternative", "country", "scanner", "60s", "70s", "80s", "90s"};
char data_array[21];

void setup()
{
  radio_init();
}

void loop()
{
  if (irrecv.decode(&results))
  {
    switch (results.value)
    {
      // VOL + : A05F20DF
      case 0xA05F20DF:
        if (mute == false) set_volume_up();
        break;
      // VOL - : A05FA05F
      case 0xA05FA05F:
        if (mute == false) set_volume_down();
        break;
      // CH UP : A05F40BF
      case 0xA05F40BF:
        if (mute == false) set_mode_up();
        break;
      // CH DOWN : A05FC03F
      case 0xA05FC03F:
        if (mute == false) set_mode_down();
        break;
      // 0 : A05F48B7
      case 0xA05F48B7:
        preset = 0;
        if (mute == false) set_preset();
        break;
      // 1 : A05F906F
      case 0xA05F906F:
        preset = 1;
        if (mute == false) set_preset();
        break;
      // 2 : A05F50AF
      case 0xA05F50AF:
        preset = 2;
        if (mute == false) set_preset();
        break;
      // 3 : A05FD02F
      case 0xA05FD02F:
        preset = 3;
        if (mute == false) set_preset();
        break;
      // 4 : A05F30CF
      case 0xA05F30CF:
        preset = 4;
        if (mute == false) set_preset();
        break;
      // 5 : A05FB04F
      case 0xA05FB04F:
        preset = 5;
        if (mute == false) set_preset();
        break;
      // 6 : A05F708F
      case 0xA05F708F:
        preset = 6;
        if (mute == false) set_preset();
        break;
      // 7 : A05FF00F
      case 0xA05FF00F:
        preset = 7;
        if (mute == false) set_preset();
        break;
      // 8 : A05F08F7
      case 0xA05F08F7:
        preset = 8;
        if (mute == false) set_preset();
        break;
      // 9 : A05F8877
      case 0xA05F8877:
        preset = 9;
        if (mute == false) set_preset();
        break;
      // MUTE : A05F609F
      case 0xA05F609F:
        set_mute();
        break;
      // AUDIO : A05FC837
      case 0xA05FC837:
        if (mute == false) set_equalizer();
        break;
      // POWER : A05F807F
      case 0xA05F807F:
        if (mute == false) radio_init();
        if (mute == true)  shut_down();
        break;
      // DISPLAY : A05FB24D
      case 0xA05FB24D:
        set_display();
        break;
      // SOURCE : A05F10EF
      case 0xA05F10EF:
        if (mute == false) play_random_radio();
        break;
      // EPG : A05FA857
      case 0xA05FA857:
        if (mute == false) play_special_radio();
        break;
      // CH RTN : A05FE01F
      case 0xA05FE01F:
        if (mute == false) recall_previous_preset();
        break;
      // FULL SCREEN : A05F6A95
      case 0xA05F6A95:
        get_the_stream_title();
        break;
      // CROSS CENTER : A05F6897
      case 0xA05F6897:
        get_the_stream_url();
        break;
      default:
        Serial.println(results.value, HEX);
    }
    irrecv.resume();
  }
  do_smiley();
  do_blink_leds();
  receive_data();
  scroll_text();
  check_time_out();
  delay(100);
}

void radio_init()
{
  volume = 66;
  mode = 1;
  last_mode = 0;
  preset = 0;
  last_preset = 0;
  smiley = 0;
  leds = 0;
  scrolling = 0;
  data_string_length = 0;
  data_string_position = 0;
  time_out_check = 0;
  time_out_value = 0;
  mute = false;
  equalizer = true;
  display = true;
  backlight_always_on = false;
  backlight_always_off = false;
  backlight_timed_out = false;
  get_data = false;
  do_scrolling = false;
  data_string_1 = "";
  data_string_2 = "";
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
  pinMode(led4, OUTPUT);
  pinMode(led5, OUTPUT);
  Serial.begin(9600);
  irrecv.enableIRIn();
  lcd.begin(20,4);
  lcd.home();
  lcd.noCursor();
  lcd.clear();
  set_backlight_temporary_on(30);
  lcd.print("ArduiPi Radio!");
  display_mode();
  Serial.print("init_mode=");
  Serial.println(mode);
  display_volume();
  Serial.print("init_volume=");
  Serial.println(volume);
  display_equalizer();
  if (equalizer == true)  Serial.println("init_equalizer=1");
  if (equalizer == false) Serial.println("init_equalizer=0");
  display_mute();
  if (mute == false) Serial.println("init_mute=0");
  if (mute == true)  Serial.println("init_mute=1");
  blink_leds = true;
}

void set_leds_on()
{
  digitalWrite(led1, HIGH);
  digitalWrite(led2, HIGH);
  digitalWrite(led3, HIGH);
  digitalWrite(led4, HIGH);
  digitalWrite(led5, HIGH);
}

void set_leds_off()
{
  digitalWrite(led1, LOW);
  digitalWrite(led2, LOW);
  digitalWrite(led3, LOW);
  digitalWrite(led4, LOW);
  digitalWrite(led5, LOW);
}

void do_smiley()
{
  smiley++;
  if (smiley == 1)
  {
    if (backlight_always_off == false) digitalWrite(LED_BUILTIN, HIGH);
    lcd.setCursor(15,0);
    lcd.print("(^_^)");
    return;
  }
  if (smiley == 6)
  {
    if (backlight_always_off == false) digitalWrite(LED_BUILTIN, LOW);
    lcd.setCursor(15,0);
    lcd.print("('.')");
    return;
  }
  if (smiley == 11)
  {
    if (backlight_always_off == false) digitalWrite(LED_BUILTIN, LOW);
    lcd.setCursor(15,0);
    lcd.write(40);
    lcd.write(223);
    lcd.write(95);
    lcd.write(223);
    lcd.write(41);
    return;
  }
  if (smiley == 16) smiley = 0;
}

void do_blink_leds()
{
  if (blink_leds == true)
  {
    leds++;
    if (leds ==  1) { set_leds_off(); digitalWrite(led1, HIGH); return; }
    if (leds ==  4) { set_leds_off(); digitalWrite(led2, HIGH); return; }
    if (leds ==  7) { set_leds_off(); digitalWrite(led3, HIGH); return; }
    if (leds == 10) { set_leds_off(); digitalWrite(led4, HIGH); return; }
    if (leds == 13) { set_leds_off(); digitalWrite(led5, HIGH); return; }
    if (leds == 16) leds = 0;
  }
}

void check_time_out()
{
  if (backlight_timed_out == false && backlight_always_on == false && backlight_always_off == false)
  {
    if ((millis() - time_out_check) >= time_out_value)
    {
      backlight_timed_out = true;
      blink_leds = false;
      get_data = false;
      display_led();
      lcd.setBacklight(LOW);
    }
  }
}

void set_backlight_temporary_on(int seconds)
{
  if (backlight_always_on == false && backlight_always_off == false)
  {
    lcd.setBacklight(HIGH);
    backlight_timed_out = false;
    time_out_check = millis();
    time_out_value = (seconds * 1000);
  }
}

void set_volume_up()
{
  set_backlight_temporary_on(10);
  if (volume < 100)
  {
    volume += 3;
    if (volume > 100) volume=100;
    display_volume();
    Serial.print("volume_up=");
    Serial.println(volume);
  }
}

void set_volume_down()
{
  set_backlight_temporary_on(10);
  if (volume > 0)
  {
    volume -=3;
    if (volume < 0) volume=0;
    display_volume();
    Serial.print("volume_down=");
    Serial.println(volume);
  }
}

void display_volume()
{
  lcd.setCursor(0,3);
  lcd.print("         ");
  lcd.setCursor(0,3);
  lcd.print("Vol:");
  lcd.print(volume);
  lcd.print("%");
}

void set_mode_up()
{
  mode++;
  if (mode == 9) mode=1;
  change_mode();
}

void set_mode_down()
{
  mode--;
  if (mode == 0) mode=8;
  change_mode();
}

void change_mode()
{
  set_backlight_temporary_on(10);
  display_mode();
  Serial.print("change_mode=");
  Serial.println(mode);
}

void display_mode()
{
  lcd.setCursor(0,1);
  lcd.print("                    ");
  lcd.setCursor(0,2);
  lcd.print("                    ");
  lcd.setCursor(0,1);
  lcd.write(165);
  if (mode == 1) lcd.print("FM RADIO");
  if (mode == 2) lcd.print("DAB+ RADIO");
  if (mode == 3) lcd.print("INTERNET RADIO #1");
  if (mode == 4) lcd.print("INTERNET RADIO #2");
  if (mode == 5) lcd.print("INTERNET RADIO #3");
  if (mode == 6) lcd.print("INTERNET RADIO #4");
  if (mode == 7) lcd.print("RANDOM INTERNET");
  if (mode == 8) lcd.print("MP3 PLAYER");
  lcd.write(165);
  display_led();
  cleanup();
}

void display_led()
{
  set_leds_off();
  if (mode == 1) digitalWrite(led1, HIGH);
  if (mode == 2) digitalWrite(led2, HIGH);
  if (mode == 3) digitalWrite(led3, HIGH);
  if (mode == 4) digitalWrite(led3, HIGH);
  if (mode == 5) digitalWrite(led3, HIGH);
  if (mode == 6) digitalWrite(led3, HIGH);
  if (mode == 7) digitalWrite(led4, HIGH);
  if (mode == 8) digitalWrite(led5, HIGH);
}

void cleanup()
{
  blink_leds = false;
  get_data = false;
  do_scrolling = false;
}

void set_preset()
{
  set_backlight_temporary_on(10);
  display_preset();
  Serial.print("set_preset=");
  Serial.println(preset);
  last_mode = mode;
  last_preset = preset;
}

void display_preset()
{
  lcd.setCursor(0,2);
  lcd.print("                    ");
  lcd.setCursor(0,2);
  lcd.write(126);
  if (mode == 1 || mode == 2 || mode == 3 || mode == 4 || mode == 5 || mode == 6)
  {
    lcd.print(" Preset ");
    lcd.print(preset_array[preset]);
  }
  if (mode == 7)
  {
    lcd.print(" Random ");
    lcd.print(random_array[preset]);
  }
  if (mode == 8)
  {
    lcd.print(" Random mp3");
  }
  display_led();
  cleanup();
}

void set_mute()
{
  set_backlight_temporary_on(10);
  if (mute == false)
  {
    mute = true;
    display_mute();
    Serial.println("set_mute=1");
  }
  else
  {
    mute = false;
    display_mute();
    Serial.println("set_mute=0");
  }
}

void display_mute()
{
  if (mute == true)
  {
    lcd.setCursor(0,3);
    lcd.print("         ");
    lcd.setCursor(0,3);
    lcd.print("[ mute ]");
  }
  else
  {
    lcd.setCursor(0,3);
    lcd.print("         ");
    lcd.setCursor(0,3);
    lcd.print("Vol:");
    lcd.print(volume);
    lcd.print("%");
  }
}

void set_equalizer()
{
  set_backlight_temporary_on(10);
  if (equalizer == true)
  {
    equalizer = false;
    display_equalizer();
    Serial.println("set_equalizer=0");
  }
  else
  {
    equalizer = true;
    display_equalizer();
    Serial.println("set_equalizer=1");
  }
}

void display_equalizer()
{
  lcd.setCursor(14,3);
  lcd.print("      ");
  lcd.setCursor(14,3);
  if (equalizer == false) lcd.print("EQ:OFF");
  if (equalizer == true)  lcd.print("EQ:ON");
}

void shut_down()
{
  lcd.clear();
  lcd.setBacklight(HIGH);
  set_leds_on();
  cleanup();
  lcd.setCursor(0,1);
  lcd.print("Shutting down...");
  lcd.setCursor(10,2);
  lcd.print("the radio!");
  Serial.println("shutdown=1");
}

void set_display()
{
  if (display == true)
  {
    display = false;
    lcd.setBacklight(LOW);
    backlight_always_on = false;
    backlight_always_off = true;
    backlight_timed_out = true;
  }
  else
  {
    display = true;
    lcd.setBacklight(HIGH);
    backlight_always_on = true;
    backlight_always_off = false;
    backlight_timed_out = true;
  }
}

void play_random_radio()
{
  mode = 7;
  set_backlight_temporary_on(10);
  display_led();
  cleanup();
  lcd.setCursor(0,1);
  lcd.print("                    ");
  lcd.setCursor(0,2);
  lcd.print("                    ");
  lcd.setCursor(0,2);
  lcd.write(126);
  lcd.print(" play random radio");
  Serial.print("init_mode=");
  Serial.println(mode);
  Serial.println("random=1");
}

void play_special_radio()
{
  mode = 3;
  set_backlight_temporary_on(10);
  display_led();
  cleanup();
  lcd.setCursor(0,1);
  lcd.print("                    ");
  lcd.setCursor(0,2);
  lcd.print("                    ");
  lcd.setCursor(0,2);
  lcd.write(126);
  lcd.print(" play special radio");
  Serial.print("init_mode=");
  Serial.println(mode);
  Serial.println("special=1");
}

void recall_previous_preset()
{
  if (last_mode != 0)
  {
    mode = last_mode;
    change_mode();
    preset = last_preset;
    set_preset();
  }
}

void get_the_stream_title()
{
  if (mode == 1 || mode == 2 || mode == 3 || mode == 4 || mode == 5 || mode == 6 || mode == 7)
  {
    set_backlight_temporary_on(20);
    get_data = true;
    blink_leds = true;
    Serial.println("get_title=1");
  }
}

void get_the_stream_url()
{
  if (mode == 3 || mode == 4 || mode == 5 || mode == 6 || mode == 7)
  {
    set_backlight_temporary_on(20);
    get_data = true;
    blink_leds = true;
    Serial.println("get_url=1");
  }
}

void receive_data()
{
  if (get_data == true && Serial.available() > 0)
  {
    set_backlight_temporary_on(20);
    display_led();
    cleanup();
    data_string_1 = "";
    data_string_2 = "";
    data_string_1 = Serial.readStringUntil('\n');
    data_string_1.trim();
    lcd.setCursor(0,2);
    lcd.print("                    ");
    lcd.setCursor(0,2);
    if (mode == 1 || mode == 2) { lcd.write(127); lcd.write(32); }
    if (data_string_1.length() <= 20)
    {
      data_string_1.toCharArray(data_array,21);
      lcd.write(data_array);
      do_scrolling = false;
    }
    else
    {
      if (data_string_1 != " ")
      {
        data_string_1 = data_string_1 + "   ";
        data_string_length = data_string_1.length();
        data_string_2 = data_string_1.substring(0,20);
        data_string_2.toCharArray(data_array,21);
        lcd.write(data_array);
        delay(1500);
        do_scrolling = true;
        scrolling = 0;
        data_string_position = 19;
      }
      else do_scrolling = false;
    }
  }
}

void scroll_text()
{
  if (do_scrolling == true)
  {
    scrolling++;
    if (scrolling == 5)
    {
      scrolling = 0;
      data_string_position++;
      if (data_string_position >= data_string_length) data_string_position = 0;
      data_string_2 = data_string_2.substring(1,20) +
                      data_string_1.substring(data_string_position, data_string_position + 1);
      data_string_2.toCharArray(data_array,21);
      lcd.setCursor(0,2);
      lcd.write(data_array);
    }
  }
}
