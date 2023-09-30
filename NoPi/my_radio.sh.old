#!/bin/bash

####################################################
#                                                  #
#           Android TV Boxes - Armbian             #
#                                                  #
#        Internet Radio On A Tight Budget!         #
#                                                  #
#--------------------------------------------------#
#                                                  #
#                   my_radio.sh                    #
#                                                  #
#        FM / DAB+ / INTERNET / MP3 Player         #
#                                                  #
#--------------------------------------------------#
#                                                  #
#                JJR / August 2023                 #
#                                                  #
####################################################

page=4; preset=0; stop=0; volume=45; VOLUME_STEP=1; mute=0; equal=1; lcd_on_off=0; lcd_backlight=1; FLITE_VOLUME=0.5;
AUDIO_DEVICE="equal"; MY_RADIO_PIPE="/tmp/my_radio_pipe"; ARDUINO="/dev/ttyUSB0"; FLITE="/tmp/FLITE.WAV";
REMOTE="/root/Hama_Big_Zapper.toml"; INPUT_DEVICES="/dev/input/event*"; CONNECTING_TO_WIFI="/root/WIFI-1.WAV";
CONNECTED_TO_WIFI="/root/WIFI-2.WAV"; UPDATE_DB_WARNING="/root/DIVE.WAV"; POWER_DOWN_SYSTEM_WARNING="/root/BELL.WAV";
RANDOM_EVERYTHING_PGM="/root/random/random_run.sh"; RANDOM_BY_GENRE_PGM="/root/random/random_run.py";
FM_PGM="/usr/local/bin/softfm"; DAB_1_PGM="/usr/local/bin/dab-rtlsdr-2"; DAB_2_PGM="/usr/local/bin/welle-cli";
MP3_PGM="/usr/bin/vlc2"; UPDATE_DB_PGM="/root/random/random_set.sh"; NET_SONG_FEED_PGM="/root/my_radio_song_feed_net.sh";
DAB_1_SONG_FEED_PGM="/root/my_radio_song_feed_dab_1.sh"; DAB_2_SONG_FEED_PGM="/root/my_radio_song_feed_dab_2.sh";
DAB_1_PGM_INPUT_PIPE="/tmp/dab-rtlsdr-2_input"; DAB_2_PGM_INPUT_PIPE="/tmp/welle-cli_input";
DAB_1_PGM_OUTPUT_PIPE="/tmp/dab-rtlsdr-2_output"; DAB_2_PGM_OUTPUT_PIPE="/tmp/welle-cli_output";

t2m_fm_radio="fm radio"; t2m_dab_plus_radio_page_one="dab plus radio page one";
t2m_dab_plus_radio_page_two="dab plus radio page two"; t2m_internet_radio_page_one="internet radio page one";
t2m_internet_radio_page_two="internet radio page two"; t2m_internet_radio_page_three="internet radio page three";
t2m_internet_radio_page_four="internet radio page four"; t2m_random_internet_radio="random internet radio";
t2m_mp3_player="mp3 player"; t2m_page="page"; t2m_preset="preset"; t2m_random="random"; t2m_mp3="mp3";
t2m_radio="radio"; t2m_play="play"; t2m_stop="stop"; t2m_volume="volume"; t2m_up="up"; t2m_down="down";
t2m_percent="percent"; t2m_from="from"; t2m_pds="power down system";
t2m_equalizer_is_on="equalizer is on"; t2m_equalizer_is_off="equalizer is off";
t2m_lcd_display_is_on="l.c.d display is on"; t2m_lcd_display_is_off="l.c.d display is off";
t2m_lcd_backlight_is_on="l.c.d back light is on"; t2m_lcd_backlight_is_off="l.c.d back light is off";
t2m_update_db="now. updating the data base... please wait a few minutes";
t2m_time="the time is. "; t2m_hour="hour. "; t2m_minute="minute. "; t2m_second="second. ";
t2m_play_random=( "everything" "talk" "pop" "alternative" "country" "oldies" "60s" "70s" "80s" "90s" );

PLAY_RANDOM=( "" "talk" "pop" "alternative" "country" "oldies" "60" "70" "80" "90" );

