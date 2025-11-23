#!/bin/bash

count=0; FLITE="/tmp/flite.wav"; AUDIO_DEVICE="4_mpd";

talk_2_me() { /usr/bin/flite -t "$1" -o $FLITE -voice slt --setf duration_stretch=.7 --setf int_f0_target_mean=237 &>/dev/null &&
              sudo /usr/bin/vlc2 -I dummy --alsa-audio-device $AUDIO_DEVICE --gain=0.8 --play-and-exit $FLITE </dev/null &>/dev/null; }

sudo /usr/bin/rm -f "$FLITE";

while true; do
   echo "$count";
   talk_2_me "$count";
   ### /usr/bin/sleep 1;
   ((count+=1));
done
