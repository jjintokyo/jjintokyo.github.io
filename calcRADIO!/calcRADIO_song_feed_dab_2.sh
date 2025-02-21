#!/bin/bash

CALC="/dev/ttyAML0"; STRING_DELIMITER="^"; LOG="/tmp/calcRADIO.log";
DAB_2_PGM_OUTPUT_PIPE="/tmp/welle-cli_output"; MARKER="DLS: "; data=""; old_data="";

send_data() { /usr/bin/echo "${1}${STRING_DELIMITER}" > "$CALC";
              /usr/bin/echo "${1}${STRING_DELIMITER}" >> "$LOG"; }

while read line; do
   if [ "$line" != "" ] && [ "$line" != " " ] && [[ "$line" == "$MARKER"* ]]; then
      data=$(/usr/bin/echo "$line" | /usr/bin/cut -d' ' -f2-);
      if [ "$data" != "$old_data" ] && [ "$data" != "" ]; then send_data "$data"; old_data="$data"; fi;
   fi;
done < "$DAB_2_PGM_OUTPUT_PIPE"
