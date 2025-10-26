#!/bin/sh

####################################################
# OpenWrtRadio - Internet Radio On A Tight Budget! #
####################################################
#                                                  #
#                   portable2.sh                   #
#                                                  #
#            Oldies But Goodies Jukebox            #
#                                                  #
#--------------------------------------------------#
#        Handles the IR remote with Arduino        #
#--------------------------------------------------#
#                                                  #
#               JJR / Mon Oct 6 2025               #
#                                                  #
####################################################

export PATH=$PATH:/mnt/sda1/packages/usr/bin/:/tmp/packages/usr/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/sda1/packages/usr/lib/:/tmp/packages/usr/lib/

oldies_mode=0; page=1; preset=0; stop=0; volume=20; volume_step=1; mute=0;
arduino="/dev/ttyUSB0"; random_everything="/root/my_radio/random_run.sh"; random_by_genre="/root/my_radio/random_run.py"; no_random="Nothing Found!";
espeak_player="/mnt/sda1/packages/usr/bin/espeak"; pico2wave_player="/mnt/sda1/packages/usr/bin/pico2wave"; pico2wave_file="/tmp/pico2wave.wav";
mp3_player="/mnt/sda1/packages/usr/bin/mpg123"; mp3_directory="/mnt/sda1/mp3/"; power_down_system_warning="/root/my_radio/BELL.WAV";
update_db_warning="/root/my_radio/DIVE.WAV"; update_database="/root/my_radio/random_set.sh &>/dev/null &";
connect_to_wifi="/root/my_radio/CONNECT.WAV"; speaker_test="/mnt/sda1/packages/usr/bin/speaker-test -Dhw:0,0 -c2 -twav &>/dev/null &";
test_if_file_exists="/mnt/sda1/random/yp.db";

t2m_oldies_mode="radio switch to oldies mode"; t2m_regular_mode="radio switch to regular mode";
t2m_page="page"; t2m_preset="preset"; t2m_radio="radio"; t2m_play="play"; t2m_stopped="stopped"; t2m_random="random";
t2m_from="from"; t2m_mp3="m.p.3"; t2m_player="player"; t2m_volume="volume"; t2m_up="up"; t2m_down="down"; t2m_percent="percent";
t2m_random_0="everything"; t2m_random_1="talk"; t2m_random_2="christmas"; t2m_random_3="alternative"; t2m_random_4="country";
t2m_random_5="oldies"; t2m_random_6="sixties"; t2m_random_7="seventies"; t2m_random_8="eighties"; t2m_random_9="nineties";
t2m_random_10="french"; t2m_random_11="french"; t2m_random_12="japanese"; t2m_random_13="scanner";
t2m_update_db="now. updating the data base... please wait a few minutes"; t2m_and="and"; t2m_time="the time is...";
t2m_hour="hour."; t2m_hours="hours."; t2m_minute="minute."; t2m_minutes="minutes."; t2m_second="second"; t2m_seconds="seconds";
t2m_pds="power down system"; t2m_dab_server="dab server"; t2m_is_down="is down";
t2m_mute="mute"; t2m_unmute="unmute";

play_random_0=""; play_random_1="talk"; play_random_2="christmas"; play_random_3="alternative"; play_random_4="country";
play_random_5="oldies"; play_random_6="60"; play_random_7="70"; play_random_8="80"; play_random_9="90";
play_random_10="fra"; play_random_11="french"; play_random_12="japanese"; play_random_13="scanner";

dab_server_url="http://192.168.1.222:1222"; dab_server_ip="192.168.1.222"; old_dab_channel="";
export SSHPASS="jjintokyo"; dab_server_shutdown="/usr/bin/sshpass -e /usr/bin/ssh -T -y -y root@'$dab_server_ip' 'sudo shutdown -h now' &";
FRANCE_INFO="0xf206"; BFM_RADIO="0xf2fd"; EUROPE_1="0xf213"; RTL="0xf211"; NOSTALGIE="0xf2fa";
MELODY="0xf9f5"; MELODY_CH="0x4dfb"; KISS_COLLECTOR="0x4deb"; IP_MUSIC_80="0x4dc0"; SPOON_BALLADS="0x4df6";