KEYPAD_ENTER="*KEY_KPENTER	0	command*"
KEYPAD_NUMLOCK="*KEY_NUMLOCK	0	command*"
KEYPAD_PLUS="*KEY_KPPLUS	0	command*"
KEYPAD_PLUS_LONG="*KEY_KPPLUS	2	command*"
KEYPAD_MINUS="*KEY_KPMINUS	0	command*"
KEYPAD_MINUS_LONG="*KEY_KPMINUS	2	command*"
KEYPAD_DOT="*KEY_KPDOT	0	command*"
KEYPAD_SLASH="*KEY_KPSLASH	0	command*"
KEYPAD_ASTERISK="*KEY_KPASTERISK	0	command*"
KEYPAD_BACK="*KEY_BACKSPACE	0	command*"
KEYPAD_0="*KEY_KP0	0	command*"
KEYPAD_1="*KEY_KP1	0	command*"
KEYPAD_2="*KEY_KP2	0	command*"
KEYPAD_3="*KEY_KP3	0	command*"
KEYPAD_4="*KEY_KP4	0	command*"
KEYPAD_5="*KEY_KP5	0	command*"
KEYPAD_6="*KEY_KP6	0	command*"
KEYPAD_7="*KEY_KP7	0	command*"
KEYPAD_8="*KEY_KP8	0	command*"
KEYPAD_9="*KEY_KP9	0	command*"
KEYPAD_NUMLOCK_DOT="*KEY_NUMLOCK+KEY_KPDOT	1	command*"
KEYPAD_DOT_NUMLOCK="*KEY_KPDOT+KEY_NUMLOCK	1	command*"
KEYPAD_NUMLOCK_0="*KEY_NUMLOCK+KEY_KP0	1	command*"
KEYPAD_0_NUMLOCK="*KEY_KP0+KEY_NUMLOCK	1	command*"
KEYPAD_NUMLOCK_1="*KEY_NUMLOCK+KEY_KP1	1	command*"
KEYPAD_1_NUMLOCK="*KEY_KP1+KEY_NUMLOCK	1	command*"
KEYPAD_NUMLOCK_2="*KEY_NUMLOCK+KEY_KP2	1	command*"
KEYPAD_2_NUMLOCK="*KEY_KP2+KEY_NUMLOCK	1	command*"
KEYPAD_NUMLOCK_3="*KEY_NUMLOCK+KEY_KP3	1	command*"
KEYPAD_3_NUMLOCK="*KEY_KP3+KEY_NUMLOCK	1	command*"
KEYPAD_NUMLOCK_BACK="*KEY_NUMLOCK+KEY_BACKSPACE	1	command*"
KEYPAD_BACK_NUMLOCK="*KEY_BACKSPACE+KEY_NUMLOCK	1	command*"
REMOTE_POWER="*KEY_POWER	0	command*"
REMOTE_VOLUMEUP="*KEY_VOLUMEUP	0	command*"
REMOTE_VOLUMEUP_LONG="*KEY_VOLUMEUP	2	command*"
REMOTE_VOLUMEDOWN="*KEY_VOLUMEDOWN	0	command*"
REMOTE_VOLUMEDOWN_LONG="*KEY_VOLUMEDOWN	2	command*"
REMOTE_CHANNELUP="*KEY_CHANNELUP	0	command*"
REMOTE_CHANNELDOWN="*KEY_CHANNELDOWN	0	command*"
REMOTE_MUTE="*KEY_MUTE	0	command*"
REMOTE_OK="*KEY_OK	0	command*"
REMOTE_1="*KEY_NUMERIC_1	0	command*"
REMOTE_2="*KEY_NUMERIC_2	0	command*"
REMOTE_3="*KEY_NUMERIC_3	0	command*"
REMOTE_4="*KEY_NUMERIC_4	0	command*"
REMOTE_5="*KEY_NUMERIC_5	0	command*"
REMOTE_6="*KEY_NUMERIC_6	0	command*"
REMOTE_7="*KEY_NUMERIC_7	0	command*"
REMOTE_8="*KEY_NUMERIC_8	0	command*"
REMOTE_9="*KEY_NUMERIC_9	0	command*"
REMOTE_0="*KEY_NUMERIC_0	0	command*"
REMOTE_AUDIO="*KEY_AUDIO	0	command*"
REMOTE_MENU="*KEY_MENU	0	command*"
REMOTE_MODE="*KEY_MODE	0	command*"

