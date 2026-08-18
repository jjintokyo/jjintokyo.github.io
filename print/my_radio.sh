#!/bin/sh

####################################################
# OpenWrtRadio - Internet Radio On A Tight Budget! #
####################################################
#                                                  #
#                   my_radio.sh                    #
#                                                  #
#--------------------------------------------------#
#        Handles the Trust Wireless Keypad         #
#    and the One For All URC3661 Remote Control    #
#--------------------------------------------------#
#   Output Sound to Internal Speakers with ALSA    #
#      or Bluetooth Speakers with PulseAudio       #
#--------------------------------------------------#
#                                                  #
#              JJR / Sun Apr 19 2026               #
#                                                  #
####################################################

page=1; preset=0; playlist_preset=1; previous_page=1; previous_preset=0; stop=0; volume=20; volume_step=1; mute=0;
my_pipe="/tmp/my_pipe"; input_devices="/dev/input/event*"; arduino="/dev/ttyUSB0";
find_my_mp3="/root/music/find_my_mp3.txt"; find_my_flac="/root/music/find_my_flac.txt";
pico2wave="/tmp/pico2wave.wav"; google_tts="/tmp/google_tts.wav"; test_1=0; test_2=0;

t2m_page="page"; t2m_preset="preset"; t2m_play="play"; t2m_random="random"; t2m_radio="radio"; t2m_stopped="stopped";
t2m_special="special"; t2m_number="number"; t2m_not_found="not found"; t2m_volume="volume"; t2m_up="up"; t2m_down="down";
t2m_percent="percent"; t2m_from="from"; t2m_mp3="m.p.3"; t2m_player="player"; t2m_list="list"; t2m_one="one"; t2m_two="two";
t2m_server="server"; t2m_dab="dab"; t2m_fm="f-m"; t2m_is_down="is down"; t2m_mute="mute"; t2m_unmute="un-mute";
t2m_flac="flac"; t2m_update_db="now. updating the data base... please wait a few minutes"; t2m_pds="power down system";
t2m_time="the time is..."; t2m_and="and"; t2m_hour="hour."; t2m_hours="hours.";
t2m_minute="minute."; t2m_minutes="minutes."; t2m_second="second"; t2m_seconds="seconds";
t2m_random_0="everything"; t2m_random_1="talk";    t2m_random_2="old";       t2m_random_3="alternative";  t2m_random_4="country";
t2m_random_5="oldies";     t2m_random_6="sixties"; t2m_random_7="seventies"; t2m_random_8="eighties";     t2m_random_9="nineties";
play_random_0="";          play_random_1="talk";   play_random_2="old";      play_random_3="alternative"; play_random_4="country";
play_random_5="oldies";    play_random_6="60";     play_random_7="70";       play_random_8="80";          play_random_9="90";

dab_server=0; dab_server_ip="192.168.1.222"; dab_server_url="http://${dab_server_ip}:1222";
dab_server_command="/usr/bin/sshpass -e /usr/bin/ssh -q -T -y -y root@${dab_server_ip} &>/dev/null";
dab_server_kill="'/usr/bin/pkill -9 welle-cli; /usr/bin/pkill -9 rtl_fm_streamer'";
dab_server_start="'cd /root/welle.io/build && ./welle-cli -c 7B -w 1222 -T &>/dev/null' &";
dab_server_shutdown="'/usr/bin/sudo /usr/sbin/shutdown -h now' &";
DAB_FRANCE_INFO="0xf206"; DAB_FRANCE_INTER="0xf201"; DAB_FIP="0xf204";          DAB_BFM_RADIO="0xf2fd";
DAB_EUROPE_1="0xf213";    DAB_EUROPE_2="0xf20e";     DAB_NOSTALGIE="0xf2fa";    DAB_RTL="0xf211";
DAB_RTL_2="0xf2f6";       DAB_SUD_RADIO="0xf650";    DAB_MELODY="0xf9f5";       DAB_MELODY_CH="0x4dfb";
DAB_IP_MUSIC_80="0x4dc0"; DAB_SPOON_ROCK="0x4dba";   DAB_LIFESTYLE_74="0x4da9"; DAB_OPTION_MUSIQUE="0x43d4";
DAB_COULEUR_3="0x43d3";   DAB_RTS_PREMIERE="0x43d1"; DAB_SWISS_POP="0x42f1";    DAB_SUISSE_CLASSIQUE="0x43f4";

fm_server=0; fm_server_ip="192.168.1.222"; fm_server_url="http://${fm_server_ip}:1222";
fm_server_command="/usr/bin/sshpass -e /usr/bin/ssh -q -T -y -y root@${fm_server_ip} &>/dev/null";
fm_server_kill="'/usr/bin/pkill -9 welle-cli; /usr/bin/pkill -9 rtl_fm_streamer'";
fm_server_start="'cd /root/rtl_fm_streamer/build/src && ./rtl_fm_streamer -P 1222 -g 30 &>/dev/null' &";
fm_server_shutdown="'/usr/bin/sudo /usr/sbin/shutdown -h now' &";
FM_FRANCE_INFO="101100000/0"; FM_FRANCE_INTER="94400000/0";  FM_RTL="107600000/1";             FM_SUD_RADIO="104000000/1";
FM_EUROPE_2="99600000/1";     FM_LA_RADIO_PLUS="93000000/1"; FM_RADIO_CLASSIQUE="102100000/1"; FM_LFM="103300000/1";
FM_RADIO_LAC="95600000/1";    FM_ONE_FM="107200000/1";

key_enter="*KEY_KPENTER	0	command*";
key_backspace="*KEY_BACKSPACE	0	command*";
key_minus="*KEY_KPMINUS	1	command*";
key_minus_2="*KEY_KPMINUS	2	command*";
key_plus="*KEY_KPPLUS	1	command*";
key_plus_2="*KEY_KPPLUS	2	command*";
key_dot="*KEY_KPDOT	0	command*";
key_equal="*KEY_LEFTALT	1	command*";
key_slash="*KEY_KPSLASH	0	command*";
key_asterisk="*KEY_KPASTERISK	0	command*";
key_calc="*KEY_CALC	0	command*";
key_tab="*KEY_TAB	0	command*";
key_esc="*KEY_ESC	0	command*";
key_0="*KEY_KP0	0	command*";
key_1="*KEY_KP1	0	command*";
key_2="*KEY_KP2	0	command*";
key_3="*KEY_KP3	0	command*";
key_4="*KEY_KP4	0	command*";
key_5="*KEY_KP5	0	command*";
key_6="*KEY_KP6	0	command*";
key_7="*KEY_KP7	0	command*";
key_8="*KEY_KP8	0	command*";
key_9="*KEY_KP9	0	command*";
key_calc_and_key_0="*KEY_CALC+KEY_KP0	1	command*";
key_calc_and_key_1="*KEY_CALC+KEY_KP1	1	command*";
key_calc_and_key_2="*KEY_CALC+KEY_KP2	1	command*";
key_calc_and_key_3="*KEY_CALC+KEY_KP3	1	command*";
key_calc_and_key_4="*KEY_CALC+KEY_KP4	1	command*";
key_calc_and_key_5="*KEY_CALC+KEY_KP5	1	command*";
key_calc_and_key_6="*KEY_CALC+KEY_KP6	1	command*";
key_calc_and_key_7="*KEY_CALC+KEY_KP7	1	command*";
key_calc_and_key_8="*KEY_CALC+KEY_KP8	1	command*";
key_calc_and_key_9="*KEY_CALC+KEY_KP9	1	command*";
key_backspace_and_key_dot="*KEY_BACKSPACE+KEY_KPDOT	1	command*";
key_backspace_and_key_calc="*KEY_BACKSPACE+KEY_CALC	1	command*";
key_backspace_and_key_enter="*KEY_BACKSPACE+KEY_KPENTER	1	command*";
key_enter_and_key_backspace="*KEY_KPENTER+KEY_BACKSPACE	1	command*";
key_backspace_and_key_1="*KEY_BACKSPACE+KEY_KP1	1	command*";
key_backspace_and_key_2="*KEY_BACKSPACE+KEY_KP2	1	command*";

