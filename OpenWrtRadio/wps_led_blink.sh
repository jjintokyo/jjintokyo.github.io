#!/bin/sh

sleepy=1

if [ "$1" == "start" ]; then
    /bin/touch /tmp/wps_led_blink
    while true; do
        /bin/echo "1" > /sys/devices/platform/leds/leds/tl-wr902ac-v3:green:wps/brightness
        /bin/sleep $sleepy
        /bin/echo "0" > /sys/devices/platform/leds/leds/tl-wr902ac-v3:green:wps/brightness
        /bin/sleep $sleepy
        if [ ! -f /tmp/wps_led_blink ]; then exit; fi
    done
fi

if [ "$1" == "stop" ]; then
    /bin/rm -f /tmp/wps_led_blink
fi
