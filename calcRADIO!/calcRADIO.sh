#!/bin/bash

####################################################
#                                                  #
#           Android TV Boxes - Armbian             #
#                                                  #
#        Internet Radio On A Tight Budget!         #
#                                                  #
#--------------------------------------------------#
#                                                  #
#                   calcRADIO.sh                   #
#                                                  #
#        FM / DAB+ / INTERNET / MP3 Player         #
#                                                  #
#--------------------------------------------------#
#                                                  #
#               JJR / February 2025                #
#                                                  #
####################################################

mode=1; preset=0; stop=1; volume=50; mute=0; equalizer=0;
CALC="/dev/ttyAML0"; STRING_DELIMITER="^"; LOG="/tmp/calcRADIO.log";
AUDIO_DEVICE="equal"; FLITE="/tmp/FLITE.WAV"; FLITE_VOLUME=0.5;
CONNECTING_TO_WIFI="/root/calcRADIO/WIFI-1.WAV"; CONNECTED_TO_WIFI="/root/calcRADIO/WIFI-2.WAV";
UPDATE_DB_WARNING="/root/calcRADIO/DIVE.WAV"; POWER_DOWN_SYSTEM_WARNING="/root/calcRADIO/BELL.WAV";
RANDOM_EVERYTHING_PGM="/root/random/random_run.sh"; RANDOM_BY_GENRE_PGM="/root/random/random_run.py";
FM_PGM="/usr/local/bin/softfm"; DAB_1_PGM="/usr/local/bin/dab-rtlsdr-2"; DAB_2_PGM="/usr/local/bin/welle-cli";
MP3_PGM="/usr/bin/vlc2"; UPDATE_DB_PGM="/root/random/random_set.sh";
NET_SONG_FEED_PGM="/root/calcRADIO/calcRADIO_song_feed_net.sh";
DAB_1_SONG_FEED_PGM="/root/calcRADIO/calcRADIO_song_feed_dab_1.sh";
DAB_2_SONG_FEED_PGM="/root/calcRADIO/calcRADIO_song_feed_dab_2.sh";
DAB_1_PGM_INPUT_PIPE="/tmp/dab-rtlsdr-2_input"; DAB_2_PGM_INPUT_PIPE="/tmp/welle-cli_input";
DAB_1_PGM_OUTPUT_PIPE="/tmp/dab-rtlsdr-2_output"; DAB_2_PGM_OUTPUT_PIPE="/tmp/welle-cli_output";
song_station_http="/root/calcRADIO/show_song_station_http";
set_equalizer_on="/root/calcRADIO/presets jj"; set_equalizer_off="/root/calcRADIO/presets";
cpu_and_temp="/root/calcRADIO/cpu+temp.py"; speaker_test="/usr/bin/speaker-test -D${AUDIO_DEVICE} -c2 -twav";

t2m_the_radio_is_on="The radio is on ..."; t2m_fm_radio="fm radio";
t2m_dab_plus_radio_page_one="dab plus radio page one"; t2m_dab_plus_radio_page_two="dab plus radio page two";
t2m_internet_radio_page_one="internet radio page one"; t2m_internet_radio_page_two="internet radio page two";
t2m_internet_radio_page_three="internet radio page three"; t2m_internet_radio_page_four="internet radio page four";
t2m_random_internet_radio="random internet radio"; t2m_mp3_player="mp3 player";
t2m_preset="preset"; t2m_random="random"; t2m_mp3="mp3"; t2m_radio="radio"; t2m_play="play"; t2m_stop="stop";
t2m_volume="volume"; t2m_up="up"; t2m_down="down"; t2m_percent="percent"; t2m_from="from";
t2m_mute="mute"; t2m_unmute="unmute"; t2m_special="special";
t2m_equalizer_is_on="equalizer is on"; t2m_equalizer_is_off="equalizer is off";
t2m_update_db="now. updating the data base... please wait a few minutes";
t2m_time="the time is. "; t2m_hour="hour. "; t2m_minute="minute. "; t2m_second="second. ";
t2m_unknown_key_pressed="unknown key pressed"; t2m_shutting_down_the_radio="shutting down the radio";
t2m_play_random=( "everything" "talk" "pop" "alternative" "country" "oldies" "60s" "70s" "80s" "90s" );