initialization()     { /usr/bin/echo "my_radio.sh is starting..... `/usr/bin/date`" > /dev/kmsg;
                       /usr/bin/stty -F "$ARDUINO" 9600 cs8 -cstopb -parenb -hupcl -echo cread clocal -crtscts -ixon
                       /usr/bin/rm -f  "$DAB_1_PGM_INPUT_PIPE" "$DAB_1_PGM_OUTPUT_PIPE";
                       /usr/bin/rm -f  "$DAB_2_PGM_INPUT_PIPE" "$DAB_2_PGM_OUTPUT_PIPE";
                       /usr/bin/mkfifo "$DAB_1_PGM_INPUT_PIPE" "$DAB_1_PGM_OUTPUT_PIPE";
                       /usr/bin/mkfifo "$DAB_2_PGM_INPUT_PIPE" "$DAB_2_PGM_OUTPUT_PIPE";
                       load_net_playlist;
                       load_fm_playlist;
                       load_dab1_playlist;
                       load_dab2_playlist;
                       /usr/bin/amixer sset "Speaker" 100% &>/dev/null;
                       /usr/bin/amixer sset "Speaker" unmute &>/dev/null;
                       set_volume "$volume";
                       set_equalizer;
                       /usr/bin/ir-keytable -c -w "$REMOTE" &>/dev/null;
                       set_lcd_on_off;
                       /usr/bin/sleep 10;
                       set_lcd_backlight;
                       number_of_pings=30;
                       while true; do
                          /usr/bin/play -qV0 -v "$FLITE_VOLUME" "$CONNECTING_TO_WIFI" &>/dev/null;
                          /usr/bin/ping -q -c1 google.com &>/dev/null && break;
                          /usr/bin/sleep 1;
                          ((number_of_pings-=1));
                          if [ "$number_of_pings" -eq 0 ]; then page=1; preset=0; break; fi; done;
                       set_lcd_display "SETUP";
                       if [ "$number_of_pings" -ne 0 ]; then
                          /usr/bin/echo "Connected to Wi-Fi! `/usr/bin/date`" > /dev/kmsg;
                          /usr/bin/play -qV0 -v "$FLITE_VOLUME" "$CONNECTED_TO_WIFI" &>/dev/null; fi;
                       stop=1; play_preset "$preset"; }
load_net_playlist()  { /usr/bin/mpc stop &>/dev/null;
                       /usr/bin/mpc clear &>/dev/null;
                       /usr/bin/cat /root/playlist.db | /usr/bin/mpc add &>/dev/null;
                       /usr/bin/mpc repeat on &>/dev/null;
                       /usr/bin/mpc volume 100 &>/dev/null; }
load_fm_playlist()   { IFS=$'\n' read -d '' -r -a lines < /root/playlist.fm; index=0;
                       for line in "${lines[@]}"; do
                          if [[ "$line" != "#"* ]]; then
                             description=$(/usr/bin/echo "$line" | /usr/bin/cut -d '|' -f1 | /usr/bin/sed 's/"//g');
                             command=$(/usr/bin/echo     "$line" | /usr/bin/cut -d '|' -f2 | /usr/bin/sed 's/"//g');
                             FM["$index"]="$command"; FM_DESC["$index"]="$description"; ((index++)); fi; done; }
load_dab1_playlist() { IFS=$'\n' read -d '' -r -a lines < /root/playlist.dab1; index=0;
                       for line in "${lines[@]}"; do
                          if [[ "$line" != "#"* ]]; then
                             description=$(/usr/bin/echo "$line" | /usr/bin/cut -d '|' -f1 | /usr/bin/sed 's/"//g');
                             command=$(/usr/bin/echo     "$line" | /usr/bin/cut -d '|' -f2 | /usr/bin/sed 's/"//g');
                             DAB_1["$index"]="$command"; DAB_1_DESC["$index"]="$description"; ((index++)); fi; done; }
