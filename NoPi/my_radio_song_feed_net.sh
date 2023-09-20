#!/bin/bash

ARDUINO="/dev/ttyUSB0"; DELAY=5; data=""; old_data="";

while true; do
   /usr/bin/mpc idle player &>/dev/null;
   /usr/bin/sleep "$DELAY";
   data=$(/usr/bin/mpc current -f %title%);
   if [ "$data" == "" ] || [ "$data" == " " ]; then data=$(/usr/bin/mpc current -f %name%); fi;
   if [ "$data" == "" ] || [ "$data" == " " ]; then data=$(/usr/bin/mpc current -f %file%); fi;
   if [ "$data" == "" ] || [ "$data" == " " ] || [ "$data" == "$old_data" ]; then continue; fi;
   /usr/bin/echo "SONG=$data" > "$ARDUINO"; old_data="$data";
done
