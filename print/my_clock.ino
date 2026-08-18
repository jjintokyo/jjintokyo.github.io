/*
####################################################
#                                                  #
#                   my_clock.ino                   #
#                                                  #
#  Display time & temperature from the internet!   #
#                                                  #
#--------------------------------------------------#
#                                                  #
#              Arduino IDE: Pi Pico W              #
#      Install libraries TM1637 & ArduinoJson      #
#                                                  #
#--------------------------------------------------#
#                                                  #
#           JJR / Saturday, June 6, 2026           #
#                                                  #
####################################################
*/

#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <TM1637Display.h>

#define Display_CLK 17
#define Display_DIO 16

TM1637Display display(Display_CLK, Display_DIO);

int LED                                    = LED_BUILTIN;
int start_counter                          = 0;
int time_to_display                        = 9999;
int temperature_to_display                 = 99;
const unsigned long refresh_display_delay  = 60000;
const unsigned long show_temperature_delay = 20000;
const unsigned long get_temperature_delay  = 900000;
const unsigned long blink_dot_delay        = 1000;
unsigned long previous_refresh_display     = 0;
unsigned long previous_show_temperature    = 0;
unsigned long previous_get_temperature     = 0;
unsigned long previous_blink_dot           = 0;
unsigned long current_time                 = 0;
bool showing_dot                           = false;
bool showing_temperature                   = false;

const uint8_t degree_celsius[] = { SEG_A | SEG_B | SEG_F | SEG_G, SEG_D | SEG_E | SEG_G };

bool is_wifi_connected() { return WiFi.status() == WL_CONNECTED; }

void connect_to_wifi(const char *ssid, const char *pass)
{
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, pass);
    Serial.print("Connecting...");
    while (! is_wifi_connected())
    {
        delay(500);
        Serial.print(".");
        display.showNumberDecEx(start_counter, 0, false, 4, 0);
        start_counter++;
        delay(500);
    }
    Serial.println("");
    Serial.println("WiFi Connection Established!");
    Serial.println(WiFi.SSID());
    Serial.print("Assigned IP: ");
    Serial.println(WiFi.localIP());
}

void set_clock()
{
    Serial.println("");
    Serial.print("Waiting for NTP time sync...");
    NTP.begin("pool.ntp.org", "time.nist.gov");
    time_t now = time(nullptr);
    while (now < 8 * 3600 * 2)
    {
        delay(500);
        Serial.print(".");
        display.showNumberDecEx(start_counter, 0, false, 4, 0);
        start_counter++;
        delay(500);
        now = time(nullptr);
    }
    Serial.println("");
}

void get_time()
{
    struct tm timeinfo;
    time_t now = time(nullptr);
    localtime_r(&now, &timeinfo);
    time_to_display = 100 * timeinfo.tm_hour + timeinfo.tm_min;
    Serial.print("Current time : " + String(asctime(&timeinfo)));
}

void get_temperature()
{
    String data = "";
    HTTPClient https;
    https.setInsecure();
    // if (https.begin("https://api.open-meteo.com/v1/forecast?latitude=XXX&longitude=YYY&current_weather=true"))
    if (https.begin("https://api.openweathermap.org/data/2.5/weather?q=LOCATION&units=metric&appid=APPID"))
    {
        if (https.GET() > 0)
        {
            data = https.getString();
        }
        https.end();
    }
    Serial.println(data);
    if (data != "")
    {
        JsonDocument doc;
        DeserializationError error = deserializeJson(doc, data);
        if (error)
        {
            Serial.print("deserializeJson() failed: ");
            Serial.println(error.c_str());
            return;
        }
        // double temp = doc["current_weather"]["temperature"];
        double temp = doc["main"]["temp"];
        temperature_to_display = int(temp + 0.5);
        Serial.println("Temperature  : " + String(temp) + " °C");
    }
}

void blink_dot()
{
    if (! showing_temperature)
    {
        if (showing_dot) { display.showNumberDecEx(time_to_display, 0b01000000, true, 4, 0);
                           showing_dot = false; }
        else             { display.showNumberDecEx(time_to_display, 0, true, 4, 0);
                           showing_dot = true;  }
    }
}

void setup()
{
    Serial.begin(9600);
    pinMode(LED, OUTPUT);
    digitalWrite(LED, LOW);
    display.setBrightness(7, true);
    connect_to_wifi("SSID", "PASSWORD");
    if (is_wifi_connected())
    {
        digitalWrite(LED, HIGH);
        set_clock();
        setenv("TZ", "CET-1CEST,M3.5.0,M10.5.0/3", 1);
        tzset();
        get_time();
        get_temperature();
    }
    display.clear();
    display.showNumberDecEx(time_to_display, 0b01000000, true, 4, 0);
}

void loop()
{
    current_time = millis();
    if ((current_time - previous_blink_dot) > blink_dot_delay)
    {
        previous_blink_dot = current_time;
        blink_dot();
    }
    if (((current_time - previous_get_temperature) > get_temperature_delay) && (is_wifi_connected()))
    {
        previous_get_temperature = current_time;
        get_temperature();
    }
    if ((current_time - previous_refresh_display) > refresh_display_delay)
    {
        previous_refresh_display  = current_time;
        previous_show_temperature = current_time;
        showing_temperature       = true;
        display.clear();
        display.showNumberDecEx(temperature_to_display, 0, false, 2, 0);
        display.setSegments(degree_celsius, 2, 2);
        get_time();
    }
    if ((current_time - previous_show_temperature) > show_temperature_delay)
    {
        previous_show_temperature = current_time;
        showing_temperature       = false;
        showing_dot               = true;
        // display.showNumberDecEx(time_to_display, 0b01000000, true, 4, 0);
    }
    // delay(100);
}