PLAY_RANDOM=( "" "talk" "pop" "alternative" "country" "oldies" "60" "70" "80" "90" );

initialization()     { /usr/bin/echo "calcRADIO.sh is starting ... `/usr/bin/date`" > /dev/kmsg;
                       /usr/bin/systemctl stop    serial-getty@ttyAML0.service &>/dev/null;
                       /usr/bin/systemctl disable serial-getty@ttyAML0.service &>/dev/null;
                       /usr/bin/echo "${t2m_the_radio_is_on}${STRING_DELIMITER}" | \
                       /usr/bin/picocom --baud 115200 --databits 8 --parity n --stopbits 1 --flow n --noreset --quiet "$CALC" &>/dev/null;
                       /usr/bin/rm -f  "$DAB_1_PGM_INPUT_PIPE" "$DAB_1_PGM_OUTPUT_PIPE";
                       /usr/bin/rm -f  "$DAB_2_PGM_INPUT_PIPE" "$DAB_2_PGM_OUTPUT_PIPE";
                       /usr/bin/mkfifo "$DAB_1_PGM_INPUT_PIPE" "$DAB_1_PGM_OUTPUT_PIPE";
                       /usr/bin/mkfifo "$DAB_2_PGM_INPUT_PIPE" "$DAB_2_PGM_OUTPUT_PIPE";
                       load_net_playlist;
                       load_fm_playlist;
                       load_dab1_playlist;
                       load_dab2_playlist;
                       special=$(/usr/bin/cat /root/calcRADIO/special.db);
                       show_song_station_http "1";
                       /usr/bin/amixer sset "Speaker" 100% &>/dev/null;
                       set_sound_on; set_volume "$volume"; eval "$set_equalizer_off &>/dev/null &";
                       number_of_pings=30;
                       while true; do
                          /usr/bin/play -qV0 -v "$FLITE_VOLUME" "$CONNECTING_TO_WIFI" &>/dev/null;
                          /usr/bin/ping -q -c1 google.com &>/dev/null && break;
                          /usr/bin/sleep 1;
                          ((number_of_pings-=1));
                          if [ "$number_of_pings" -eq 0 ]; then mode=1; preset=0; break; fi;
                       done
                       if [ "$number_of_pings" -ne 0 ]; then
                          /usr/bin/echo "Connected to Wi-Fi! `/usr/bin/date`" > /dev/kmsg;
                          /usr/bin/play -qV0 -v "$FLITE_VOLUME" "$CONNECTED_TO_WIFI" &>/dev/null;
                       fi
                       /usr/bin/echo "$t2m_the_radio_is_on `/usr/bin/date`" > "$LOG"; talk_2_me "$t2m_the_radio_is_on"; }
load_net_playlist()  { /usr/bin/mpc stop &>/dev/null;
                       /usr/bin/mpc clear &>/dev/null;
                       /usr/bin/cat /root/calcRADIO/playlist.db | /usr/bin/mpc add &>/dev/null;
                       /usr/bin/mpc repeat on &>/dev/null;
                       /usr/bin/mpc volume 100 &>/dev/null; }
load_fm_playlist()   { IFS=$'\n' read -d '' -r -a lines < /root/calcRADIO/playlist.fm; index=0;
                       for line in "${lines[@]}"; do
                          if [[ "$line" != "#"* ]]; then
                             description=$(/usr/bin/echo "$line" | /usr/bin/cut -d'|' -f1 | /usr/bin/sed 's/"//g');
                             description=$(/usr/bin/echo "$description" | /usr/bin/cut -c-18 | /usr/bin/xargs);
                             command=$(/usr/bin/echo     "$line" | /usr/bin/cut -d'|' -f2 | /usr/bin/sed 's/"//g');
                             FM["$index"]="$command"; FM_DESC["$index"]="$description"; ((index++)); fi; done; }