PolaroidP2_KEY_PLAYCD="*KEY_PLAYCD	1	command*";
PolaroidP2_KEY_PAUSECD="*KEY_PAUSECD	1	command*";
PolaroidP2_KEY_PREVIOUSSONG="*KEY_PREVIOUSSONG	1	command*";
PolaroidP2_KEY_NEXTSONG="*KEY_NEXTSONG	1	command*";

REMOTE_POWER="E0E040BF";            REMOTE_SOURCE="E0E0807F";             REMOTE_CROSS_UP="E0E006F9";
REMOTE_CROSS_DOWN="E0E08679";       REMOTE_CROSS_LEFT="E0E0A659";         REMOTE_CROSS_RIGHT="E0E046B9";
REMOTE_CROSS_OK="E0E016E9";         REMOTE_VOLUME_UP="E0E0E01F";          REMOTE_VOLUME_DOWN="E0E0D02F";
REMOTE_MUTE="E0E0F00F";             REMOTE_CHANNEL_UP="E0E048B7";         REMOTE_CHANNEL_DOWN="E0E008F7";
REMOTE_CHANNEL_RECALL="E0E0C837";   REMOTE_PLAY="E0E0E21D";               REMOTE_PAUSE="E0E052AD";
REMOTE_STOP="E0E0629D";             REMOTE_RECORD="E0E0926D";             REMOTE_PREVIOUS="E0E0A25D";
REMOTE_NEXT="E0E012ED";             REMOTE_SUBT="E0E0A45B";               REMOTE_APPS="E0E09E61";
REMOTE_LIST="E0E09E61";             REMOTE_GUIDE="E0E0F20D";              REMOTE_INFO="E0E0F807";
REMOTE_MENU="E0E058A7";             REMOTE_BACK="E0E01AE5";               REMOTE_EXIT="E0E0B44B";
REMOTE_HOME="E0E09E61";             REMOTE_0="E0E08877";                  REMOTE_1="E0E020DF";
REMOTE_2="E0E0A05F";                REMOTE_3="E0E0609F";                  REMOTE_4="E0E010EF";
REMOTE_5="E0E0906F";                REMOTE_6="E0E050AF";                  REMOTE_7="E0E030CF";
REMOTE_8="E0E0B04F";                REMOTE_9="E0E0708F";                  REMOTE_TV="E0E0D827";
REMOTE_SEARCH="E0E058A7";           REMOTE_CIRCLE_RED="E0E036C9";         REMOTE_CIRCLE_GREEN="E0E028D7";
REMOTE_CIRCLE_YELLOW="E0E0A857";    REMOTE_CIRCLE_BLUE="E0E06897";        REMOTE_SQUARE_RED="E0E0CF30";
REMOTE_SQUARE_BLUE="E0E02FD0";      REMOTE_POWER_X="4B36D32C";            REMOTE_SOURCE_X="4B367887";
REMOTE_CROSS_UP_X="4BB641BE";       REMOTE_CROSS_DOWN_X="4BB6C13E";       REMOTE_CROSS_LEFT_X="4BB621DE";
REMOTE_CROSS_RIGHT_X="4BB6A15E";    REMOTE_CROSS_OK_X="4BB6E916";         REMOTE_VOLUME_UP_X="4BB640BF";
REMOTE_VOLUME_DOWN_X="4BB6C03F";    REMOTE_MUTE_X="4BB6A05F";             REMOTE_CHANNEL_UP_X="4BB600FF";
REMOTE_CHANNEL_DOWN_X="4BB6807F";   REMOTE_CHANNEL_RECALL_X="4B40BA45";   REMOTE_PLAY_X="4BB6A857";
REMOTE_PAUSE_X="4BB66897";          REMOTE_STOP_X="4BB6C837";             REMOTE_RECORD_X="4BB618E7";
REMOTE_PREVIOUS_X="4BB658A7";       REMOTE_NEXT_X="4BB69867";             REMOTE_INFO_X="4B36AA55";
REMOTE_MENU_X="4B40B24D";           REMOTE_EXIT_X="4B362AD5";             REMOTE_0_X="4BB650AF";
REMOTE_1_X="4BB6F00F";              REMOTE_2_X="4BB6708F";                REMOTE_3_X="4B3551AE";
REMOTE_4_X="4B40E11E";              REMOTE_5_X="4BB612ED";                REMOTE_6_X="4BB6F906";
REMOTE_7_X="4BB6906F";              REMOTE_8_X="4BB6D02F";                REMOTE_9_X="4B3631CE";

initialization ()      { /bin/echo "my_radio.sh is starting . . . . . `/bin/date`" > /dev/kmsg;
                         /bin/stty -F "$arduino" sane speed 9600;
                         /usr/bin/amixer sset "Speaker" unmute &>/dev/null;
                         /usr/bin/amixer sset "Speaker" 10%    &>/dev/null;
                         for i in $(/usr/bin/seq 1 5); do
                             STATUS=$(/usr/bin/hciconfig hci0);
                             if /bin/echo "$STATUS" | /bin/grep -q "DOWN"; then bt_dongle_reset;
                             else break; fi; done;
                         for i in $(/usr/bin/seq 1 30); do
                             /usr/bin/aplay --quiet "/root/my_radio/CONNECT.WAV" &>/dev/null;
                             /bin/ping -c1 -W2 google.com &>/dev/null && break;
                             /bin/sleep 1; done;
                         /usr/sbin/ntpd -n -q -p 0.openwrt.pool.ntp.org -p 1.openwrt.pool.ntp.org \
                                              -p 2.openwrt.pool.ntp.org &>/dev/null;
                         /etc/init.d/uhttpd  stop    &>/dev/null;
                         /etc/init.d/uhttpd  disable &>/dev/null;
                         /etc/init.d/apache2 enable  &>/dev/null;
                         /etc/init.d/apache2 start   &>/dev/null;
                         /etc/init.d/mpd     stop    &>/dev/null;
                         /bin/mkdir -p /tmp/.mpd; /bin/touch /tmp/.mpd/log; /bin/chmod 666 /tmp/.mpd/log;
                         /etc/init.d/mpd     start   &>/dev/null;
                         /bin/sleep 5; set_mpd_presets; set_audio_bluetooth;
                       }
