#!/bin/bash

while true; do
    if [ ! "$1" ]; then
        cmd=$(/root/random/random_run.py)
    else
        cmd=$(/root/random/random_run.py "$1")
    fi
    if [ "$cmd" != "Nothing Found!" ]; then
        url=$(echo $cmd | cut -f1 -d' ')
        genre=$(echo $cmd | cut -f2- -d' ')
        /usr/bin/mpc del 41 &>/dev/null
        /usr/bin/mpc add "$url" &>/dev/null
        /usr/bin/mpc play 41 &>/dev/null
        ok=$(echo $?)
        sleep 1
        status=$(/usr/bin/mpc status)
        if ! echo "$status" | grep -q "ERROR: Failed" && [ "$ok" -eq 0 ]; then echo "url = $url"; echo "genre = $genre"; exit; fi
    else
        echo "$cmd"; exit
    fi
done
