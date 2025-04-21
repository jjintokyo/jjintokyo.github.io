#!/bin/bash

read_xml_file () { IFS='>' read -d '<' -r lines; }

if /usr/bin/curl --fail http://dir.xiph.org/yp.xml -o /home/jj/raspberrypizero2w/my_radio/random/yp.xml; then
    while read_xml_file; do
        tag="${lines%>*}"
        value="${lines#*>}"
        if [ "$tag" == "listen_url" ] && [ "$value" != " " ] && [ ! -z "$value" ]; then /usr/bin/echo "$value"; fi;
    done < /home/jj/raspberrypizero2w/my_radio/random/yp.xml > /home/jj/raspberrypizero2w/my_radio/random/yp.txt
    ### /usr/bin/head -n 999 /home/jj/raspberrypizero2w/my_radio/random/yp.txt >> /home/jj/raspberrypizero2w/my_radio/random/yp.txt
    ### /usr/bin/rm -f /var/www/html/yp.db
    /home/jj/raspberrypizero2w/my_radio/random/random_set.py
    ### /usr/bin/ln /root/random/yp.db /var/www/html/
fi