bt_dongle_reset ()     { ### VENDOR="0bda"; PRODUCT="a725";
                         ### VENDOR="2357"; PRODUCT="0604";
                         VENDOR="0a12"; PRODUCT="0001";
                         for DIR in $(/usr/bin/find /sys/bus/usb/devices/ -maxdepth 1 -type l); do
                             if [ -f $DIR/idVendor ] && [ -f $DIR/idProduct ] &&
                                [ $(/bin/cat $DIR/idVendor) == $VENDOR ]      &&
                                [ $(/bin/cat $DIR/idProduct) == $PRODUCT ]; then
                                 /bin/echo 0 > $DIR/authorized; /bin/sleep 3;
                                 /bin/echo 1 > $DIR/authorized; /bin/sleep 3; fi; done;
                       }
bluetooth_latency ()   { card_name=$(/usr/bin/pactl list cards short | /bin/grep -o bluez.*[[:space:]]);
                         port_name=$(/usr/bin/pactl list     | \
                                     /bin/grep '\-output:'   | \
                                     /usr/bin/head -n1       | \
                                     /usr/bin/cut -d ":" -f1 | \
                                     /usr/bin/xargs);
                         if [ "$card_name" != "" ] && [ "$port_name" != "" ]; then
                             latency_offset=100000;
                             /usr/bin/pactl set-port-latency-offset ${card_name} ${port_name} ${latency_offset}; fi;
                       }
set_mpd_presets ()     {                                       /usr/bin/mpc clear      &>/dev/null;
                         /bin/cat /root/my_radio/playlist.db | /usr/bin/mpc add        &>/dev/null;
                                                               /usr/bin/mpc repeat on  &>/dev/null;
                                                               /usr/bin/mpc volume 100 &>/dev/null;
                       }
set_audio_alsa ()      { bluetooth_audio=0; stop_radio;
                         /usr/bin/mpc disable bluetooth &>/dev/null;
                         /usr/bin/mpc enable  alsa      &>/dev/null;
                         /usr/bin/aplay --quiet "/root/my_radio/CONNECTED.WAV" &>/dev/null;
                         set_audio_common;
                       }
set_audio_bluetooth () { bluetooth_audio=1; stop_radio;
                         /usr/bin/mpc disable alsa      &>/dev/null;
                         /usr/bin/mpc enable  bluetooth &>/dev/null;
                         bluetooth_speaker=$(/bin/cat /root/my_radio/bluetooth_speaker);
                         if [ "$bluetooth_speaker" != "" ]; then
                             status=$(/usr/bin/bluetoothctl info "$bluetooth_speaker");
                             if ! /bin/echo "$status" | /bin/grep -q "Connected: yes"; then
                                 /usr/bin/bluetoothctl pair    "$bluetooth_speaker" &>/dev/null; /bin/sleep 1;
                                 /usr/bin/bluetoothctl trust   "$bluetooth_speaker" &>/dev/null; /bin/sleep 1;
                                 /usr/bin/bluetoothctl connect "$bluetooth_speaker" &>/dev/null; /bin/sleep 1; fi; fi;
                         status=$(/usr/bin/bluetoothctl info "$bluetooth_speaker");
                         if /bin/echo "$status" | /bin/grep -q "Connected: yes"; then
                             bluetooth_speaker_is_on=1;
                             /usr/bin/paplay --device=@DEFAULT_SINK@ "/root/my_radio/CONNECTED.WAV" &>/dev/null;
                             bluetooth_latency;
                         else bluetooth_speaker_is_on=0; fi;
                         set_audio_common;
                       }
set_audio_common ()    { /bin/echo "$bluetooth_audio" > "/root/my_radio/bluetooth_audio";
                         set_volume "$volume"; if [ "$bluetooth_speaker_is_on" -eq 1 ]; then play_preset "$preset"; fi;
                       }
talk_2_me ()           { if [ "$stop" -eq 1 ]; then /usr/bin/pico2wave -w "$pico2wave" -l "en-GB" \
                                                    "<volume level='80'><pitch level='133'><speed level='144'> ... $1";
                             bluetooth_audio=$(/bin/cat /root/my_radio/bluetooth_audio);
                             if [ "$bluetooth_audio" -eq 0 ]; then
                                 /usr/bin/aplay --quiet "$pico2wave" &>/dev/null;
                             else
                                 /usr/bin/paplay --device=@DEFAULT_SINK@ "$pico2wave" &>/dev/null; fi; fi;
                       }
google_tts ()          { string=$(/bin/echo "hmm . $1" | /bin/sed 's/ /%20/g');
                         /usr/bin/wget --quiet -O - -U "stream-mp3/mpg123/0.59r" \
                         "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$string&tl=en" | \
                         /usr/bin/madplay --very-quiet --output=wave:- - > "$google_tts";
                         bluetooth_audio=$(/bin/cat /root/my_radio/bluetooth_audio);
                         if [ "$bluetooth_audio" -eq 0 ]; then
                             /usr/bin/aplay --quiet "$google_tts" &>/dev/null;
                         else
                             /usr/bin/paplay --device=@DEFAULT_SINK@ "$google_tts" &>/dev/null; fi;
                       }
page_up ()             { page=$((${page}+1)); if [ "$page" -eq 10 ]; then page=1; fi; say_page;
                       }
page_down ()           { page=$((${page}-1)); if [ "$page" -eq  0 ]; then page=9; fi; say_page;
                       }
say_page ()            {   if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ];
                                                 then talk_2_me "$t2m_page $page";
                         elif [ "$page" -eq 5 ]; then talk_2_me "$t2m_random $t2m_page";
                         elif [ "$page" -eq 6 ]; then talk_2_me "$t2m_mp3 $t2m_player";
                         elif [ "$page" -eq 7 ]; then talk_2_me "$t2m_dab $t2m_server $t2m_page $t2m_one";
                         elif [ "$page" -eq 8 ]; then talk_2_me "$t2m_dab $t2m_server $t2m_page $t2m_two";
                         elif [ "$page" -eq 9 ]; then talk_2_me "$t2m_fm $t2m_server"; fi;
                       }
preset_up ()           { preset=$((${preset}+1)); if [ "$preset" -eq 10 ]; then preset=0; fi; say_preset "$preset";
                       }
preset_down ()         { preset=$((${preset}-1)); if [ "$preset" -lt  0 ]; then preset=9; fi; say_preset "$preset";
                       }
