#include <IRremote.h>

const int RECV_PIN = 5;
IRrecv irrecv(RECV_PIN);
decode_results results;
unsigned long IRcode = 0;
unsigned long IRcode_received_time = 0;
unsigned long NO_repeat_delay = 700;

void setup()
{
   Serial.begin(9600);
   irrecv.enableIRIn();
   irrecv.blink13(true);
}

void loop()
{
   if (irrecv.decode(&results))
   {
      if ((results.value != IRcode) || ((results.value == IRcode) && ((millis() - IRcode_received_time) > NO_repeat_delay)))
      {
         IRcode = results.value;
         IRcode_received_time = millis();
         if (IRcode != 0xFFFFFFFF) Serial.println(IRcode, HEX);
      }
      irrecv.resume();
   }
   delay(100);
}