load_dab1_playlist() { IFS=$'\n' read -d '' -r -a lines < /root/calcRADIO/playlist.dab1; index=0;
                       for line in "${lines[@]}"; do
                          if [[ "$line" != "#"* ]]; then
                             description=$(/usr/bin/echo "$line" | /usr/bin/cut -d'|' -f1 | /usr/bin/sed 's/"//g');
                             description=$(/usr/bin/echo "$description" | /usr/bin/cut -c-18 | /usr/bin/xargs);
                             command=$(/usr/bin/echo     "$line" | /usr/bin/cut -d'|' -f2 | /usr/bin/sed 's/"//g');
                             DAB_1["$index"]="$command"; DAB_1_DESC["$index"]="$description"; ((index++)); fi; done; }
load_dab2_playlist() { IFS=$'\n' read -d '' -r -a lines < /root/calcRADIO/playlist.dab2; index=0;
                       for line in "${lines[@]}"; do
                          if [[ "$line" != "#"* ]]; then
                             description=$(/usr/bin/echo "$line" | /usr/bin/cut -d'|' -f1 | /usr/bin/sed 's/"//g');
                             description=$(/usr/bin/echo "$description" | /usr/bin/cut -c-18 | /usr/bin/xargs);
                             command=$(/usr/bin/echo     "$line" | /usr/bin/cut -d'|' -f2 | /usr/bin/sed 's/"//g');
                             DAB_2["$index"]="$command"; DAB_2_DESC["$index"]="$description"; ((index++)); fi; done; }
talk_2_me()          { if [ "$stop" -eq 1 ] && [ "$mute" -eq 0 ]; then
                          /usr/bin/flite -t "$1" -o "$FLITE" -voice slt --setf duration_stretch=.9\
                                                                        --setf int_f0_target_mean=237 &>/dev/null &&
                          /usr/bin/play -qV0 -v "$FLITE_VOLUME" "$FLITE" reverb &>/dev/null; fi; }
set_sound_on()       { /usr/bin/amixer sset "Speaker" unmute &>/dev/null; }
set_sound_off()      { /usr/bin/amixer sset "Speaker" mute &>/dev/null; }
set_volume()         { /usr/bin/amixer sset "SoftVolume" "$1"% &>/dev/null; }
set_volume_up()      { set_volume "$volume"; talk_2_me "$t2m_volume $t2m_up $volume $t2m_percent"; }
set_volume_down()    { set_volume "$volume"; talk_2_me "$t2m_volume $t2m_down $volume $t2m_percent"; }
set_mute()           { what_mode "$mode";
                       if [ "$mute" -eq 1 ]; then mute=0; talk_2_me "$t2m_mute $say_mode"; mute=1; set_sound_off;
                       else                       set_sound_on; talk_2_me "$t2m_unmute $say_mode"; fi; }
set_equalizer()      { if [ "$mute" -eq 0 ]; then
                       if [ "$equalizer" -eq 0 ]; then
                            eval "$set_equalizer_off &>/dev/null &"; talk_2_me "$t2m_equalizer_is_off";
                       else eval "$set_equalizer_on  &>/dev/null &"; talk_2_me "$t2m_equalizer_is_on"; fi; fi; }
what_mode()          { say_mode="";
                         if [ "$1" -eq 1 ]; then say_mode="$t2m_fm_radio";
                       elif [ "$1" -eq 2 ]; then say_mode="$t2m_dab_plus_radio_page_one";
                       elif [ "$1" -eq 3 ]; then say_mode="$t2m_dab_plus_radio_page_two";
                       elif [ "$1" -eq 4 ]; then say_mode="$t2m_internet_radio_page_one";
                       elif [ "$1" -eq 5 ]; then say_mode="$t2m_internet_radio_page_two";
                       elif [ "$1" -eq 6 ]; then say_mode="$t2m_internet_radio_page_three";
                       elif [ "$1" -eq 7 ]; then say_mode="$t2m_internet_radio_page_four";
                       elif [ "$1" -eq 8 ]; then say_mode="$t2m_random_internet_radio";
                       elif [ "$1" -eq 9 ]; then say_mode="$t2m_mp3_player"; fi; }