say_preset ()          {   if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ] ||
                              [ "$page" -eq 7 ] || [ "$page" -eq 8 ] || [ "$page" -eq 9 ];
                                                 then                           talk_2_me "$t2m_preset $preset";
                         elif [ "$page" -eq 5 ]; then what_say_genre "$preset"; talk_2_me "$t2m_random $say";
                         elif [ "$page" -eq 6 ]; then                           talk_2_me "$t2m_mp3"; fi;
                       }
volume_up ()           { volume=$((${volume}+${1})); if [ "$volume" -gt 100 ]; then volume=100; else set_volume "$volume";
                         if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_volume $t2m_up   $volume $t2m_percent"; fi; fi;
                       }
volume_down ()         { volume=$((${volume}-${1})); if [ "$volume" -lt   0 ]; then volume=0;   else set_volume "$volume";
                         if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_volume $t2m_down $volume $t2m_percent"; fi; fi;
                       }
set_volume ()          { bluetooth_audio=$(/bin/cat /root/my_radio/bluetooth_audio);
                         if [ "$bluetooth_audio" -eq 0 ]; then
                             /usr/bin/amixer sset "Speaker" "$1"% &>/dev/null;
                         else
                             /usr/bin/pactl set-sink-volume @DEFAULT_SINK@ "$1"% &>/dev/null; fi;
                       }
set_sound_on ()        { bluetooth_audio=$(/bin/cat /root/my_radio/bluetooth_audio);
                         if [ "$bluetooth_audio" -eq 0 ]; then /usr/bin/amixer sset "Speaker" unmute &>/dev/null;
                                                          else /usr/bin/pactl set-sink-mute @DEFAULT_SINK@ false &>/dev/null; fi;
                       }
set_sound_off ()       { bluetooth_audio=$(/bin/cat /root/my_radio/bluetooth_audio);
                         if [ "$bluetooth_audio" -eq 0 ]; then /usr/bin/amixer sset "Speaker" mute   &>/dev/null;
                                                          else /usr/bin/pactl set-sink-mute @DEFAULT_SINK@ true  &>/dev/null; fi;
                       }
set_mute ()            { if [ "$mute" -eq 0 ]; then talk_2_me "$t2m_radio $t2m_mute"; mute=1; set_sound_off;
                                               else set_sound_on; mute=0; talk_2_me "$t2m_radio $t2m_unmute"; fi;
                       }
stop_radio ()          { /usr/bin/mpc stop &>/dev/null; /usr/bin/killall -q -9 wget;
                       }
radio_play_stop ()     { if [ "$stop" -eq 0 ]; then stop=1; stop_radio; talk_2_me "$t2m_radio $t2m_stopped";
                                               else                     talk_2_me "$t2m_radio $t2m_play"; stop=0;
                               if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ] ||
                                  [ "$page" -eq 5 ] || [ "$page" -eq 6 ]; then /usr/bin/mpc play &>/dev/null;
                             elif [ "$page" -eq 7 ];                      then play_dab "1" "$preset";
                             elif [ "$page" -eq 8 ];                      then play_dab "2" "$preset";
                             elif [ "$page" -eq 9 ];                      then play_fm      "$preset"; fi; fi;
                       }
play_preset ()         { preset="$1"; stop_radio; previous_page="$page"; previous_preset="$preset";
                           if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] ||
                              [ "$page" -eq 4 ]; then kill_dab_fm_server;
                                                      talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_page $page";
                                                      playlist_preset="$((($preset+(($page-1))*10)+1))";
                                                      /usr/bin/mpc play "$playlist_preset" &>/dev/null; stop=0;
                         elif [ "$page" -eq 5 ]; then kill_dab_fm_server; random_by_genre "$preset";
                         elif [ "$page" -eq 6 ]; then kill_dab_fm_server; play_mp3;
                         elif [ "$page" -eq 7 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_dab $t2m_server \
                                                                 $t2m_page $t2m_one";
                                                      play_dab "1" "$preset";
                         elif [ "$page" -eq 8 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_dab $t2m_server \
                                                                 $t2m_page $t2m_two";
                                                      play_dab "2" "$preset";
                         elif [ "$page" -eq 9 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_fm $t2m_server";
                                                      play_fm "$preset"; fi;
                       }
play_special ()        { stop_radio; record_number=$((${1}+1));
                         special=$(/bin/sed -n "$record_number"p /root/my_radio/special.db);
                         if [ "$special" != "" ]; then
                             talk_2_me "$t2m_play $t2m_special $t2m_radio $t2m_number $1";
                             /usr/bin/mpc del  41         &>/dev/null;
                             /usr/bin/mpc add  "$special" &>/dev/null;
                             /usr/bin/mpc play 41         &>/dev/null;
                             ok=$(/bin/echo $?); /bin/sleep 1; status=$(/usr/bin/mpc status);
                             if ! /bin/echo "$status" | /bin/grep -q "ERROR: Failed" && [ "$ok" -eq 0 ]; then
                                 stop=0; return 0; fi; fi;
                         stop=1; talk_2_me "$t2m_special $t2m_radio $t2m_number $1 $t2m_not_found"; /bin/sleep 1;
                       }
play_next ()           { if [ "$stop" -eq 0 ]; then
                               if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ] ||
                                  [ "$page" -eq 5 ]; then /usr/bin/mpc next &>/dev/null;
                             elif [ "$page" -eq 6 ]; then play_mp3; fi;
                         else say_time_and_temp; fi;
                       }
play_previous ()       { if [ "$stop" -eq 0 ]; then
                               if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ] ||
                                  [ "$page" -eq 5 ]; then /usr/bin/mpc prev &>/dev/null;
                             elif [ "$page" -eq 6 ]; then play_mp3; fi;
                         else say_time_and_temp; fi;
                       }
what_say_genre ()      { say=""; genre="";
                           if [ "$1" -eq  0 ]; then say="$t2m_random_0"; genre="$play_random_0";
                         elif [ "$1" -eq  1 ]; then say="$t2m_random_1"; genre="$play_random_1";
                         elif [ "$1" -eq  2 ]; then say="$t2m_random_2"; genre="$play_random_2";
                         elif [ "$1" -eq  3 ]; then say="$t2m_random_3"; genre="$play_random_3";
                         elif [ "$1" -eq  4 ]; then say="$t2m_random_4"; genre="$play_random_4";
                         elif [ "$1" -eq  5 ]; then say="$t2m_random_5"; genre="$play_random_5";
                         elif [ "$1" -eq  6 ]; then say="$t2m_random_6"; genre="$play_random_6";
                         elif [ "$1" -eq  7 ]; then say="$t2m_random_7"; genre="$play_random_7";
                         elif [ "$1" -eq  8 ]; then say="$t2m_random_8"; genre="$play_random_8";
                         elif [ "$1" -eq  9 ]; then say="$t2m_random_9"; genre="$play_random_9";
                         elif [ "$1" -eq 10 ]; then say="$stuff";        genre="$stuff"; fi;
                       }
