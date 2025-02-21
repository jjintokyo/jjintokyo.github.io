#!/bin/bash

CALC="/dev/ttyAML0"; STRING_DELIMITER="^"; LOG="/tmp/calcRADIO.log"; DELAY=2; data=""; old_data="";

send_data() { /usr/bin/echo "${1}${STRING_DELIMITER}" > "$CALC";
              /usr/bin/echo "${1}${STRING_DELIMITER}" >> "$LOG"; }

while true; do
   /usr/bin/mpc idle player &>/dev/null;
   status=$(/usr/bin/cat "$show_song_station_http");
   if [ "$status" != "0" ] && [ "$status" != "1" ] && [ "$status" != "2" ] && [ "$status" != "3" ]; then status="1"; fi;
   /usr/bin/sleep "$DELAY";
   if   [ "$status" == "1" ]; then data=$(/usr/bin/mpc current -f %title%);
   elif [ "$status" == "2" ]; then data=$(/usr/bin/mpc current -f %name%);
   elif [ "$status" == "3" ]; then data=$(/usr/bin/mpc current -f %file%); fi;
   if [ "$data" == "" ]; then /usr/bin/sleep "$DELAY"; data=$(/usr/bin/mpc current -f %name%); fi;
   if [ "$data" == "" ]; then /usr/bin/sleep "$DELAY"; data=$(/usr/bin/mpc current -f %file%); fi;
   if [ "$data" != "$old_data" ] && [ "$data" != "" ]; then send_data "$data"; old_data="$data"; fi;
done