load_dab2_playlist() { IFS=$'\n' read -d '' -r -a lines < /root/playlist.dab2; index=0;
                       for line in "${lines[@]}"; do
                          if [[ "$line" != "#"* ]]; then
                             description=$(/usr/bin/echo "$line" | /usr/bin/cut -d '|' -f1 | /usr/bin/sed 's/"//g');
                             command=$(/usr/bin/echo     "$line" | /usr/bin/cut -d '|' -f2 | /usr/bin/sed 's/"//g');
                             DAB_2["$index"]="$command"; DAB_2_DESC["$index"]="$description"; ((index++)); fi; done; }
talk_2_me()          { if [ "$stop" -eq 1 ]; then
                          /usr/bin/flite -t "$1" -o "$FLITE" -voice slt --setf duration_stretch=.9\
                                                                        --setf int_f0_target_mean=237 &>/dev/null &&
                          /usr/bin/play -qV0 -v "$FLITE_VOLUME" "$FLITE" reverb &>/dev/null; fi; }
page_up()            { ((page+=1)); if [ "$page" -eq 10 ]; then page=1; fi; set_lcd_display "SETUP"; say_page "$page"; }
page_down()          { ((page-=1)); if [ "$page" -eq 0 ];  then page=9; fi; set_lcd_display "SETUP"; say_page "$page"; }
say_page()           {   if [ "$1" -eq 1 ]; then talk_2_me "$t2m_fm_radio";
                       elif [ "$1" -eq 2 ]; then talk_2_me "$t2m_dab_plus_radio_page_one";
                       elif [ "$1" -eq 3 ]; then talk_2_me "$t2m_dab_plus_radio_page_two";
                       elif [ "$1" -eq 4 ]; then talk_2_me "$t2m_internet_radio_page_one";
                       elif [ "$1" -eq 5 ]; then talk_2_me "$t2m_internet_radio_page_two";
                       elif [ "$1" -eq 6 ]; then talk_2_me "$t2m_internet_radio_page_three";
                       elif [ "$1" -eq 7 ]; then talk_2_me "$t2m_internet_radio_page_four";
                       elif [ "$1" -eq 8 ]; then talk_2_me "$t2m_random_internet_radio";
                       elif [ "$1" -eq 9 ]; then talk_2_me "$t2m_mp3_player"; fi; }
preset_up()          { if [ "$page" -ne 9 ]; then
                          ((preset+=1)); if [ "$preset" -eq 10 ]; then preset=0; fi; say_preset "$preset"; fi; }
preset_down()        { if [ "$page" -ne 9 ]; then
                          ((preset-=1)); if [ "$preset" -lt 0 ];  then preset=9; fi; say_preset "$preset"; fi; }
say_preset()         { if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ] ||
                          [ "$page" -eq 5 ] || [ "$page" -eq 6 ] || [ "$page" -eq 7 ]; then talk_2_me "$t2m_preset $1";
                       elif [ "$page" -eq 8 ]; then talk_2_me "$t2m_random ${t2m_play_random[$1]}"; fi; }
volume_up()          { ((volume+="$1")); if [ "$volume" -gt 100 ]; then volume=100; fi;
                       set_volume "$volume"; talk_2_me "$t2m_volume $t2m_up $volume $t2m_percent";
                       if [ "$1" -eq "$VOLUME_STEP" ]; then SendData "VOLUME=VOLUME UP $volume%";
                       if [ "$mute" -eq 1 ]; then mute=0; SendData "BLINKLEDS=0"; fi; fi; }
volume_down()        { ((volume-="$1")); if [ "$volume" -le 0 ]; then volume=0; mute; else
                       set_volume "$volume"; talk_2_me "$t2m_volume $t2m_down $volume $t2m_percent";
                       if [ "$1" -eq "$VOLUME_STEP" ]; then SendData "VOLUME=VOLUME DOWN $volume%"; fi; fi; }
