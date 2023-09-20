#!/bin/bash

DAB_1_PGM_OUTPUT_PIPE="/tmp/dab-rtlsdr-2_output"; ARDUINO="/dev/ttyUSB0"; MARKER="DLS: "; data=""; old_data="";

while read line; do
   if [ "$line" != "" ] && [ "$line" != " " ] && [[ "$line" == "$MARKER"* ]]; then
      data=$(/usr/bin/echo "$line" | /usr/bin/cut -d' ' -f2-);
      if [ "$data" != "$old_data" ]; then
         /usr/bin/echo "SONG=$data" > "$ARDUINO"; old_data="$data";
      fi;
   fi;
done < "$DAB_1_PGM_OUTPUT_PIPE"
