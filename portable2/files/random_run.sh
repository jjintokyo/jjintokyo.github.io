#!/bin/sh

if [ -f /tmp/yp.txt ]; then
    FILE="/tmp/yp.txt"
else
    if [ -f /mnt/sda1/random/yp.txt ]; then
        FILE="/mnt/sda1/random/yp.txt"
    else
        URL="Nothing Found!"; /bin/echo "$URL"; exit
    fi
fi

MIN=1
MAX=$(wc -l < "$FILE")
OK=$(/bin/echo $?)

if [ "$OK" -eq 0 ] && [ "$MAX" -gt 0 ]; then
    ERROR=1
    while [ "$ERROR" -ne 0 ]; do
        RANDOM=0
        while [ "$RANDOM" -lt "$MIN" ] || [ "$RANDOM" -gt "$MAX" ]; do
            RANDOM=$(/usr/bin/head -50 /dev/urandom | /usr/bin/tr -dc "0123456789" | /usr/bin/head -c5)
        done
        URL=$(/usr/bin/head -n "$RANDOM" "$FILE" | /usr/bin/tail -n 1)
        /bin/echo $URL | /usr/bin/tee /tmp/url1.txt > /dev/null
        /usr/bin/mpc del 41 &>/dev/null
        /usr/bin/mpc add "$URL" &>/dev/null
        /usr/bin/mpc play 41 &>/dev/null
        OK=$(/bin/echo $?)
        /bin/sleep 1
        STATUS=$(/usr/bin/mpc status)
        if ! /bin/echo "$STATUS" | /bin/grep -q "ERROR: Failed" && [ "$OK" -eq 0 ]; then ERROR=0; /bin/echo "$URL"; fi
    done
fi