random_by_genre ()     { what_say_genre "$1"; talk_2_me "$t2m_play $t2m_random $say";
                         while true; do
                             cmd=$(/root/my_radio/random_run.py "$genre");
                             if [ "$cmd" == "Nothing Found!" ]; then talk_2_me "$cmd"; break; fi;
                             url=$(/bin/echo ${cmd} | /usr/bin/cut -f1 -d' ');
                             /usr/bin/mpc del  41     &>/dev/null;
                             /usr/bin/mpc add  "$url" &>/dev/null;
                             /usr/bin/mpc play 41     &>/dev/null;
                             ok=$(/bin/echo $?); /bin/sleep 1; status=$(/usr/bin/mpc status);
                             if ! /bin/echo "$status" | /bin/grep -q "ERROR: Failed" && [ "$ok" -eq 0 ]; then
                                 /bin/echo "$url"; break; fi; done; stop=0;
                       }
random_everything ()   { page=5; stop_radio; talk_2_me "$t2m_random $t2m_play"; /root/my_radio/random_run.sh; stop=0;
                       }
random_stuff ()        { page=5; stop_radio;
                         if [ "$1" -eq 1 ]; then stuff=$(/bin/cat /root/my_radio/random_stuff_1); fi;
                         if [ "$1" -eq 2 ]; then stuff=$(/bin/cat /root/my_radio/random_stuff_2); fi;
                         if [ "$1" -eq 3 ]; then stuff=$(/bin/cat /root/my_radio/random_stuff_3); fi;
                         if [ "$stuff" != "" ]; then random_by_genre "10"; fi;
                       }
play_mp3 ()            { page=6; preset=0; stop_radio; talk_2_me "$t2m_play $t2m_random $t2m_mp3";
                         if [ "$mp3_pid" != "" ]; then /bin/kill "$mp3_pid" &>/dev/null; fi;
                         if [ ! -f "$find_my_mp3" ]; then
                             cd "/root/music" && /usr/bin/find mp3/ -type f -iname "*.mp3" > "$find_my_mp3"; fi;
                         number_of_mp3=$(/bin/cat "$find_my_mp3" | /usr/bin/wc -l);
                         very_long_command='                                                                                   \
                         while true; do                                                                                        \
                             random_mp3=$(/usr/bin/awk -v NB="$number_of_mp3" "BEGIN{ srand(); print int(rand() * NB + 1) }"); \
                             if [ "$random_mp3" -ge 1 ] && [ "$random_mp3" -le "$number_of_mp3" ]; then                        \
                                 mp3=$(/usr/bin/head -n "$random_mp3" "$find_my_mp3" | /usr/bin/tail -n1);                     \
                                 if [ "$mp3" != "" ]; then                                                                     \
                                     /usr/bin/mpc repeat on     &>/dev/null;                                                   \
                                     /usr/bin/mpc del    41     &>/dev/null;                                                   \
                                     /usr/bin/mpc add    "$mp3" &>/dev/null;                                                   \
                                     /usr/bin/mpc play   41     &>/dev/null;                                                   \
                                     /bin/sleep 3; status=$(/usr/bin/mpc current --wait);                                      \
                                     if [ "$status" == "" ]; then break; fi;                                                   \
                                 fi;                                                                                           \
                             fi;                                                                                               \
                         done';
                         eval "${very_long_command} &"; mp3_pid=$(/bin/echo $!); stop=0;
                       }
play_flac ()           { page=6; preset=0; stop_radio; talk_2_me "$t2m_play $t2m_random $t2m_flac";
                         if [ "$flac_pid" != "" ]; then /bin/kill "$flac_pid" &>/dev/null; fi;
                         if [ ! -f "$find_my_flac" ]; then
                             cd "/root/music" && /usr/bin/find others/flac/ -type f -iname "*.flac" > "$find_my_flac"; fi;
                         number_of_flac=$(/bin/cat "$find_my_flac" | /usr/bin/wc -l);
                         very_long_command='                                                                                     \
                         while true; do                                                                                          \
                             random_flac=$(/usr/bin/awk -v NB="$number_of_flac" "BEGIN{ srand(); print int(rand() * NB + 1) }"); \
                             if [ "$random_flac" -ge 1 ] && [ "$random_flac" -le "$number_of_flac" ]; then                       \
                                 flac=$(/usr/bin/head -n "$random_flac" "$find_my_flac" | /usr/bin/tail -n1);                    \
                                 if [ "$flac" != "" ]; then                                                                      \
                                     /usr/bin/mpc repeat on      &>/dev/null;                                                    \
                                     /usr/bin/mpc del    41      &>/dev/null;                                                    \
                                     /usr/bin/mpc add    "$flac" &>/dev/null;                                                    \
                                     /usr/bin/mpc play   41      &>/dev/null;                                                    \
                                     /bin/sleep 3; status=$(/usr/bin/mpc current --wait);                                        \
                                     if [ "$status" == "" ]; then break; fi;                                                     \
                                 fi;                                                                                             \
                             fi;                                                                                                 \
                         done';
                         eval "${very_long_command} &"; flac_pid=$(/bin/echo $!); stop=0;
                       }
dab_channel ()         { if [ "$1" != "$old_dab_channel" ]; then
                             /usr/bin/curl -X POST --data "$1" "$dab_server_url/channel" &>/dev/null;
                             /bin/sleep 17; old_dab_channel="$1"; fi;
                       }