initialization()     { /bin/echo "portable2.sh is starting..... `/bin/date`" > /dev/kmsg;
                       /bin/stty -F "$arduino" sane speed 9600;
                       stop_radio;
                       while true; do /bin/ping -c1 google.com &>/dev/null && break; /usr/bin/aplay "$connect_to_wifi" &>/dev/null; /bin/sleep 1; done;
                       /usr/sbin/ntpd -n -q -p 0.openwrt.pool.ntp.org -p 1.openwrt.pool.ntp.org -p 2.openwrt.pool.ntp.org &>/dev/null;
                       /bin/echo "Connected to Wi-Fi! `/bin/date`" > /dev/kmsg;
                       if ! /bin/grep -qs '/mnt/sda1' /proc/mounts && [ -b /dev/sda1 ]; then
                          if [ ! -d /mnt/sda1 ]; then /bin/mkdir -p /mnt/sda1; fi;
                          /bin/mount -t f2fs /dev/sda1 /mnt/sda1 -o rw,sync,noatime,nodiratime;
                          if [ ! -L /usr/share/espeak   ]; then /bin/ln -s /mnt/sda1/packages/usr/share/espeak   /usr/share/espeak;   fi;
                          if [ ! -L /usr/share/pico     ]; then /bin/ln -s /mnt/sda1/packages/usr/share/pico     /usr/share/pico;     fi;
                          if [ ! -L /usr/share/sounds   ]; then /bin/ln -s /mnt/sda1/packages/usr/share/sounds   /usr/share/sounds;   fi;
                          if [ ! -L /usr/lib/mpg123     ]; then /bin/ln -s /mnt/sda1/packages/usr/lib/mpg123     /usr/lib/mpg123;     fi;
                          if [ ! -L /usr/lib/sudo       ]; then /bin/ln -s /mnt/sda1/packages/usr/lib/sudo       /usr/lib/sudo;       fi;
                          if [ ! -L /etc/sudoers        ]; then /bin/ln -s /mnt/sda1/packages/etc/sudoers        /etc/sudoers;        fi;
                          if [ ! -L /etc/init.d/apache2 ]; then /bin/ln -s /mnt/sda1/packages/etc/init.d/apache2 /etc/init.d/apache2; fi;
                          if [ ! -L /usr/sbin/apachectl ]; then /bin/ln -s /mnt/sda1/packages/usr/sbin/apachectl /usr/sbin/apachectl; fi;
                          if [ ! -L /usr/sbin/apache2   ]; then /bin/ln -s /mnt/sda1/packages/usr/sbin/apache2   /usr/sbin/apache2;   fi;
                          if [ ! -L /usr/lib/apache2    ]; then /bin/ln -s /mnt/sda1/packages/usr/lib/apache2    /usr/lib/apache2;    fi;
                          if [ ! -L /etc/apache2        ]; then /bin/ln -s /mnt/sda1/packages/etc/apache2        /etc/apache2;        fi; fi;
                       if [ ! -e "$test_if_file_exists" ]; then exit 1; fi;
                       /bin/touch /tmp/url1.txt; /bin/touch /tmp/url2.txt; /bin/chmod 666 /tmp/url1.txt; /bin/chmod 666 /tmp/url2.txt;
                       /etc/init.d/mpd stop; /bin/mkdir -p /tmp/.mpd/playlists; /etc/init.d/mpd start;
                       /bin/chmod 775 -R /etc/sudoers.d/; /bin/mkdir -p /var/log/apache2; /bin/mkdir -p /var/run/apache2; /etc/init.d/apache2 restart;
                       set_volume "$volume"; set_regular_mode; }
#talk_2_me()         { if [ "$stop" -eq 1 ] && [ "$mute" -eq 0 ] && [ -f "$espeak_player" ]; then "$espeak_player" --stdout "$1" | /usr/bin/aplay &>/dev/null; fi; }
talk_2_me()          { if [ "$stop" -eq 1 ] && [ "$mute" -eq 0 ] && [ -f "$pico2wave_player" ]; then "$pico2wave_player" -w "$pico2wave_file" -l "en-GB"\
                       "<volume level='80'><pitch level='133'><speed level='144'>$1" && /usr/bin/aplay "$pico2wave_file" &>/dev/null; fi; }
