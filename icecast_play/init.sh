#!/bin/bash

sleep 15

if curl --fail http://dir.xiph.org/yp.xml -o /home/pi/icecast_play/yp.xml; then
	rm /home/pi/icecast_play/channels.db
	/home/pi/icecast_play/icecast.py
fi
