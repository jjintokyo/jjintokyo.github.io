#!/bin/sh

####################################################
# OpenWrtRadio - Internet Radio On A Tight Budget! #
####################################################
#                                                  #
#                   my_radio.sh                    #
#                                                  #
#--------------------------------------------------#
#    Handles the Wireless Mouse with 5 Buttons     #
#                 and Scrollwheel                  #
#                                                  #
#               + the Wireless Keypad              #
#--------------------------------------------------#
#                                                  #
#               JJR / Mon Aug 9 2021               #
#                                                  #
####################################################

export PATH=$PATH:/mnt/sda1/packages/usr/bin/:/tmp/packages/usr/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/sda1/packages/usr/lib/:/tmp/packages/usr/lib/

page=1; preset=0; stop=0; volume=20; volume_step=1;

my_radio_pipe="/tmp/my_radio_pipe"; input_devices="/dev/input/event*";
random_everything="/root/my_radio/random_run.sh"; random_by_genre="/root/my_radio/random_run.py"; no_random="Nothing Found!";
espeak_player="/mnt/sda1/packages/usr/bin/espeak"; pico2wave_player="/mnt/sda1/packages/usr/bin/pico2wave"; pico2wave_file="/tmp/pico2wave.wav";
mp3_player="/mnt/sda1/packages/usr/bin/mpg123"; mp3_directory="/mnt/sda1/mp3/"; power_down_system_warning="/root/my_radio/BELL.WAV";
update_db_warning="/root/my_radio/DIVE.WAV"; update_database="/root/my_radio/random_set.sh &>/dev/null &";

t2m_page="page"; t2m_preset="preset"; t2m_radio="radio"; t2m_play="play"; t2m_stopped="stopped"; t2m_random="random";
t2m_from="from"; t2m_mp3="m.p.3"; t2m_player="player"; t2m_volume="volume"; t2m_up="up"; t2m_down="down"; t2m_percent="percent";
t2m_random_0="everything"; t2m_random_1="talk"; t2m_random_2="christmas"; t2m_random_3="alternative"; t2m_random_4="country";
t2m_random_5="oldies"; t2m_random_6="sixties"; t2m_random_7="seventies"; t2m_random_8="eighties"; t2m_random_9="nineties";
t2m_random_10="french"; t2m_random_11="french"; t2m_random_12="japanese"; t2m_random_13="scanner";
t2m_update_db="now. updating the data base... please wait a few minutes"; t2m_and="and"; t2m_time="the time is...";
t2m_hour="hour."; t2m_hours="hours."; t2m_minute="minute."; t2m_minutes="minutes."; t2m_second="second"; t2m_seconds="seconds";
t2m_pds="power down system";

play_random_0=""; play_random_1="talk"; play_random_2="christmas"; play_random_3="alternative"; play_random_4="country";
play_random_5="oldies"; play_random_6="60"; play_random_7="70"; play_random_8="80"; play_random_9="90";
play_random_10="fra"; play_random_11="french"; play_random_12="japanese"; play_random_13="scanner";

mouse_button_left='*BTN_LEFT	0	command*'
mouse_button_right='*BTN_RIGHT	0	command*'
mouse_button_left_right='*BTN_LEFT+BTN_RIGHT	2	command*'
mouse_button_middle='*BTN_MIDDLE	0	command*'
mouse_button_side_1='*BTN_EXTRA	0	command*'
mouse_button_side_1_long='*BTN_EXTRA	2	command*'
mouse_button_side_2='*BTN_SIDE	0	command*'
mouse_button_side_2_long='*BTN_SIDE	2	command*'
mouse_wheel_up='*REL_WHEEL	1	command*'
mouse_wheel_down='*REL_WHEEL	-1	command*'

