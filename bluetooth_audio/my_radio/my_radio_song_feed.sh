#!/bin/bash

MY_RADIO_OUTPUT_PIPE="/tmp/my_radio_output"; MY_RADIO_LOG="/tmp/my_radio.log"; DELAY=5; data=""; old_data="";

send_data() { /usr/bin/echo -e "SONG=$1\n" >  "$MY_RADIO_OUTPUT_PIPE";
              /usr/bin/echo -e "SONG=$1\n" >> "$MY_RADIO_LOG"; }

while true; do
   /usr/bin/mpc idle player &>/dev/null;
   /usr/bin/sleep "$DELAY";
   data=$(/usr/bin/mpc current -f %title%);
   if [ "$data" == "" ]; then /usr/bin/sleep "$DELAY"; data=$(/usr/bin/mpc current -f %name%); fi;
   if [ "$data" == "" ]; then /usr/bin/sleep "$DELAY"; data=$(/usr/bin/mpc current -f %file%); fi;
   if [ "$data" != "$old_data" ] && [ "$data" != "" ]; then send_data "$data"; old_data="$data"; fi;
done
