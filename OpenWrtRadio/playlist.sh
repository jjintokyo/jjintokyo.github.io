#!/bin/sh

/usr/bin/mpc stop
/usr/bin/mpc clear
cat /root/playlist.db | /usr/bin/mpc add
/usr/bin/mpc play
