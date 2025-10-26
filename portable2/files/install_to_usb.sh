#!/bin/sh

/bin/opkg update
/bin/opkg -d usb install python-light python-sqlite3 python-xml python-logging python-openssl python-chardet
/bin/opkg -d usb install espeak svox sox alsa-utils-tests madplay mpg123
/bin/opkg -d usb install atop iftop evtest sudo
/bin/opkg -d usb install apache wavemon

/bin/ln -sf /mnt/sda1/packages/usr/share/espeak     /usr/share/espeak
/bin/ln -sf /mnt/sda1/packages/usr/share/pico       /usr/share/pico
/bin/ln -sf /mnt/sda1/packages/usr/share/sounds     /usr/share/sounds
/bin/ln -sf /mnt/sda1/packages/etc/init.d/apache2   /etc/init.d/apache2
/bin/ln -sf /mnt/sda1/packages/usr/sbin/apachectl   /usr/sbin/apachectl
/bin/ln -sf /mnt/sda1/packages/usr/sbin/apache2     /usr/sbin/apache2
/bin/ln -sf /mnt/sda1/packages/usr/lib/apache2      /usr/lib/apache2
/bin/ln -sf /mnt/sda1/packages/etc/apache2          /etc/apache2

/bin/mkdir -p /var/log/apache2
/bin/mkdir -p /var/run/apache2
/etc/init.d/apache2 restart

########################################################################################################
#### O N E   T I M E   O N L Y #########################################################################
########################################################################################################
#### mv /mnt/sda1/packages/etc/apache2/apache2.conf /mnt/sda1/packages/etc/apache2/apache2.conf.original
#### cp /root/my_radio/apache2.conf                 /mnt/sda1/packages/etc/apache2/apache2.conf
########################################################################################################
