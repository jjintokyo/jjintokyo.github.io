#!/bin/sh

read_xml_file () { IFS='>' read -d '<' -r lines; }

if curl --fail http://dir.xiph.org/yp.xml -o /tmp/ubi1/random/yp.xml; then

    while read_xml_file; do
        tag="${lines%>*}"
        value="${lines#*>}"
        if [ "$tag" == "listen_url" ] && [ "$value" != " " ] && [ ! -z "$value" ]; then echo "$value"; fi;
    done < /tmp/ubi1/random/yp.xml > /tmp/ubi1/random/yp.txt

    head -n 999 /tmp/ubi1/random/yp.txt >> /tmp/ubi1/random/yp.txt
    /tmp/ubi1/random/random_set.py
fi
