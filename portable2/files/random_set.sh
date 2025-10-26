#!/bin/sh

read_xml_file () { IFS='>' read -d '<' -r lines; }

/root/my_radio/wps_led_blink.sh "start" &

if /usr/bin/curl --fail http://dir.xiph.org/yp.xml -o /tmp/yp.xml; then
    while read_xml_file; do
        tag="${lines%>*}"
        value="${lines#*>}"
        if [ "$tag" == "listen_url" ] && [ "$value" != " " ] && [ ! -z "$value" ]; then /bin/echo "$value"; fi;
    done < /tmp/yp.xml > /tmp/yp.txt
    /usr/bin/head -n 999 /tmp/yp.txt >> /tmp/yp.txt
    /root/my_radio/random_set.py
fi

/bin/cp -f /tmp/yp.* /mnt/sda1/random/
/bin/rm -f /tmp/yp.*
/root/my_radio/oldies.py "oldies" > /root/my_radio/oldies.db

/root/my_radio/wps_led_blink.sh "stop" &