play_dab ()            { if /bin/ping -c1 -W2 "$dab_server_ip" &>/dev/null; then
                             if [ "$dab_server" -eq 0 ]; then dab_server=1; fm_server=0; old_dab_channel="7B";
                                 eval "${dab_server_command} ${dab_server_kill}";  /bin/sleep 1;
                                 eval "${dab_server_command} ${dab_server_start}"; /bin/sleep 15; fi;
                               if [ "$1" == "1" ] && [ "$2" == "0" ]; then dab_channel "7B";  dab_radio="$DAB_FRANCE_INFO";
                             elif [ "$1" == "1" ] && [ "$2" == "1" ]; then dab_channel "7B";  dab_radio="$DAB_FRANCE_INTER";
                             elif [ "$1" == "1" ] && [ "$2" == "2" ]; then dab_channel "7B";  dab_radio="$DAB_FIP";
                             elif [ "$1" == "1" ] && [ "$2" == "3" ]; then dab_channel "7B";  dab_radio="$DAB_BFM_RADIO";
                             elif [ "$1" == "1" ] && [ "$2" == "4" ]; then dab_channel "7B";  dab_radio="$DAB_EUROPE_1";
                             elif [ "$1" == "1" ] && [ "$2" == "5" ]; then dab_channel "7B";  dab_radio="$DAB_EUROPE_2";
                             elif [ "$1" == "1" ] && [ "$2" == "6" ]; then dab_channel "7A";  dab_radio="$DAB_NOSTALGIE";
                             elif [ "$1" == "1" ] && [ "$2" == "7" ]; then dab_channel "7A";  dab_radio="$DAB_RTL";
                             elif [ "$1" == "1" ] && [ "$2" == "8" ]; then dab_channel "7A";  dab_radio="$DAB_RTL_2";
                             elif [ "$1" == "1" ] && [ "$2" == "9" ]; then dab_channel "7C";  dab_radio="$DAB_SUD_RADIO";
                             elif [ "$1" == "2" ] && [ "$2" == "0" ]; then dab_channel "7C";  dab_radio="$DAB_MELODY";
                             elif [ "$1" == "2" ] && [ "$2" == "1" ]; then dab_channel "10C"; dab_radio="$DAB_MELODY_CH";
                             elif [ "$1" == "2" ] && [ "$2" == "2" ]; then dab_channel "10C"; dab_radio="$DAB_IP_MUSIC_80";
                             elif [ "$1" == "2" ] && [ "$2" == "3" ]; then dab_channel "10C"; dab_radio="$DAB_SPOON_ROCK";
                             elif [ "$1" == "2" ] && [ "$2" == "4" ]; then dab_channel "8C";  dab_radio="$DAB_LIFESTYLE_74";
                             elif [ "$1" == "2" ] && [ "$2" == "5" ]; then dab_channel "12A"; dab_radio="$DAB_OPTION_MUSIQUE";
                             elif [ "$1" == "2" ] && [ "$2" == "6" ]; then dab_channel "12A"; dab_radio="$DAB_COULEUR_3";
                             elif [ "$1" == "2" ] && [ "$2" == "7" ]; then dab_channel "12A"; dab_radio="$DAB_RTS_PREMIERE";
                             elif [ "$1" == "2" ] && [ "$2" == "8" ]; then dab_channel "12A"; dab_radio="$DAB_SWISS_POP";
                             elif [ "$1" == "2" ] && [ "$2" == "9" ]; then dab_channel "12A";
                                                                           dab_radio="$DAB_SUISSE_CLASSIQUE"; fi;
                             play_me="${dab_server_url}/mp3/${dab_radio}";
                             /usr/bin/mpc del  41         &>/dev/null;
                             /usr/bin/mpc add  "$play_me" &>/dev/null;
                             /usr/bin/mpc play 41         &>/dev/null;
                             stop=0;
                         else stop_radio; stop=1; talk_2_me "$t2m_dab $t2m_server $t2m_is_down"; fi;
                       }
play_fm ()             { if /bin/ping -c1 -W2 "$fm_server_ip" &>/dev/null; then
                             if [ "$fm_server" -eq 0 ]; then fm_server=1; dab_server=0;
                                 eval "${fm_server_command} ${fm_server_kill}";  /bin/sleep 1;
                                 eval "${fm_server_command} ${fm_server_start}"; /bin/sleep 10; fi;
                               if [ "$1" == "0" ]; then channels=1; fm_radio="$FM_FRANCE_INFO";
                             elif [ "$1" == "1" ]; then channels=1; fm_radio="$FM_FRANCE_INTER";
                             elif [ "$1" == "2" ]; then channels=2; fm_radio="$FM_RTL";
                             elif [ "$1" == "3" ]; then channels=2; fm_radio="$FM_SUD_RADIO";
                             elif [ "$1" == "4" ]; then channels=2; fm_radio="$FM_EUROPE_2";
                             elif [ "$1" == "5" ]; then channels=2; fm_radio="$FM_LA_RADIO_PLUS";
                             elif [ "$1" == "6" ]; then channels=2; fm_radio="$FM_RADIO_CLASSIQUE";
                             elif [ "$1" == "7" ]; then channels=2; fm_radio="$FM_LFM";
                             elif [ "$1" == "8" ]; then channels=2; fm_radio="$FM_RADIO_LAC";
                             elif [ "$1" == "9" ]; then channels=2; fm_radio="$FM_ONE_FM"; fi;
                             bluetooth_audio=$(/bin/cat /root/my_radio/bluetooth_audio);
                             if [ "$bluetooth_audio" -eq 0 ]; then
                                 play_me="/usr/bin/aplay --quiet -t raw -r 48000 -c ${channels} -f S16_LE";
                             else
                                 play_me="/usr/bin/paplay --raw --rate=48000 --channels=${channels} \
                                                          --format=s16le --device=@DEFAULT_SINK@"; fi;
                             /usr/bin/wget --quiet -O - "${fm_server_url}/${fm_radio}" | ${play_me} & stop=0;
                         else stop_radio; stop=1; talk_2_me "$t2m_fm $t2m_server $t2m_is_down"; fi;
                       }
kill_dab_fm_server ()  { if [ "$dab_server" -eq 1 ] || [ "$fm_server" -eq 1 ]; then
                             dab_server=0; fm_server=0; eval "${dab_server_command} ${dab_server_kill}"; fi;
                       }
say_time_and_temp ()   { if [ "$stop" -eq 1 ]; then h=$(date +'%-H'); m=$(date +'%-M'); s=$(date +'%-S');
                             if [ "$h" -gt 1 ]; then hour="$t2m_hours";     else hour="$t2m_hour"; fi;
                             if [ "$m" -gt 1 ]; then minute="$t2m_minutes"; else minute="$t2m_minute"; fi;
                             if [ "$s" -gt 1 ]; then second="$t2m_seconds"; else second="$t2m_second"; fi;
                             out_temp=$(/usr/bin/curl -sf \
                             "http://api.openweathermap.org/data/2.5/weather?q=LOCATION&units=metric&appid=APPID" | \
                             /usr/bin/jq -r '.main.temp' | /usr/bin/cut -d'.' -f1);
                             play_me="$t2m_time $h $hour $m $minute $t2m_and $s $second $t2m_and the outside temperature is \
                                      $out_temp degrees celcius!"; google_tts "$play_me"; fi;
                       }
say_song_name ()       { if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ] ||
                            [ "$page" -eq 5 ] || [ "$page" -eq 6 ]; then
                             if [ "$stop" -eq 0 ]; then
                                 if [ "$page" -ne 6 ]; then
                                     data=$(/usr/bin/mpc current -f %title%);
                                     if [ "$data" == "" ] || [ "$data" == " " ]; then
                                         data=$(/usr/bin/mpc current -f %name%); fi;
                                 else
                                     data=$(/usr/bin/mpc current); fi;
                                 current_song=$(/bin/echo "$data" | /bin/sed 's/&/and/g');
                                 /usr/bin/mpc pause &>/dev/null;
                                 google_tts "$current_song";
                                 /usr/bin/mpc play  &>/dev/null; fi; fi;
                       }