set_oldies_mode()    { stop_radio; talk_2_me "$t2m_oldies_mode";
                       /usr/bin/mpc clear &>/dev/null; /bin/cat /root/my_radio/oldies.db | /usr/bin/mpc add &>/dev/null; /usr/bin/mpc repeat on &>/dev/null;
                       page=1; preset=0; play_preset "$preset"; }
set_regular_mode()   { stop_radio; talk_2_me "$t2m_regular_mode";
                       /usr/bin/mpc clear &>/dev/null; /bin/cat /root/my_radio/playlist.db | /usr/bin/mpc add &>/dev/null; /usr/bin/mpc repeat on &>/dev/null;
                       page=1; preset=0; play_preset "$preset"; }
set_mode()           { if [ "$oldies_mode" -eq 0 ]; then oldies_mode=1; set_oldies_mode;
                                                    else oldies_mode=0; set_regular_mode; fi; }
page_up()            { page=$(($page+1)); if [ "$page" -eq 8 ]; then page=1; fi; say_page "$page"; }
page_down()          { page=$(($page-1)); if [ "$page" -eq 0 ]; then page=7; fi; say_page "$page"; }
say_page()           { if [ "$stop" -eq 1 ]; then
                       if   [ "$1" -eq 1 ] || [ "$1" -eq 2 ] || [ "$1" -eq 3 ] || [ "$1" -eq 4 ]; then talk_2_me "$t2m_page $1";
                       elif [ "$1" -eq 5 ]; then talk_2_me "$t2m_random $t2m_page";
                       elif [ "$1" -eq 6 ]; then talk_2_me "$t2m_mp3 $t2m_player";
                       elif [ "$1" -eq 7 ]; then talk_2_me "$t2m_dab_server"; fi; fi; }
preset_up()          { preset=$(($preset+1)); if [ "$preset" -eq 10 ]; then preset=0; fi; say_preset "$preset"; }
preset_down()        { preset=$(($preset-1)); if [ "$preset" -lt 0 ]; then preset=9; fi; say_preset "$preset"; }
say_preset()         { if [ "$stop" -eq 1 ]; then
                       if   [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ] || [ "$page" -eq 7 ];
                       then talk_2_me "$t2m_preset $1";
                       elif [ "$page" -eq 5 ]; then what_say_genre "$1"; talk_2_me "$t2m_random $say";
                       elif [ "$page" -eq 6 ]; then talk_2_me "$t2m_mp3"; fi; fi; }
