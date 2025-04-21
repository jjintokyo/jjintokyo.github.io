#!/bin/bash

MY_RADIO_INPUT_PIPE="/tmp/my_radio_input";
DELAY_WAIT=10;
BLUETOOTH_PGM="/usr/bin/bluetoothctl";
BLUETOOTH_REMOTE="44:28:A3:C5:8F:9D";
DISCOVERY="$BLUETOOTH_PGM -- info $BLUETOOTH_REMOTE";

while true; do
    STATUS=$(${DISCOVERY});
    if /bin/echo "$STATUS" | /bin/grep -q  "Connected: yes"; then
        /usr/bin/sleep "$DELAY_WAIT";
        /usr/bin/echo "remote_connected" > "$MY_RADIO_INPUT_PIPE";
        break;
    fi
    /usr/bin/sleep "$DELAY_WAIT";
done