mute()               { if [ "$mute" -eq 0 ]; then mute=1; volume=0; SendData "VOLUME=[MUTE] VOLUME $volume%";
                       set_volume "$volume"; SendData "BLINKLEDS=1"; fi; }
set_volume()         { /usr/bin/amixer sset "SoftVolume" "$1"% &>/dev/null; }
set_equalizer()      { if [ "$mute" -eq 0 ]; then if [ "$equal" -eq 0 ]; then equal=1; talk_2_me "$t2m_equalizer_is_on";
                       SendData "EQUALIZER=1"; /root/presets jj &>/dev/null &
                       else equal=0; talk_2_me "$t2m_equalizer_is_off";
                       SendData "EQUALIZER=0"; /root/presets &>/dev/null & fi; fi; }
play_preset()        { stop_radio; preset="$1"; set_lcd_display "PLAY_PRESET";
                       if [ "$page" -eq 1 ]; then
                          talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_fm_radio";
                          play_fm "$preset";
                       elif [ "$page" -eq 2 ]; then
                          talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_dab_plus_radio_page_one";
                          play_dab_1 "$preset";
                       elif [ "$page" -eq 3 ]; then
                          talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_dab_plus_radio_page_two";
                          play_dab_2 "$preset";
                       elif [ "$page" -eq 4 ]; then
                          talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_one";
                          play_internet "$(($preset+1))";
                       elif [ "$page" -eq 5 ]; then
                          talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_two";
                          play_internet "$(($preset+11))";
                       elif [ "$page" -eq 6 ]; then
                          talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_three";
                          play_internet "$(($preset+21))";
                       elif [ "$page" -eq 7 ]; then
                          talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_four";
                          play_internet "$(($preset+31))";
                       elif [ "$page" -eq 8 ]; then
                          talk_2_me "$t2m_play $t2m_random ${t2m_play_random[$preset]}";
                          play_random "${PLAY_RANDOM[$preset]}";
                       elif [ "$page" -eq 9 ]; then
                          talk_2_me "$t2m_play $t2m_random $t2m_mp3";
                          play_mp3; fi; set_lcd_display "PLAY"; stop=0; }
stop_radio()         { /usr/bin/mpc stop &>/dev/null;
                       kill_pid "$internet_song_feed_pid";
                       kill_pid "$fm_pgm_pid";
                       kill_pid "$dab_1_pgm_pid";
                       kill_pid "$dab_1_song_feed_pid";
                       kill_pid "$dab_2_pgm_pid";
                       kill_pid "$dab_2_song_feed_pid";
                       kill_pid "$mp3_pgm_pid";
                       /usr/bin/pkill -P $$ &>/dev/null; }
kill_pid()           { if /usr/bin/ps -p "$1" &>/dev/null; then /usr/bin/kill -9 "$1" &>/dev/null; fi; }
play_fm()            { "$FM_PGM" -t rtlsdr ${FM["$1"]} -P"$AUDIO_DEVICE" &>/dev/null & fm_pgm_pid=$(/usr/bin/echo $!); }
play_dab_1()         { "$DAB_1_SONG_FEED_PGM" &>/dev/null & dab_1_song_feed_pid=$(/usr/bin/echo $!);
                       /usr/bin/cat "$DAB_1_PGM_INPUT_PIPE" |\
                       "$DAB_1_PGM" ${DAB_1["$1"]} -A "$AUDIO_DEVICE" &> "$DAB_1_PGM_OUTPUT_PIPE" &
                       dab_1_pgm_pid=$(/usr/bin/echo $!); }
play_dab_2()         { "$DAB_2_SONG_FEED_PGM" &>/dev/null & dab_2_song_feed_pid=$(/usr/bin/echo $!);
                       /usr/bin/cat "$DAB_2_PGM_INPUT_PIPE" |\
                       "$DAB_2_PGM" ${DAB_2["$1"]} &> "$DAB_2_PGM_OUTPUT_PIPE" &
                       dab_2_pgm_pid=$(/usr/bin/echo $!); }