keypad_enter='*KEY_KPENTER	0	command*'
keypad_numlock='*KEY_NUMLOCK	0	command*'
keypad_plus='*KEY_KPPLUS	0	command*'
keypad_plus_long='*KEY_KPPLUS	2	command*'
keypad_minus='*KEY_KPMINUS	0	command*'
keypad_minus_long='*KEY_KPMINUS	2	command*'
keypad_dot='*KEY_KPDOT	0	command*'
keypad_slash='*KEY_KPSLASH	0	command*'
keypad_asterisk='*KEY_KPASTERISK	0	command*'
keypad_back='*KEY_BACKSPACE	0	command*'
keypad_0='*KEY_KP0	0	command*'
keypad_1='*KEY_KP1	0	command*'
keypad_2='*KEY_KP2	0	command*'
keypad_3='*KEY_KP3	0	command*'
keypad_4='*KEY_KP4	0	command*'
keypad_5='*KEY_KP5	0	command*'
keypad_6='*KEY_KP6	0	command*'
keypad_7='*KEY_KP7	0	command*'
keypad_8='*KEY_KP8	0	command*'
keypad_9='*KEY_KP9	0	command*'
keypad_special_0='*KEY_NUMLOCK+KEY_KP0	1	command*'
keypad_special_1='*KEY_NUMLOCK+KEY_KP1	1	command*'
keypad_special_2='*KEY_NUMLOCK+KEY_KP2	1	command*'
keypad_special_3='*KEY_NUMLOCK+KEY_KP3	1	command*'
keypad_special_4='*KEY_NUMLOCK+KEY_KP4	1	command*'
keypad_special_5='*KEY_NUMLOCK+KEY_KP5	1	command*'
keypad_special_6='*KEY_NUMLOCK+KEY_KP6	1	command*'
keypad_special_7='*KEY_NUMLOCK+KEY_KP7	1	command*'
keypad_special_8='*KEY_NUMLOCK+KEY_KP8	1	command*'
keypad_special_9='*KEY_NUMLOCK+KEY_KP9	1	command*'
keypad_special_10='*KEY_NUMLOCK+KEY_BACKSPACE	1	command*'
keypad_special_11='*KEY_NUMLOCK+KEY_KPDOT	1	command*'

initialization()     { /bin/echo "my_radio.sh is starting..... `/bin/date`" > /dev/kmsg;
                       stop_radio; /usr/bin/mpc clear &>/dev/null;
                       /bin/sleep 15;
                       /usr/sbin/ntpd -q -p 0.openwrt.pool.ntp.org -p 1.openwrt.pool.ntp.org -p 2.openwrt.pool.ntp.org;
                       if ! /bin/grep -qs '/mnt/sda1' /proc/mounts && [ -b /dev/sda1 ]; then
                          if [ ! -d /mnt/sda1 ]; then /bin/mkdir -p /mnt/sda1; fi;
                          /bin/mount -t f2fs /dev/sda1 /mnt/sda1 -o rw,sync,noatime,nodiratime;
                          if [ ! -L /usr/share/espeak ]; then /bin/ln -s /mnt/sda1/packages/usr/share/espeak /usr/share/espeak; fi;
                          if [ ! -L /usr/share/pico ]; then /bin/ln -s /mnt/sda1/packages/usr/share/pico /usr/share/pico; fi;
                          if [ ! -L /usr/share/sounds ]; then /bin/ln -s /mnt/sda1/packages/usr/share/sounds /usr/share/sounds; fi;
                          if [ ! -L /usr/lib/mpg123 ]; then /bin/ln -s /mnt/sda1/packages/usr/lib/mpg123 /usr/lib/mpg123; fi;
                          if [ ! -L /usr/lib/sudo ]; then /bin/ln -s /mnt/sda1/packages/usr/lib/sudo /usr/lib/sudo; fi;
                          if [ ! -L /etc/sudoers ]; then /bin/ln -s /mnt/sda1/packages/etc/sudoers /etc/sudoers; fi; fi;
                       /bin/touch /tmp/url1.txt; /bin/touch /tmp/url2.txt; /bin/chmod 666 /tmp/url1.txt; /bin/chmod 666 /tmp/url2.txt;
                       /etc/init.d/mpd stop; /bin/mkdir -p /tmp/.mpd/playlists; /etc/init.d/mpd start;
                       /bin/chmod 775 -R /etc/sudoers.d/; /etc/init.d/apache2 restart;
                       /bin/cat /root/my_radio/playlist.db | /usr/bin/mpc add &>/dev/null; }