update_database ()     { stop_radio; stop=1;
                         bluetooth_audio=$(/bin/cat /root/my_radio/bluetooth_audio);
                         if [ "$bluetooth_audio" -eq 0 ]; then
                             play_me="/usr/bin/aplay --quiet '/root/my_radio/DIVE.WAV' &>/dev/null";
                         else
                             play_me="/usr/bin/paplay --device=@DEFAULT_SINK@ '/root/my_radio/DIVE.WAV' &>/dev/null"; fi;
                         for i in $(/usr/bin/seq 1 3); do eval "$play_me"; done;
                         talk_2_me "$t2m_update_db"; /root/my_radio/random_set.sh &>/dev/null &
                       }
power_down_system ()   { if [ "$stop" -eq 1 ]; then stop_radio;
                             bluetooth_audio=$(/bin/cat /root/my_radio/bluetooth_audio);
                             if [ "$bluetooth_audio" -eq 0 ]; then
                                 play_me="/usr/bin/aplay --quiet '/root/my_radio/BELL.WAV' &>/dev/null";
                             else
                                 play_me="/usr/bin/paplay --device=@DEFAULT_SINK@ '/root/my_radio/BELL.WAV' &>/dev/null"; fi;
                             for i in $(/usr/bin/seq 1 3); do eval "$play_me"; done;
                             talk_2_me "$t2m_pds"; eval "${dab_server_command} ${dab_server_shutdown}"; /sbin/poweroff; fi;
                       }
PolaroidP2_PLAY ()     { stop_radio; talk_2_me "$t2m_play $t2m_play $t2m_list $t2m_preset $playlist_preset";
                         /usr/bin/mpc play "$playlist_preset" &>/dev/null; stop=0;
                       }
PolaroidP2_PAUSE ()    { stop_radio; stop=1; talk_2_me "$t2m_radio $t2m_stopped";
                       }
PolaroidP2_PREVIOUS () { playlist_preset=$((${playlist_preset}-1)); if [ "$playlist_preset" -le  0 ]; then playlist_preset=41; fi;
                         if [ "$stop" -eq 0 ]; then play_previous;
                                               else talk_2_me "$t2m_play $t2m_list $t2m_preset $playlist_preset"; fi;
                       }
PolaroidP2_NEXT ()     { playlist_preset=$((${playlist_preset}+1)); if [ "$playlist_preset" -ge 42 ]; then playlist_preset=1;  fi;
                         if [ "$stop" -eq 0 ]; then play_next;
                                               else talk_2_me "$t2m_play $t2m_list $t2m_preset $playlist_preset"; fi;
                       }
channel_recall ()      { stop_radio; page="$previous_page"; preset="$previous_preset"; play_preset "$preset";
                       }
go_direct_1 ()         { stop_radio; page=1; preset=0; playlist_preset=1; stop=0;
                                                       /usr/bin/mpc play "$playlist_preset" &>/dev/null;
                       }
go_direct_2 ()         { stop_radio; page=5; preset=5; random_by_genre "$preset";
                       }
go_direct_3 ()         { play_mp3;
                       }
go_direct_4 ()         { play_flac;
                       }
go_test_1 ()           { stop_radio;
                         if [ "$test_1" -eq 0 ]; then test_1=1;
                             bluetooth_audio=$(/bin/cat /root/my_radio/bluetooth_audio);
                             if [ "$bluetooth_audio" -eq 0 ]; then
                                 command="/usr/bin/speaker-test -D"hw:0,0" -c2 -twav &>/dev/null";
                             else
                                 command="while true; do /usr/bin/paplay --device=@DEFAULT_SINK@ --channel-map=front-left  \
                                                                         /usr/share/sounds/alsa/Front_Left.wav;            \
                                                         /bin/sleep 1;                                                     \
                                                         /usr/bin/paplay --device=@DEFAULT_SINK@ --channel-map=front-right \
                                                                         /usr/share/sounds/alsa/Front_Right.wav;           \
                                                         /bin/sleep 1; done"; fi;
                             eval "$command &"; pid=$(/bin/echo $!); stop=0;
                         else
                             test_1=0; /bin/kill "$pid"; stop=1; fi;
                       }
go_test_2 ()           { stop_radio; test_2=$((${test_2}+1)); if [ "$test_2" -eq 9 ]; then test_2=1; fi;
                           if [ "$test_2" -eq 1 ]; then test_song="others/test/Take_Five.flac";
                         elif [ "$test_2" -eq 2 ]; then test_song="others/test/Antonio_Vivaldi_The_Four_Seasons.flac";
                         elif [ "$test_2" -eq 3 ]; then test_song="others/test/01_Orinoco_Flow.flac";
                         elif [ "$test_2" -eq 4 ]; then test_song="others/test/02_Caribbean_Blue.flac";
                         elif [ "$test_2" -eq 5 ]; then test_song="others/test/Hotel_California.flac";
                         elif [ "$test_2" -eq 6 ]; then test_song="others/test/Money_For_Nothing.flac";
                         elif [ "$test_2" -eq 7 ]; then test_song="others/test/Pink_Floyd_High_Hopes.flac";
                         elif [ "$test_2" -eq 8 ]; then test_song="others/test/rainstorm.mp3"; fi; stop=0;
                         /usr/bin/mpc del  41           &>/dev/null;
                         /usr/bin/mpc add  "$test_song" &>/dev/null;
                         /usr/bin/mpc play 41           &>/dev/null;
                       }

initialization;