play_internet()      { play_internet_feed; /usr/bin/mpc play "$1" &>/dev/null; }
play_internet_feed() { "$NET_SONG_FEED_PGM" &>/dev/null & internet_song_feed_pid=$(/usr/bin/echo $!); }
play_random()        { while true; do
                          cmd=$("$RANDOM_BY_GENRE_PGM" "$1" 2>/dev/null);
                          if [ "$cmd" == "Nothing Found!" ]; then talk_2_me "$cmd"; break; fi;
                          url=$(/usr/bin/echo $cmd | /usr/bin/cut -f1 -d' ');
                          if [ "$url" == "None" ] || [ "$url" == "listen_url" ]; then continue; fi;
                          /usr/bin/mpc del 41 &>/dev/null;
                          /usr/bin/mpc add "$url" &>/dev/null;
                          play_internet_feed;
                          /usr/bin/mpc play 41 &>/dev/null;
                          ok=$(/usr/bin/echo $?); /usr/bin/sleep 1; status=$(/usr/bin/mpc status);
                          if ! /usr/bin/echo "$status" | /usr/bin/grep -q "ERROR: Failed" &&
                             [ "$ok" -eq 0 ]; then break; fi; done; }
play_mp3()           { "$MP3_PGM" -I dummy -q --alsa-audio-device "$AUDIO_DEVICE" -LZ "/root/mp3"\
                                              --gain 1 </dev/null &>/dev/null & mp3_pgm_pid=$(/usr/bin/echo $!); }
random_everything()  { page=8; preset=0; set_lcd_display "SETUP"; stop_radio; set_lcd_display "PLAY_PRESET";
                       talk_2_me "$t2m_play $t2m_random ${t2m_play_random[0]}";
                       url=$("$RANDOM_EVERYTHING_PGM" &>/dev/null); set_lcd_display "PLAY"; stop=0; }
radio_play_stop()    { if [ "$stop" -eq 0 ]; then
                          stop=1; set_lcd_display "STOP"; stop_radio; talk_2_me "$t2m_radio $t2m_stop";
                       else
                          set_lcd_display "PLAY"; talk_2_me "$t2m_radio $t2m_play"; stop=0;
                          if   [ "$page" -eq 1 ]; then play_fm "$preset";
                          elif [ "$page" -eq 2 ]; then play_dab_1 "$preset";
                          elif [ "$page" -eq 3 ]; then play_dab_2 "$preset";
                          elif [ "$page" -eq 4 ] || [ "$page" -eq 5 ] || [ "$page" -eq 6 ] ||
                               [ "$page" -eq 7 ] || [ "$page" -eq 8 ]; then
                               play_internet_feed; /usr/bin/mpc play &>/dev/null;
                          elif [ "$page" -eq 9 ]; then play_mp3; fi; fi; }
play_next()          { /usr/bin/mpc next &>/dev/null; }
play_previous()      { /usr/bin/mpc prev &>/dev/null; }
update_database()    { stop_radio; stop=1; for i in $(/usr/bin/seq 1 3); do
                       /usr/bin/play -qV0 -v "$FLITE_VOLUME" "$UPDATE_DB_WARNING" &>/dev/null; done;
                       talk_2_me "$t2m_update_db"; cmd=$("$UPDATE_DB_PGM" &>/dev/null &); }
power_down_system()  { if [ "$stop" -eq 1 ]; then for i in $(/usr/bin/seq 1 4); do
                       /usr/bin/play -qV0 -v "$FLITE_VOLUME" "$POWER_DOWN_SYSTEM_WARNING" &>/dev/null; done;
                       talk_2_me "$t2m_pds"; /usr/sbin/shutdown now; fi; }
say_time()           { h=$(date +'%H'); m=$(date +'%M'); s=$(date +'%S'); full_date_time=$(date +'%A %d %B %Y - %T');
                       up_since=$(/usr/bin/uptime --pretty); SendData "SONG=${full_date_time} - ${up_since}";
                       talk_2_me "$t2m_time $h $t2m_hour $m $t2m_minute $s $t2m_second"; }