#talk_2_me()         { if [ "$stop" -eq 1 ] && [ -f "$espeak_player" ]; then "$espeak_player" --stdout "$1" | /usr/bin/aplay &>/dev/null; fi; }
talk_2_me()          { if [ "$stop" -eq 1 ] && [ -f "$pico2wave_player" ]; then "$pico2wave_player" -w "$pico2wave_file" -l "en-GB"\
                       "<volume level='80'><pitch level='133'><speed level='144'>$1" && /usr/bin/aplay "$pico2wave_file" &>/dev/null; fi; }
page_up()            { page=$(($page+1)); if [ "$page" -eq 7 ]; then page=1; fi; say_page "$page"; }
page_down()          { page=$(($page-1)); if [ "$page" -eq 0 ]; then page=6; fi; say_page "$page"; }
say_page()           { if [ "$stop" -eq 1 ]; then
                       if [ "$1" -eq 1 ] || [ "$1" -eq 2 ] || [ "$1" -eq 3 ] || [ "$1" -eq 4 ]; then talk_2_me "$t2m_page $1";
                       elif [ "$1" -eq 5 ]; then talk_2_me "$t2m_random $t2m_page";
                       elif [ "$1" -eq 6 ]; then talk_2_me "$t2m_mp3 $t2m_player"; fi; fi; }
preset_up()          { preset=$(($preset+1)); if [ "$preset" -eq 10 ]; then preset=0; fi; say_preset "$preset"; }
preset_down()        { preset=$(($preset-1)); if [ "$preset" -lt 0 ]; then preset=9; fi; say_preset "$preset"; }
say_preset()         { if [ "$stop" -eq 1 ]; then
                       if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ]; then talk_2_me "$t2m_preset $1";
                       elif [ "$page" -eq 5 ]; then what_say_genre "$1"; talk_2_me "$t2m_random $say";
                       elif [ "$page" -eq 6 ]; then talk_2_me "$t2m_mp3"; fi; fi; }