volume_up()          { volume=$(($volume+$1)); if [ "$volume" -gt 100 ]; then volume=100; else set_volume "$volume";
                       if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_volume $t2m_up $volume $t2m_percent"; fi; fi; }
volume_down()        { volume=$(($volume-$1)); if [ "$volume" -lt 0 ]; then volume=0; else set_volume "$volume";
                       if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_volume $t2m_down $volume $t2m_percent"; fi; fi; }
set_volume()         { /usr/bin/amixer sset "Speaker" "$1"% &>/dev/null; }
set_sound_on()       { /usr/bin/amixer sset "Speaker" unmute &>/dev/null; }
set_sound_off()      { /usr/bin/amixer sset "Speaker" mute &>/dev/null; }
set_mute()           { if [ "$mute" -eq 0 ]; then talk_2_me "$t2m_mute $t2m_radio"; mute=1; set_sound_off;
                                             else set_sound_on; mute=0; talk_2_me "$t2m_unmute $t2m_radio"; fi; }
stop_radio()         { /usr/bin/mpc stop &>/dev/null; /usr/bin/killall -q mpg123; /usr/bin/killall -q speaker-test; stop=1; }
radio_play_stop()    { if [ "$stop" -eq 0 ]; then stop_radio; talk_2_me "$t2m_radio $t2m_stopped";
                       else talk_2_me "$t2m_radio $t2m_play"; stop=0;
                       if   [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ] || [ "$page" -eq 5 ]; then
                       /usr/bin/mpc play &>/dev/null;
                       elif [ "$page" -eq 6 ]; then play_mp3;
                       elif [ "$page" -eq 7 ]; then play_dab "$preset"; fi; fi; }
play_preset()        { if   [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ]; then
                       if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_play $t2m_preset $1 $t2m_from $t2m_page $page"; else stop_radio; fi;
                       /usr/bin/mpc play "$((($1+(($page-1))*10)+1))" &>/dev/null; stop=0;
                       elif [ "$page" -eq 5 ]; then random_by_genre "$1";
                       elif [ "$page" -eq 6 ]; then play_mp3;
                       elif [ "$page" -eq 7 ]; then play_dab "$1"; fi; }
play_next()          { if [ "$stop" -eq 0 ] && [ "$page" -lt 6 ]; then /usr/bin/mpc next &>/dev/null; else say_time; fi; }
play_previous()      { if [ "$stop" -eq 0 ] && [ "$page" -lt 6 ]; then /usr/bin/mpc prev &>/dev/null; else say_time; fi; }
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
                       if   [ "$1" == "0"    ]; then say="$t2m_random_0";  genre="$play_random_0";
                       elif [ "$1" == "1"    ]; then say="$t2m_random_1";  genre="$play_random_1";
                       elif [ "$1" == "2"    ]; then say="$t2m_random_2";  genre="$play_random_2";
                       elif [ "$1" == "3"    ]; then say="$t2m_random_3";  genre="$play_random_3";
                       elif [ "$1" == "4"    ]; then say="$t2m_random_4";  genre="$play_random_4";
                       elif [ "$1" == "5"    ]; then say="$t2m_random_5";  genre="$play_random_5";
                       elif [ "$1" == "6"    ]; then say="$t2m_random_6";  genre="$play_random_6";
                       elif [ "$1" == "7"    ]; then say="$t2m_random_7";  genre="$play_random_7";
                       elif [ "$1" == "8"    ]; then say="$t2m_random_8";  genre="$play_random_8";
                       elif [ "$1" == "9"    ]; then say="$t2m_random_9";  genre="$play_random_9";
                       elif [ "$1" == "fr1"  ]; then say="$t2m_random_10"; genre="$play_random_10";
                       elif [ "$1" == "fr2"  ]; then say="$t2m_random_11"; genre="$play_random_11";
                       elif [ "$1" == "jp"   ]; then say="$t2m_random_12"; genre="$play_random_12";
                       elif [ "$1" == "scan" ]; then say="$t2m_random_13"; genre="$play_random_13"; fi; }
play_mp3()           { if [ -f "$mp3_player" ] && [ -d "$mp3_directory" ]; then
                       if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_play $t2m_random $t2m_mp3"; else stop_radio; /bin/sleep 1; fi;
                       /usr/bin/find "$mp3_directory" -iname "*.mp3" | "$mp3_player" -a "hw:0,0" -q -Z -@ - &>/dev/null & stop=0; fi; }
dab_channel()        { if [ "$1" != "$old_dab_channel" ]; then /usr/bin/curl -X POST --data "$1" "$dab_server_url/channel" &>/dev/null;
                       /bin/sleep 15; old_dab_channel="$1"; fi; }
play_dab()           { if /bin/ping -c1 -W1 "$dab_server_ip" &>/dev/null; then
                       if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_play $t2m_preset $1 $t2m_from $t2m_dab_server";
                       else stop_radio; /bin/sleep 1; fi;
                       if   [ "$1" == "0" ]; then   dab_channel "7B";    dab_radio="$FRANCE_INFO";
                       elif [ "$1" == "1" ]; then   dab_channel "7B";    dab_radio="$BFM_RADIO";
                       elif [ "$1" == "2" ]; then   dab_channel "7B";    dab_radio="$EUROPE_1";
                       elif [ "$1" == "3" ]; then   dab_channel "7A";    dab_radio="$RTL";
                       elif [ "$1" == "4" ]; then   dab_channel "7A";    dab_radio="$NOSTALGIE";
                       elif [ "$1" == "5" ]; then   dab_channel "7C";    dab_radio="$MELODY";
                       elif [ "$1" == "6" ]; then   dab_channel "10C";   dab_radio="$MELODY_CH";
                       elif [ "$1" == "7" ]; then   dab_channel "10C";   dab_radio="$KISS_COLLECTOR";
                       elif [ "$1" == "8" ]; then   dab_channel "10C";   dab_radio="$IP_MUSIC_80";
                       elif [ "$1" == "9" ]; then   dab_channel "8C";    dab_radio="$SPOON_BALLADS"; fi;
                       "$mp3_player" -a "hw:0,0" -q "$dab_server_url/mp3/$dab_radio" &>/dev/null & stop=0;
                       else stop_radio; /bin/sleep 1; talk_2_me "$t2m_dab_server $t2m_is_down"; fi; }
update_database()    { stop_radio; mute=0; set_sound_on;
                       for i in $(/usr/bin/seq 1 3); do /usr/bin/aplay "$update_db_warning" &>/dev/null; done;
                       talk_2_me "$t2m_update_db"; eval "$update_database"; }
say_time()           { if [ "$stop" -eq 1 ]; then h=$(date +'%H'); m=$(date +'%M'); s=$(date +'%S');
                       if [ "$h" -gt 1 ]; then hour="$t2m_hours"; else hour="$t2m_hour"; fi;
                       if [ "$m" -gt 1 ]; then minute="$t2m_minutes"; else minute="$t2m_minute"; fi;
                       if [ "$s" -gt 1 ]; then second="$t2m_seconds"; else second="$t2m_second"; fi;
                       talk_2_me "$t2m_time $h $hour $m $minute $t2m_and $s $second"; fi; }
power_down_system()  { stop_radio; mute=0; set_sound_on; /etc/init.d/mpd stop;
                       for i in $(/usr/bin/seq 1 4); do /usr/bin/aplay "$power_down_system_warning" &>/dev/null; done;
                       talk_2_me "$t2m_pds"; eval "$dab_server_shutdown"; /bin/sleep 10;
                       if /bin/grep -qs '/mnt/sda1' /proc/mounts; then /bin/umount /mnt/sda1; /bin/sleep 1; fi;
                       /sbin/poweroff; }

initialization

cat "$arduino" | while read data; do
   if   [ "$data" == "" ];         then continue; fi;
   if   [ "$data" != "FFFFFFFF" ]; then previous="";
   elif [ "$previous" != "" ];     then data="$previous"; else continue; fi;
   case "$data" in
      $'A05F20DF')   if [ "$previous" == "" ]; then volume_step=1; else volume_step=3; fi; previous="$data"; volume_up   "$volume_step";;
      $'A05FA05F')   if [ "$previous" == "" ]; then volume_step=1; else volume_step=3; fi; previous="$data"; volume_down "$volume_step";;
      $'A05F609F')   set_mute;;
      $'A05FE817')   page_up;;
      $'A05F18E7')   page_down;;
      $'A05FB847')   preset_up;;
      $'A05F38C7')   preset_down;;
      $'A05F6897')   play_preset "$preset";;
      $'A05F10EF')   radio_play_stop;;
      $'A05F40BF')   play_next;;
      $'A05FC03F')   play_previous;;
      $'A05F6A95')   random_everything;;
      $'A05FC837')   play_mp3;;
      $'A05FB24D')   random_by_genre "5";;
      $'A05FA857')   stop_radio; /bin/sleep 1; eval "$speaker_test"; stop=0;;
      $'A05F48B7')   play_preset "0";;
      $'A05F906F')   play_preset "1";;
      $'A05F50AF')   play_preset "2";;
      $'A05FD02F')   play_preset "3";;
      $'A05F30CF')   play_preset "4";;
      $'A05FB04F')   play_preset "5";;
      $'A05F708F')   play_preset "6";;
      $'A05FF00F')   play_preset "7";;
      $'A05F08F7')   play_preset "8";;
      $'A05F8877')   play_preset "9";;
      $'A05FE01F')   if [ "$mute" -eq 1 ]; then update_database; else set_mode; fi;;
      $'A05F807F')   if [ "$mute" -eq 1 ]; then power_down_system; fi;;
   esac
done
