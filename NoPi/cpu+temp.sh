#!/bin/bash

ARDUINO="/dev/ttyUSB0";

get_cpu_percent()     { TRY=3; LOOP=0; PREV_TOTAL=0; PREV_IDLE=0;
                        while true; do
                           ((LOOP++)); CPU=($(/usr/bin/sed -n 's/^cpu\s//p' /proc/stat)); IDLE=${CPU[3]}; TOTAL=0;
                           for VALUE in "${CPU[@]:0:8}"; do TOTAL=$((TOTAL+VALUE)); done;
                           DIFF_IDLE=$((IDLE-PREV_IDLE));
                           DIFF_TOTAL=$((TOTAL-PREV_TOTAL));
                           CPU_PERCENT=$(((1000*(DIFF_TOTAL-DIFF_IDLE)/DIFF_TOTAL+5)/10));
                           if [ "$LOOP" -eq "$TRY" ]; then break; fi;
                           PREV_TOTAL="$TOTAL"; PREV_IDLE="$IDLE";
                           /usr/bin/sleep 1
                        done; }
get_in_temperature()  { IN_TEMP=$(/usr/bin/cat "/sys/class/thermal/thermal_zone0/temp"); ((IN_TEMP=IN_TEMP/1000)); }
get_out_temperature() { OUT_TEMP=$(/usr/bin/curl -sf\
   "http://api.openweathermap.org/data/2.5/weather?q=Publier,FR&units=metric&appid=d24d74df68aacf2d69495246af937bc6" |\
                        /usr/bin/jq -r '.main.temp' | /usr/bin/cut -d'.' -f1); }

get_cpu_percent; get_in_temperature; get_out_temperature;

DATA="c${CPU_PERCENT}% i${IN_TEMP}x o${OUT_TEMP}y"; /usr/bin/echo "TEMP=$DATA" > "$ARDUINO"; /usr/bin/echo "$DATA";