volume_up()          { volume=$(($volume+$1)); if [ "$volume" -gt 100 ]; then volume=100; else set_volume "$volume";
                       if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_volume $t2m_up $volume $t2m_percent"; fi; fi; }
volume_down()        { volume=$(($volume-$1)); if [ "$volume" -lt 0 ]; then volume=0; else set_volume "$volume";
                       if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_volume $t2m_down $volume $t2m_percent"; fi; fi; }
set_volume()         { /usr/bin/amixer sset "Speaker" "$1"% &>/dev/null; }
stop_radio()         { /usr/bin/mpc stop &>/dev/null; /usr/bin/killall -q mpg123; stop=1; }
radio_play_stop()    { if [ "$stop" -eq 0 ]; then stop_radio; talk_2_me "$t2m_radio $t2m_stopped"; else talk_2_me "$t2m_radio $t2m_play";
                       stop=0; if [ "$page" -ne 6 ]; then /usr/bin/mpc play &>/dev/null; else play_mp3; fi; fi; }
play_preset()        { if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ]; then
                       if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_play $t2m_preset $1 $t2m_from $t2m_page $page"; else stop_radio; fi;
                       /usr/bin/mpc play "$((($1+(($page-1))*10)+1))" &>/dev/null; stop=0;
                       elif [ "$page" -eq 5 ]; then random_by_genre "$1";
                       elif [ "$page" -eq 6 ]; then play_mp3; fi; }
play_next()          { if [ "$stop" -eq 0 ] && [ "$page" -ne 6 ]; then /usr/bin/mpc next &>/dev/null; else say_time; fi; }
play_previous()      { if [ "$stop" -eq 0 ] && [ "$page" -ne 6 ]; then /usr/bin/mpc prev &>/dev/null; else say_time; fi; }
random_everything()  { if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_random $t2m_play"; else stop_radio; fi; url=$("$random_everything");
                       if [ "$url" == "$no_random" ]; then stop=1; talk_2_me "$no_random"; else stop=0; /bin/echo "$url"; fi; }
random_by_genre()    { what_say_genre "$1"; if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_play $t2m_random $say"; else stop_radio; fi;
                       while true; do cmd=$("$random_by_genre" "$genre");
                          if [ "$cmd" == "$no_random" ] || [ "$cmd" == "" ]; then stop=1; talk_2_me "$no_random"; break; fi;
                          url=$(/bin/echo $cmd | /usr/bin/cut -f2 -d' ');
                          /bin/echo $url | /usr/bin/tee /tmp/url1.txt > /dev/null;
                          /usr/bin/mpc del 41 &>/dev/null;
                          /usr/bin/mpc add "$url" &>/dev/null;
                          /usr/bin/mpc play 41 &>/dev/null;
                          ok=$(/bin/echo $?); /bin/sleep 1; status=$(/usr/bin/mpc status);
                          if ! /bin/echo "$status" | /bin/grep -q "ERROR: Failed" && [ "$ok" -eq 0 ]; then stop=0; /bin/echo "$url"; break; fi;
                       done; }
what_say_genre()     { say=""; genre="";
                       if   [ "$1" == "0"    ]; then say=$t2m_random_0;  genre=$play_random_0;
                       elif [ "$1" == "1"    ]; then say=$t2m_random_1;  genre=$play_random_1;
                       elif [ "$1" == "2"    ]; then say=$t2m_random_2;  genre=$play_random_2;
                       elif [ "$1" == "3"    ]; then say=$t2m_random_3;  genre=$play_random_3;
                       elif [ "$1" == "4"    ]; then say=$t2m_random_4;  genre=$play_random_4;
                       elif [ "$1" == "5"    ]; then say=$t2m_random_5;  genre=$play_random_5;
                       elif [ "$1" == "6"    ]; then say=$t2m_random_6;  genre=$play_random_6;
                       elif [ "$1" == "7"    ]; then say=$t2m_random_7;  genre=$play_random_7;
                       elif [ "$1" == "8"    ]; then say=$t2m_random_8;  genre=$play_random_8;
                       elif [ "$1" == "9"    ]; then say=$t2m_random_9;  genre=$play_random_9;
                       elif [ "$1" == "fr1"  ]; then say=$t2m_random_10; genre=$play_random_10;
                       elif [ "$1" == "fr2"  ]; then say=$t2m_random_11; genre=$play_random_11;
                       elif [ "$1" == "jp"   ]; then say=$t2m_random_12; genre=$play_random_12;
                       elif [ "$1" == "scan" ]; then say=$t2m_random_13; genre=$play_random_13; fi; }
play_mp3()           { if [ -f "$mp3_player" ] && [ -d "$mp3_directory" ]; then
                       if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_play $t2m_random $t2m_mp3"; else stop_radio; /bin/sleep 1; fi;
                       /usr/bin/find "$mp3_directory" -iname "*.mp3" | "$mp3_player" -a "hw:0,0" -q -Z -@ - & stop=0; fi; }
shortcut_to_page()   { stop_radio; page="$1"; preset=0; say_page "$1"; }
shortcut_to_random() { stop_radio; random_by_genre "$1"; }
update_database()    { stop_radio; for i in $(/usr/bin/seq 1 3); do /usr/bin/aplay "$update_db_warning" &>/dev/null; done;
                       talk_2_me "$t2m_update_db"; eval "$update_database"; }
say_time()           { if [ "$stop" -eq 1 ]; then h=$(date +'%H'); m=$(date +'%M'); s=$(date +'%S');
                       if [ "$h" -gt 1 ]; then hour=$t2m_hours; else hour=$t2m_hour; fi;
                       if [ "$m" -gt 1 ]; then minute=$t2m_minutes; else minute=$t2m_minute; fi;
                       if [ "$s" -gt 1 ]; then second=$t2m_seconds; else second=$t2m_second; fi;
                       talk_2_me "$t2m_time $h $hour $m $minute $t2m_and $s $second"; fi; }
power_down_system()  { stop_radio; /etc/init.d/mpd stop;
                       for i in $(/usr/bin/seq 1 4); do /usr/bin/aplay "$power_down_system_warning" &>/dev/null; done;
                       talk_2_me "$t2m_pds"; /bin/sleep 1; if /bin/grep -qs '/mnt/sda1' /proc/mounts; then /bin/umount /mnt/sda1; /bin/sleep 1; fi;
                       /sbin/poweroff; }

initialization
set_volume "$volume"
play_preset "$preset"

while true; do
   /usr/bin/killall -q thd;
   /bin/sleep 1; /bin/rm -f $my_radio_pipe; /usr/bin/mkfifo $my_radio_pipe;
   /usr/sbin/thd --dump $input_devices | /usr/bin/awk "/^# BTN|^# REL_WHEEL|^# KEY/{print}" > $my_radio_pipe &
   while read line; do
      case $line in
         ($mouse_button_left)          play_preset "$preset";;
         ($mouse_button_right)         radio_play_stop;;
         ($mouse_button_left_right)    power_down_system; break;;
         ($mouse_button_middle)        random_everything;;
         ($mouse_button_side_1)        page_up;;
         ($mouse_button_side_1_long)   page_down; break;;
         ($mouse_button_side_2)        preset_up;;
         ($mouse_button_side_2_long)   preset_down; break;;
         ($mouse_wheel_up)             volume_up "$(($volume_step*2))";;
         ($mouse_wheel_down)           volume_down "$(($volume_step*2))";;
         ($keypad_enter)               page_up;;
         ($keypad_numlock)             page_down;;
         ($keypad_plus)                volume_up "$volume_step";;
         ($keypad_plus_long)           volume_up "$(($volume_step*3))";;
         ($keypad_minus)               volume_down "$volume_step";;
         ($keypad_minus_long)          volume_down "$(($volume_step*3))";;
         ($keypad_dot)                 radio_play_stop;;
         ($keypad_slash)               play_next;;
         ($keypad_asterisk)            play_previous;;
         ($keypad_back)                random_everything;;
         ($keypad_0)                   play_preset "0";;
         ($keypad_1)                   play_preset "1";;
         ($keypad_2)                   play_preset "2";;
         ($keypad_3)                   play_preset "3";;
         ($keypad_4)                   play_preset "4";;
         ($keypad_5)                   play_preset "5";;
         ($keypad_6)                   play_preset "6";;
         ($keypad_7)                   play_preset "7";;
         ($keypad_8)                   play_preset "8";;
         ($keypad_9)                   play_preset "9";;
         ($keypad_special_0)           play_mp3; break;;
         ($keypad_special_1)           shortcut_to_page "1"; break;;
         ($keypad_special_2)           shortcut_to_page "2"; break;;
         ($keypad_special_3)           shortcut_to_page "3"; break;;
         ($keypad_special_4)           shortcut_to_page "4"; break;;
         ($keypad_special_5)           shortcut_to_page "5"; break;;
         ($keypad_special_6)           shortcut_to_random "fr1"; break;;
         ($keypad_special_7)           shortcut_to_random "fr2"; break;;
         ($keypad_special_8)           shortcut_to_random "jp"; break;;
         ($keypad_special_9)           shortcut_to_random "scan"; break;;
         ($keypad_special_10)          update_database; break;;
         ($keypad_special_11)          power_down_system; break;;
      esac
   done < $my_radio_pipe
done
