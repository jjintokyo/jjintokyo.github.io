#!/bin/bash

sudo /usr/bin/killall -q my_radio_remote.sh
sudo /usr/bin/killall -q my_radio_input.py
sudo /usr/bin/killall -q my_radio_output.py
sudo /usr/bin/killall -q my_radio_song_feed.sh
sudo /usr/bin/killall -q my_radio.sh

sudo /usr/bin/rm -f /tmp/my_radio_input
sudo /usr/bin/rm -f /tmp/my_radio_output
sudo /usr/bin/rm -f /tmp/my_radio.log
sudo /usr/bin/rm -f /tmp/flite.wav

./my_radio.sh