set_lcd_on_off()     { if [ "$lcd_on_off" -eq 0 ]; then
                          lcd_on_off=1; talk_2_me "$t2m_lcd_display_is_on"; SendData "LCD_DISPLAY=1";
                       else
                          lcd_on_off=0; talk_2_me "$t2m_lcd_display_is_off"; SendData "LCD_DISPLAY=0"; fi; }
set_lcd_backlight()  { if [ "$lcd_backlight" -eq 0 ]; then
                          lcd_backlight=1; talk_2_me "$t2m_lcd_backlight_is_on"; SendData "LCD_BACKLIGHT=1";
                       else
                          lcd_backlight=0; talk_2_me "$t2m_lcd_backlight_is_off"; SendData "LCD_BACKLIGHT=0"; fi; }
set_lcd_display()    { send_data=""; NEWLINE="\n";
                       if [ "$1" == "SETUP" ]; then
                            if [ "$page" -eq 1 ]; then send_data="LED1=1${NEWLINE}LCD_L1=FM";
                          elif [ "$page" -eq 2 ]; then send_data="LED2=1${NEWLINE}LCD_L1=DAB1";
                          elif [ "$page" -eq 3 ]; then send_data="LED2=1${NEWLINE}LCD_L1=DAB2";
                          elif [ "$page" -eq 4 ]; then send_data="LED3=1${NEWLINE}LCD_L1=NET1";
                          elif [ "$page" -eq 5 ]; then send_data="LED3=1${NEWLINE}LCD_L1=NET2";
                          elif [ "$page" -eq 6 ]; then send_data="LED3=1${NEWLINE}LCD_L1=NET3";
                          elif [ "$page" -eq 7 ]; then send_data="LED3=1${NEWLINE}LCD_L1=NET4";
                          elif [ "$page" -eq 8 ]; then send_data="LED4=1${NEWLINE}LCD_L1=RANDOM";
                          elif [ "$page" -eq 9 ]; then send_data="LED5=1${NEWLINE}LCD_L1=MP3 Player"; fi;
                          send_data="${send_data}${NEWLINE}LCD_L2=BLANKS"; SendData "$send_data";
                       elif [ "$1" == "STOP" ]; then
                          send_data="SMILEY=0${NEWLINE}LCD_L2=Radio stop!"; SendData "$send_data";
                       elif [ "$1" == "PLAY" ]; then
                          send_data="SMILEY=1${NEWLINE}LCD_L2=Radio play!"; SendData "$send_data";
                       elif [ "$1" == "PLAY_PRESET" ]; then
                            if [ "$page" -eq 1 ]; then send_data="LCD_L1=FM ${FM_DESC[$preset]}";
                          elif [ "$page" -eq 2 ]; then send_data="LCD_L1=DAB1 ${DAB_1_DESC[$preset]}";
                          elif [ "$page" -eq 3 ]; then send_data="LCD_L1=DAB2 ${DAB_2_DESC[$preset]}";
                          elif [ "$page" -eq 4 ]; then send_data="LCD_L1=NET1 --> $preset";
                          elif [ "$page" -eq 5 ]; then send_data="LCD_L1=NET2 --> $preset";
                          elif [ "$page" -eq 6 ]; then send_data="LCD_L1=NET3 --> $preset";
                          elif [ "$page" -eq 7 ]; then send_data="LCD_L1=NET4 --> $preset";
                          elif [ "$page" -eq 8 ]; then
                          send_data="LCD_L1=RANDOM $(/usr/bin/echo ${t2m_play_random[$preset]} | /usr/bin/cut -c1-5)";
                          elif [ "$page" -eq 9 ]; then send_data="LCD_L1=MP3 Player"; fi;
                          SendData "$send_data"; fi; }
display_cpu_temp()   { SendData "LCD_L2=Please Wait..."; /root/cpu+temp.sh &>/dev/null & }
SendData()           { /usr/bin/echo -e "$1" > "$ARDUINO"; }   ### /usr/bin/echo -e "$1"; }

initialization

