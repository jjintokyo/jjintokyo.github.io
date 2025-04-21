#!/bin/bash

MIN=1
MAX=$(/usr/bin/wc -l < "/home/jj/raspberrypizero2w/my_radio/random/yp.txt")
ERROR=1

while [ "$ERROR" -ne 0 ]; do
    RANDOM_NUMBER=0
    while [ "$RANDOM_NUMBER" -lt "$MIN" ] || [ "$RANDOM_NUMBER" -gt "$MAX" ]; do
        RANDOM_NUMBER=$(/usr/bin/head -50 /dev/urandom | /usr/bin/tr -dc "0123456789" | /usr/bin/head -c5)
    done
    URL=$(/usr/bin/head -n "$RANDOM_NUMBER" "/home/jj/raspberrypizero2w/my_radio/random/yp.txt" | /usr/bin/tail -n 1)
    /usr/bin/mpc del 41 &>/dev/null
    /usr/bin/mpc add "$URL" &>/dev/null
    /usr/bin/mpc play 41 &>/dev/null
    OK=$(/usr/bin/echo $?)
    /usr/bin/sleep 1
    STATUS=$(/usr/bin/mpc status)
    if ! /usr/bin/echo "$STATUS" | /usr/bin/grep -q "ERROR: Failed" && [ "$OK" -eq 0 ]; then ERROR=0; /usr/bin/echo "$URL"; fi
done
