#!/bin/bash

read_xml_file () { IFS='>' read -d '<' -r lines; }

if curl --fail http://dir.xiph.org/yp.xml -o /root/random/yp.xml; then

    while read_xml_file; do
        tag="${lines%>*}"
        value="${lines#*>}"
        if [ "$tag" == "listen_url" ] && [ "$value" != " " ] && [ ! -z "$value" ]; then echo "$value"; fi;
    done < /root/random/yp.xml > /root/random/yp.txt

    head -n 999 /root/random/yp.txt >> /root/random/yp.txt
    /root/random/random_set.py
fi