while true; do
   /usr/bin/killall -q thd; /usr/bin/rm -f "$MY_RADIO_PIPE"; /usr/bin/mkfifo "$MY_RADIO_PIPE";
   /usr/sbin/thd --dump $INPUT_DEVICES > "$MY_RADIO_PIPE" 2>&1 &
   while read line; do
      case $line in
         ($KEYPAD_ENTER)		page_up;;
         ($KEYPAD_NUMLOCK)		page_down;;
         ($KEYPAD_PLUS)			volume_up	"$VOLUME_STEP";;
         ($KEYPAD_PLUS_LONG)		volume_up	"$(($VOLUME_STEP*2))";;
         ($KEYPAD_MINUS)		volume_down	"$VOLUME_STEP";;
         ($KEYPAD_MINUS_LONG)		volume_down	"$(($VOLUME_STEP*2))";;
         ($KEYPAD_DOT)			radio_play_stop;;
         ($KEYPAD_SLASH)		if [ "$stop" -eq 0 ]; then play_previous;	else say_time; fi;;
         ($KEYPAD_ASTERISK)		if [ "$stop" -eq 0 ]; then play_next;		else say_time; fi;;
         ($KEYPAD_BACK)			random_everything;;
         ($KEYPAD_0)			play_preset "0";;
         ($KEYPAD_1)			play_preset "1";;
         ($KEYPAD_2)			play_preset "2";;
         ($KEYPAD_3)			play_preset "3";;
         ($KEYPAD_4)			play_preset "4";;
         ($KEYPAD_5)			play_preset "5";;
         ($KEYPAD_6)			play_preset "6";;
         ($KEYPAD_7)			play_preset "7";;
         ($KEYPAD_8)			play_preset "8";;
         ($KEYPAD_9)			play_preset "9";;
         ($KEYPAD_NUMLOCK_0	|\
          $KEYPAD_0_NUMLOCK)		set_equalizer;		/usr/bin/sleep 1; break;;
         ($KEYPAD_NUMLOCK_1	|\
          $KEYPAD_1_NUMLOCK)		set_lcd_backlight;	/usr/bin/sleep 1; break;;
         ($KEYPAD_NUMLOCK_2	|\
          $KEYPAD_2_NUMLOCK)		set_lcd_on_off;		/usr/bin/sleep 1; break;;
         ($KEYPAD_NUMLOCK_3	|\
          $KEYPAD_3_NUMLOCK)		display_cpu_temp;	/usr/bin/sleep 1; break;;
         ($KEYPAD_NUMLOCK_BACK	|\
          $KEYPAD_BACK_NUMLOCK)		update_database;	/usr/bin/sleep 1; break;;
         ($KEYPAD_NUMLOCK_DOT	|\
          $KEYPAD_DOT_NUMLOCK)		power_down_system;	/usr/bin/sleep 1; break;;
         ($REMOTE_POWER)		power_down_system;;
         ($REMOTE_VOLUMEUP)		volume_up	"$VOLUME_STEP";;
         ($REMOTE_VOLUMEUP_LONG)	volume_up	"$(($VOLUME_STEP*2))";;
         ($REMOTE_VOLUMEDOWN)		volume_down	"$VOLUME_STEP";;
         ($REMOTE_VOLUMEDOWN_LONG)	volume_down	"$(($VOLUME_STEP*2))";;
         ($REMOTE_CHANNELUP)		page_up;;
         ($REMOTE_CHANNELDOWN)		page_down;;
         ($REMOTE_MUTE)			mute;;
         ($REMOTE_OK)			radio_play_stop;;
         ($REMOTE_0)			play_preset "0";;
         ($REMOTE_1)			play_preset "1";;
         ($REMOTE_2)			play_preset "2";;
         ($REMOTE_3)			play_preset "3";;
         ($REMOTE_4)			play_preset "4";;
         ($REMOTE_5)			play_preset "5";;
         ($REMOTE_6)			play_preset "6";;
         ($REMOTE_7)			play_preset "7";;
         ($REMOTE_8)			play_preset "8";;
         ($REMOTE_9)			play_preset "9";;
         ($REMOTE_AUDIO)		set_equalizer;;
         ($REMOTE_MENU)			set_lcd_backlight;;
         ($REMOTE_MODE)			random_everything;;
      esac
   done < "$MY_RADIO_PIPE"
done
