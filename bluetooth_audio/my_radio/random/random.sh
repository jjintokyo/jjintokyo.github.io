#!/bin/bash

while true; do
    if [ ! "$1" ]; then cmd=$(/home/jj/raspberrypizero2w/my_radio/random/random_run.py)
    else                cmd=$(/home/jj/raspberrypizero2w/my_radio/random/random_run.py "$1")
    fi
    if [ "$cmd" != "Nothing Found!" ]; then
        url=$(/usr/bin/echo $cmd   | /usr/bin/cut -f1 -d' ')
        genre=$(/usr/bin/echo $cmd | /usr/bin/cut -f2- -d' ')
        /usr/bin/mpc del 41 &>/dev/null
        /usr/bin/mpc add "$url" &>/dev/null
        /usr/bin/mpc play 41 &>/dev/null
        ok=$(/usr/bin/echo $?)
        /usr/bin/sleep 1
        status=$(/usr/bin/mpc status)
        if ! /usr/bin/echo "$status" | /usr/bin/grep -q "ERROR: Failed" && [ "$ok" -eq 0 ]; then
             /usr/bin/echo "url = $url"
             /usr/bin/echo "genre = $genre"; exit
        fi
    else
        /usr/bin/echo "$cmd"; exit
    fi
done