while true; do
    /usr/bin/killall -q -9 thd; /usr/bin/killall -q -9 dd; /bin/sleep 1; /bin/rm -f "$my_pipe"; /usr/bin/mkfifo "$my_pipe";
    /usr/sbin/thd --dump ${input_devices} > "$my_pipe" 2>&1 &
    /bin/dd if="$arduino" of="$my_pipe" &
    while read data; do
        case ${data} in
            ($key_enter)                          page_up                                                 ;;
            ($key_backspace)                      page_down                                               ;;
            ($key_plus)                           volume_up                "$volume_step"                 ;;
            ($key_plus_2)                         volume_up                "$(($volume_step*2))"          ;;
            ($key_minus)                          volume_down              "$volume_step"                 ;;
            ($key_minus_2)                        volume_down              "$(($volume_step*2))"          ;;
            ($key_dot)                            radio_play_stop                                         ;;
            ($key_equal)                          say_song_name;           break                          ;;
            ($key_slash)                          play_next                                               ;;
            ($key_asterisk)                       play_previous                                           ;;
            ($key_calc)                           random_everything                                       ;;
            ($key_tab)                            random_stuff "1"                                        ;;
            ($key_esc)                            random_stuff "2"                                        ;;
            ($key_0)                              play_preset  "0"                                        ;;
            ($key_1)                              play_preset  "1"                                        ;;
            ($key_2)                              play_preset  "2"                                        ;;
            ($key_3)                              play_preset  "3"                                        ;;
            ($key_4)                              play_preset  "4"                                        ;;
            ($key_5)                              play_preset  "5"                                        ;;
            ($key_6)                              play_preset  "6"                                        ;;
            ($key_7)                              play_preset  "7"                                        ;;
            ($key_8)                              play_preset  "8"                                        ;;
            ($key_9)                              play_preset  "9"                                        ;;
            ($key_calc_and_key_0)                 play_special "0";        break                          ;;
            ($key_calc_and_key_1)                 play_special "1";        break                          ;;
            ($key_calc_and_key_2)                 play_special "2";        break                          ;;
            ($key_calc_and_key_3)                 play_special "3";        break                          ;;
            ($key_calc_and_key_4)                 play_special "4";        break                          ;;
            ($key_calc_and_key_5)                 play_special "5";        break                          ;;
            ($key_calc_and_key_6)                 play_special "6";        break                          ;;
            ($key_calc_and_key_7)                 play_special "7";        break                          ;;
            ($key_calc_and_key_8)                 play_special "8";        break                          ;;
            ($key_calc_and_key_9)                 play_special "9";        break                          ;;
            ($key_backspace_and_key_calc)         update_database;         break                          ;;
            ($key_backspace_and_key_dot)          power_down_system;       break                          ;;
            ($key_backspace_and_key_1)            set_audio_alsa;          break                          ;;
            ($key_backspace_and_key_2)            set_audio_bluetooth;     break                          ;;
            ($key_backspace_and_key_enter    |\
             $key_enter_and_key_backspace)                                 break                          ;;
            ($PolaroidP2_KEY_PLAYCD)              PolaroidP2_PLAY                                         ;;
            ($PolaroidP2_KEY_PAUSECD)             PolaroidP2_PAUSE                                        ;;
            ($PolaroidP2_KEY_PREVIOUSSONG)        PolaroidP2_PREVIOUS                                     ;;
            ($PolaroidP2_KEY_NEXTSONG)            PolaroidP2_NEXT                                         ;;
            ($REMOTE_CROSS_UP                |\
             $REMOTE_CHANNEL_UP)                  page_up                                                 ;;
            ($REMOTE_CROSS_DOWN              |\
             $REMOTE_CHANNEL_DOWN)                page_down                                               ;;
            ($REMOTE_CROSS_RIGHT)                 preset_up                                               ;;
            ($REMOTE_CROSS_LEFT)                  preset_down                                             ;;
            ($REMOTE_CROSS_OK                |\
             $REMOTE_PLAY)                        play_preset "$preset"                                   ;;
            ($REMOTE_MENU                    |\
             $REMOTE_PAUSE)                       radio_play_stop                                         ;;
            ($REMOTE_SOURCE)                      random_everything                                       ;;
            ($REMOTE_STOP                    |\
             $REMOTE_EXIT                    |\
             $REMOTE_BACK)                        stop=1;                  stop_radio                     ;;
            ($REMOTE_NEXT)                        play_next                                               ;;
            ($REMOTE_PREVIOUS)                    play_previous                                           ;;
            ($REMOTE_CHANNEL_RECALL)              channel_recall                                          ;;
            ($REMOTE_RECORD                  |\
             $REMOTE_INFO)                        say_song_name                                           ;;
            ($REMOTE_VOLUME_UP)                   volume_up                "$(($volume_step*5))"          ;;
            ($REMOTE_VOLUME_DOWN)                 volume_down              "$(($volume_step*5))"          ;;
            ($REMOTE_MUTE)                        set_mute                                                ;;
            ($REMOTE_0)                           play_preset "0"                                         ;;
            ($REMOTE_1)                           play_preset "1"                                         ;;
            ($REMOTE_2)                           play_preset "2"                                         ;;
            ($REMOTE_3)                           play_preset "3"                                         ;;
            ($REMOTE_4)                           play_preset "4"                                         ;;
            ($REMOTE_5)                           play_preset "5"                                         ;;
            ($REMOTE_6)                           play_preset "6"                                         ;;
            ($REMOTE_7)                           play_preset "7"                                         ;;
            ($REMOTE_8)                           play_preset "8"                                         ;;
            ($REMOTE_9)                           play_preset "9"                                         ;;
            ($REMOTE_CIRCLE_RED)                  go_direct_1                                             ;;
            ($REMOTE_CIRCLE_GREEN)                go_direct_2                                             ;;
            ($REMOTE_CIRCLE_YELLOW)               go_direct_3                                             ;;
            ($REMOTE_CIRCLE_BLUE)                 go_direct_4                                             ;;
            ($REMOTE_SQUARE_RED)                  set_audio_alsa;          break                          ;;
            ($REMOTE_SQUARE_BLUE)                 set_audio_bluetooth;     break                          ;;
            ($REMOTE_POWER_X)                     stop=1;                  power_down_system              ;;
            ($REMOTE_SOURCE_X)                    random_everything                                       ;;
            ($REMOTE_MENU_X)                      radio_play_stop                                         ;;
            ($REMOTE_STOP_X                  |\
             $REMOTE_EXIT_X)                      stop=1;                  stop_radio                     ;;
            ($REMOTE_VOLUME_UP_X)                 volume_up                "$volume_step"                 ;;
            ($REMOTE_VOLUME_DOWN_X)               volume_down              "$volume_step"                 ;;
            ($REMOTE_MUTE_X)                      set_mute                                                ;;
            ($REMOTE_0_X)                         play_special "0"                                        ;;
            ($REMOTE_1_X)                         play_special "1"                                        ;;
            ($REMOTE_2_X)                         play_special "2"                                        ;;
            ($REMOTE_3_X)                         play_special "3"                                        ;;
            ($REMOTE_4_X)                         play_special "4"                                        ;;
            ($REMOTE_5_X)                         play_special "5"                                        ;;
            ($REMOTE_6_X)                         play_special "6"                                        ;;
            ($REMOTE_7_X)                         play_special "7"                                        ;;
            ($REMOTE_8_X)                         play_special "8"                                        ;;
            ($REMOTE_9_X)                         play_special "9"                                        ;;
            ($REMOTE_PREVIOUS_X)                  random_stuff "1"                                        ;;
            ($REMOTE_PLAY_X)                      random_stuff "2"                                        ;;
            ($REMOTE_NEXT_X)                      random_stuff "3"                                        ;;
            ($REMOTE_CHANNEL_RECALL_X)            go_test_1                                               ;;
            ($REMOTE_INFO_X)                      go_test_2                                               ;;
            ($REMOTE_RECORD_X)                    say_song_name                                           ;;
            ($REMOTE_CROSS_UP_X              |\
             $REMOTE_CHANNEL_UP_X)                page_up                                                 ;;
            ($REMOTE_CROSS_DOWN_X            |\
             $REMOTE_CHANNEL_DOWN_X)              page_down                                               ;;
            ($REMOTE_CROSS_RIGHT_X)               preset_up                                               ;;
            ($REMOTE_CROSS_LEFT_X)                preset_down                                             ;;
            ($REMOTE_CROSS_OK_X)                  play_preset "$preset"                                   ;;
        esac
    done < "$my_pipe";
done;
