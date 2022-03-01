#!/bin/sh

/bin/opkg update
/bin/opkg -d usb install python-light python-sqlite3 python-xml python-logging python-openssl python-chardet
/bin/opkg -d usb install espeak svox sox alsa-utils-tests madplay mpg123
/bin/opkg -d usb install atop iftop evtest sudo

/bin/ln -sf /mnt/sda1/packages/usr/share/espeak /usr/share/espeak
/bin/ln -sf /mnt/sda1/packages/usr/share/pico /usr/share/pico
/bin/ln -sf /mnt/sda1/packages/usr/share/sounds /usr/share/sounds
