#!/bin/sh

MIN=1
MAX=$(wc -l < "/tmp/ubi1/random/yp.txt")
ERROR=1

while [ "$ERROR" -ne 0 ]; do
    RANDOM=0

    while [ "$RANDOM" -lt "$MIN" ] || [ "$RANDOM" -gt "$MAX" ]; do
        RANDOM=$(head -50 /dev/urandom | tr -dc "0123456789" | head -c5)
    done

    URL=$(head -n "$RANDOM" "/tmp/ubi1/random/yp.txt" | tail -n 1)
    /usr/bin/mpc del 41 &>/dev/null
    /usr/bin/mpc add "$URL" &>/dev/null
    /usr/bin/mpc play 41 &>/dev/null
    OK=$(echo $?)

    sleep 1
    STATUS=$(/usr/bin/mpc status)
    if ! echo "$STATUS" | grep -q "ERROR: Failed" && [ "$OK" -eq 0 ]; then ERROR=0; echo "$URL"; fi
done
