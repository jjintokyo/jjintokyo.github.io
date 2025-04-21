#!/bin/bash

DELAY_WAIT=30; volume=30; FLITE_VOLUME=0.5; FLITE="/tmp/FLITE.WAV";
t2m_bluetooth_speaker_is_on="blue tooth speaker is on"; t2m_bluetooth_speaker_is_off="blue tooth speaker is off";
BLUETOOTH_SPEAKER="10:28:74:7E:58:F4"; BLUETOOTH_PGM="/usr/bin/bluetoothctl";
POWER_ON="$BLUETOOTH_PGM -- power on"; PAIR="$BLUETOOTH_PGM -- pair $BLUETOOTH_SPEAKER";
TRUST="$BLUETOOTH_PGM -- trust $BLUETOOTH_SPEAKER"; CONNECT="$BLUETOOTH_PGM -- connect $BLUETOOTH_SPEAKER &>/dev/null";
DISCOVERY="$BLUETOOTH_PGM -- info $BLUETOOTH_SPEAKER";
COPY_CONFIG1="/usr/bin/cp /etc/asound.conf.default   /etc/asound.conf";
COPY_CONFIG2="/usr/bin/cp /etc/asound.conf.bluetooth /etc/asound.conf";
ALSA_RELOAD="/usr/sbin/alsa reload"; REDUCE_VOLUME="/usr/bin/amixer -D bluealsa sset 'JBL Pulse 5 - A2DP' 50%";

restart_mpd() { /usr/bin/systemctl restart mpd;
                /bin/sleep 3;
                /usr/bin/mpc stop &>/dev/null;
                /usr/bin/mpc clear &>/dev/null;
                /usr/bin/cat /root/playlist.db | /usr/bin/mpc add &>/dev/null;
                /usr/bin/mpc repeat on &>/dev/null;
                /usr/bin/mpc volume 100 &>/dev/null; }
set_volume()  { /usr/bin/amixer sset "SoftVolume" "$1"% &>/dev/null; }
talk_2_me()   { /usr/bin/flite -t "$1" -o "$FLITE" -voice slt --setf duration_stretch=.9\
                                                              --setf int_f0_target_mean=237 &>/dev/null &&
                /usr/bin/play -qV0 -v "$FLITE_VOLUME" "$FLITE" reverb &>/dev/null; }

export AUDIODEV=SoftVolume; export AUDIODRIVER=alsa;
eval "$COPY_CONFIG1"; eval "$ALSA_RELOAD";
/usr/bin/systemctl enable --now bluetooth; /usr/bin/killall bluealsa; /bin/sleep 3;
### /usr/bin/bluealsa --profile=a2dp-source --a2dp-force-audio-cd &
export LIBASOUND_THREAD_SAFE=0; /usr/bin/bluealsa --profile=a2dp-source &
eval "$POWER_ON"; eval "$PAIR"; eval "$TRUST";

while true; do
    eval "$CONNECT";
    STATUS=$(${DISCOVERY});
    if /bin/echo "$STATUS" | /bin/grep -q  "Connected: yes"; then
        eval "$COPY_CONFIG2"; eval "$ALSA_RELOAD"; eval "$REDUCE_VOLUME"; restart_mpd; set_volume "$volume";
        talk_2_me "$t2m_bluetooth_speaker_is_on";
        while true; do
            STATUS=$(${DISCOVERY});
            if /bin/echo "$STATUS" | /bin/grep -q  "Connected: no"; then
                eval "$COPY_CONFIG1"; eval "$ALSA_RELOAD"; restart_mpd; set_volume "$volume";
                talk_2_me "$t2m_bluetooth_speaker_is_off";
                break;
            fi
            /bin/sleep "$DELAY_WAIT";
        done
    fi
    /bin/sleep "$DELAY_WAIT";
done