play_preset()        { what_mode "$mode";
                         if [ "$mode" -eq 1 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $say_mode";
                                                    send_data "PRESET=${FM_DESC[$preset]}";
                                                    stop_radio; play_fm "$preset";
                       elif [ "$mode" -eq 2 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $say_mode";
                                                    send_data "PRESET=${DAB_1_DESC[$preset]}";
                                                    stop_radio; play_dab_1 "$preset";
                       elif [ "$mode" -eq 3 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $say_mode";
                                                    send_data "PRESET=${DAB_2_DESC[$preset]}";
                                                    stop_radio; play_dab_2 "$preset";
                       elif [ "$mode" -eq 4 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $say_mode";
                                                    stop_radio; play_internet "$(($preset+1))";
                       elif [ "$mode" -eq 5 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $say_mode";
                                                    stop_radio; play_internet "$(($preset+11))";
                       elif [ "$mode" -eq 6 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $say_mode";
                                                    stop_radio; play_internet "$(($preset+21))";
                       elif [ "$mode" -eq 7 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $say_mode";
                                                    stop_radio; play_internet "$(($preset+31))";
                       elif [ "$mode" -eq 8 ]; then talk_2_me "$t2m_play $t2m_random ${t2m_play_random[$preset]}";
                                                    stop_radio; play_random "${PLAY_RANDOM[$preset]}";
                       elif [ "$mode" -eq 9 ]; then talk_2_me "$t2m_play $t2m_random $t2m_mp3";
                                                    stop_radio; play_mp3; fi; stop=0; }
stop_radio()         { /usr/bin/mpc stop &>/dev/null;
                       kill_pid "$internet_song_feed_pid";
                       kill_pid "$fm_pgm_pid";
                       kill_pid "$dab_1_pgm_pid";
                       kill_pid "$dab_1_song_feed_pid";
                       kill_pid "$dab_2_pgm_pid";
                       kill_pid "$dab_2_song_feed_pid";
                       kill_pid "$mp3_pgm_pid";
                       kill_pid "$test_speaker_pid"; }
kill_pid()           { if /usr/bin/ps -p "$1" &>/dev/null; then /usr/bin/kill -9 "$1" &>/dev/null; fi; }
play_fm()            { eval "$FM_PGM -t rtlsdr ${FM[$1]} -P$AUDIO_DEVICE &>/dev/null &"; fm_pgm_pid=$(/usr/bin/echo $!); }
play_dab_1()         { eval "$DAB_1_SONG_FEED_PGM &>/dev/null &"; dab_1_song_feed_pid=$(/usr/bin/echo $!);
                       eval "/usr/bin/cat $DAB_1_PGM_INPUT_PIPE | $DAB_1_PGM ${DAB_1[$1]} -A $AUDIO_DEVICE &>$DAB_1_PGM_OUTPUT_PIPE &";
                       dab_1_pgm_pid=$(/usr/bin/echo $!); }
play_dab_2()         { eval "$DAB_2_SONG_FEED_PGM &>/dev/null &"; dab_2_song_feed_pid=$(/usr/bin/echo $!);
                       eval "/usr/bin/cat $DAB_2_PGM_INPUT_PIPE | $DAB_2_PGM ${DAB_2[$1]} -T &>$DAB_2_PGM_OUTPUT_PIPE &";
                       dab_2_pgm_pid=$(/usr/bin/echo $!); }
play_internet()      { /usr/bin/mpc play "$1" &>/dev/null; play_internet_feed; }
play_internet_feed() { eval "$NET_SONG_FEED_PGM &>/dev/null &"; internet_song_feed_pid=$(/usr/bin/echo $!); }
play_random()        { while true; do
                          cmd=$("$RANDOM_BY_GENRE_PGM" "$1" 2>/dev/null);
                          if [ "$cmd" == "Nothing Found!" ]; then talk_2_me "$cmd"; break; fi;
                          url=$(/usr/bin/echo $cmd | /usr/bin/cut -f1 -d' ');
                          if [ "$url" == "None" ] || [ "$url" == "listen_url" ]; then continue; fi;
                          /usr/bin/mpc del 41 &>/dev/null;
                          /usr/bin/mpc add "$url" &>/dev/null;
                          /usr/bin/mpc play 41 &>/dev/null;
                          ok=$(/usr/bin/echo $?); /usr/bin/sleep 1; status=$(/usr/bin/mpc status);
                          if ! /usr/bin/echo "$status" | /usr/bin/grep -q "ERROR: Failed" &&
                             [ "$ok" -eq 0 ]; then play_internet_feed; stop=0; break; fi; done; }
play_mp3()           { eval "$MP3_PGM -I dummy -q --alsa-audio-device $AUDIO_DEVICE -LZ /root/mp3 --gain 1 </dev/null &>/dev/null &";
                       mp3_pgm_pid=$(/usr/bin/echo $!); }
random_everything()  { mode=8; preset=0; talk_2_me "$t2m_play $t2m_random ${t2m_play_random[0]}"; stop_radio;
                       eval "$RANDOM_EVERYTHING_PGM &>/dev/null &"; play_internet_feed; stop=0; }
play_special_radio() { mode=4; preset=0; talk_2_me "$t2m_play $t2m_special $t2m_radio"; stop_radio;
                       /usr/bin/mpc del 41 &>/dev/null;
                       /usr/bin/mpc add "$special" &>/dev/null;
                       /usr/bin/mpc play 41 &>/dev/null;
                       play_internet_feed; stop=0; }
radio_play_stop()    { if [ "$stop" -eq 0 ]; then stop=1; stop_radio; talk_2_me "$t2m_radio $t2m_stop";
                       else                                           talk_2_me "$t2m_radio $t2m_play"; stop=0;
                         if [ "$mode" -eq 1 ]; then play_fm    "$preset";
                       elif [ "$mode" -eq 2 ]; then play_dab_1 "$preset";
                       elif [ "$mode" -eq 3 ]; then play_dab_2 "$preset";
                       elif [ "$mode" -eq 4 ]  ||
                            [ "$mode" -eq 5 ]  ||
                            [ "$mode" -eq 6 ]  ||
                            [ "$mode" -eq 7 ]  ||
                            [ "$mode" -eq 8 ]; then /usr/bin/mpc play &>/dev/null; play_internet_feed;
                       elif [ "$mode" -eq 9 ]; then play_mp3; fi; fi; }
play_next()          { if [ "$stop" -eq 0 ]; then
                       if [ "$mode" -eq 4 ]  ||
                          [ "$mode" -eq 5 ]  ||
                          [ "$mode" -eq 6 ]  ||
                          [ "$mode" -eq 7 ]  ||
                          [ "$mode" -eq 8 ]; then /usr/bin/mpc next &>/dev/null; fi; fi; }
play_previous()      { if [ "$stop" -eq 0 ]; then
                       if [ "$mode" -eq 4 ]  ||
                          [ "$mode" -eq 5 ]  ||
                          [ "$mode" -eq 6 ]  ||
                          [ "$mode" -eq 7 ]  ||
                          [ "$mode" -eq 8 ]; then /usr/bin/mpc prev &>/dev/null; fi; fi; }
update_database()    { stop_radio; stop=1; mute=0; set_sound_on; for i in $(/usr/bin/seq 1 3); do
                       /usr/bin/play -qV0 -v "$FLITE_VOLUME" "$UPDATE_DB_WARNING" &>/dev/null; done;
                       talk_2_me "$t2m_update_db"; eval "$UPDATE_DB_PGM &>/dev/null &"; }
power_down_system()  { stop_radio; stop=1; mute=0; set_sound_on; for i in $(/usr/bin/seq 1 4); do
                       /usr/bin/play -qV0 -v "$FLITE_VOLUME" "$POWER_DOWN_SYSTEM_WARNING" &>/dev/null; done;
                       talk_2_me "$t2m_shutting_down_the_radio"; /usr/bin/sleep 3; /usr/sbin/shutdown now; }
test_speaker()       { stop_radio; eval "$speaker_test &>/dev/null &"; test_speaker_pid=$(/usr/bin/echo $!); stop=0; }
show_up_since()      { h=$(date +'%H'); m=$(date +'%M'); s=$(date +'%S'); full_date_time=$(date +'%A %d %B %Y - %T');
                       up_since=$(/usr/bin/uptime --pretty); send_data "${full_date_time} - ${up_since}";
                       talk_2_me "$t2m_time $h $t2m_hour $m $t2m_minute $s $t2m_second"; }
show_cpu_and_temp()  { send_data "Please wait ..."; cmd=$("$cpu_and_temp"); send_data "TEMPERATURE=$cmd"; }
show_song_or_else()  { /usr/bin/echo "$1" > "$song_station_http"; }
send_data()          { /usr/bin/echo "${1}${STRING_DELIMITER}" > "$CALC";
                       /usr/bin/echo "${1}${STRING_DELIMITER}" >> "$LOG"; }
initialization

/usr/bin/cat "$CALC" | while read data; do
   data=$(/usr/bin/tr -dc '[[:print:]]' <<< "$data");
   operation="${data%=*}"; if [ ! "$operation" ] || [ "$operation" == "" ] || [ "$operation" == " " ]; then continue; fi;
   parameter="${data#*=}"; /usr/bin/echo "DATA=$data | OPERATION=$operation | PARAMETER=$parameter" >> "$LOG";
   if [ "$parameter" -eq "$parameter" ] 2>/dev/null; then
      case "${operation}" in
         $"init_mode")       value="$((parameter * 1))"; mode="$value";      stop_radio;;
         $"init_preset")     value="$((parameter * 1))"; preset="$value";    stop_radio;;
         $"init_volume")     value="$((parameter * 1))"; volume="$value";    set_sound_on; set_volume "$volume";;
         $"set_mode")        value="$((parameter * 1))"; mode="$value";      stop_radio; what_mode "$mode"; talk_2_me "$say_mode";;
         $"set_preset")      value="$((parameter * 1))"; preset="$value";    play_preset;;
         $"set_volume_up")   value="$((parameter * 1))"; volume="$value";    set_volume_up;;
         $"set_volume_down") value="$((parameter * 1))"; volume="$value";    set_volume_down;;
         $"set_mute")        value="$((parameter * 1))"; mute="$value";      set_mute;;
         $"set_equalizer")   value="$((parameter * 1))"; equalizer="$value"; set_equalizer;;
         $"play_random")                                                     random_everything;;
         $"play_special")                                                    play_special_radio;;
         $"play_stop")                                                       radio_play_stop;;
         $"play_next")                                                       play_next;;
         $"play_previous")                                                   play_previous;;
         $"test_speaker")                                                    test_speaker;;
         $"show_cpu_and_temp")                                               show_cpu_and_temp;;
         $"show_up_since")                                                   show_up_since;;
         $"show_song")                                                       show_song_or_else "1";;
         $"show_station")                                                    show_song_or_else "2";;
         $"show_http")                                                       show_song_or_else "3";;
         $"set_calc_off")                                                    show_song_or_else "0";;
         $"set_calc_on")                                                     show_song_or_else "1";;
         $"shut_down_radio")                                                 power_down_system;;
         *)                                                                  talk_2_me "$t2m_unknown_key_pressed";;
      esac
   fi
done
