#!/bin/bash

####################################################
#                                                  #
#                   my_radio.sh                    #
#                                                  #
#--------------------------------------------------#
#                                                  #
#        Internet Radio On A Tight Budget!         #
#                                                  #
#              Raspberry Pi Zero 2 W               #
#                                                  #
#           Your tiny, tiny $15 computer           #
#                                                  #
#--------------------------------------------------#
#                                                  #
#            JJR / Sunday 20 April 2025            #
#                                                  #
####################################################

page=1; preset=0; stop=1; volume=10; volume_step=1; equal=1; voice=1; backlight=0; setup_item=0;
FLITE="/tmp/flite.wav"; INPUT_DEVICES="/dev/input/event*"; AUDIO_DEVICE="equal";
MY_RADIO_INPUT_PIPE="/tmp/my_radio_input"; MY_RADIO_OUTPUT_PIPE="/tmp/my_radio_output";
DIVE="/home/jj/raspberrypizero2w/my_radio/DIVE.WAV";

t2m_blank=". . ."; t2m_internet_radio_page_one="internet radio page one"; t2m_internet_radio_page_two="internet radio page two";
t2m_internet_radio_page_three="internet radio page three"; t2m_internet_radio_page_four="internet radio page four";
t2m_random_internet_radio="random internet radio"; t2m_mp3_player_320="mp3 player 320"; t2m_mp3_player_flac="mp3 player flac";
t2m_page="page"; t2m_preset="preset"; t2m_random="random"; t2m_mp3="mp3"; t2m_radio="radio"; t2m_play="play"; t2m_stop="stop";
t2m_setup="setup"; t2m_equalizer="equalizer"; t2m_backlight="backlight"; t2m_database="database"; t2m_pds="power down system";
t2m_volume="volume"; t2m_down="down"; t2m_up="up"; t2m_percent="percent"; t2m_from="from";
t2m_equalizer_is_on="equalizer is on"; t2m_equalizer_is_off="equalizer is off"; t2m_dab_server="dab server"; t2m_is_down="is down";
t2m_time="the time is. "; t2m_hour="hour. "; t2m_minute="minute. "; t2m_second="second. ";
t2m_update_db="now. updating the data base... please wait a few minutes";
t2m_random_table=( "everything" "talk" "pop" "alternative" "country" "oldies" "60s" "70s" "80s" "90s" );
play_random=( "" "talk" "pop" "alternative" "country" "oldies" "60" "70" "80" "90" );

dab_server_url="http://192.168.1.222:1222"; dab_server_ip="192.168.1.222"; old_dab_channel="";
export SSHPASS="jjintokyo"; dab_server_shutdown="/usr/bin/sshpass -e /usr/bin/ssh -T -y -y root@$dab_server_ip 'sudo shutdown -h now' &";
FRANCE_INFO="0xf206"; BFM_RADIO="0xf2fd"; EUROPE_1="0xf213"; RTL="0xf211"; NOSTALGIE="0xf2fa";
MELODY="0xf9f5"; MELODY_CH="0x4dfb"; KISS_COLLECTOR="0x4deb"; SPOON_CLASSICS="0x4ed7"; SPOON_BALLADS="0x4df6";

REMOTE_KEY_VOLUMEUP='*KEY_VOLUMEUP	1*'
REMOTE_KEY_VOLUMEDOWN='*KEY_VOLUMEDOWN	1*'
REMOTE_KEY_UP='*KEY_UP	1*'
REMOTE_KEY_DOWN='*KEY_DOWN	1*'
REMOTE_KEY_LEFT='*KEY_LEFT	1*'
REMOTE_KEY_RIGHT='*KEY_RIGHT	1*'
REMOTE_KEY_SELECT='*KEY_SELECT	1*'
REMOTE_KEY_APPSELECT='*KEY_APPSELECT	1*'
REMOTE_KEY_BACK='*KEY_BACK	1*'
REMOTE_KEY_HOMEPAGE='*KEY_HOMEPAGE	1*'
REMOTE_KEY_VIDEO='*KEY_VIDEO	1*'
REMOTE_KEY_YELLOW='*KEY_YELLOW	1*'

initialization()      { sudo su -c '/usr/bin/echo "my_radio.sh is starting ... `/usr/bin/date`" > /dev/kmsg';
                        sudo /usr/sbin/iw wlan0 set power_save off;
                        sudo /usr/bin/journalctl --vacuum-size=64M &>/dev/null;
                        export LIBASOUND_THREAD_SAFE=0;
                        sudo /usr/bin/killall -q bluealsad;
                        ### sudo /usr/bin/bluealsad --syslog --all-codecs --profile=a2dp-source &
                        ### sudo /usr/bin/bluealsad --syslog --profile=a2dp-source &
                        ### sudo /usr/bin/bluealsad --syslog --profile=a2dp-source --codec=AAC --keep-alive=15 &
                        sudo /usr/bin/bluealsad --syslog --profile=a2dp-source --codec=LC3plus &
                        /usr/bin/sleep 5;
                        ### /usr/bin/bluetoothctl -- connect 20:18:5B:E7:0F:55 &>/dev/null;
                        /usr/bin/bluetoothctl -- connect 10:28:74:7E:58:F4 &>/dev/null;
                        /usr/bin/sleep 5;
                        ### /usr/bin/amixer -D bluealsa sset "JBL Xtreme 4 A2DP" 50% &>/dev/null;
                        /usr/bin/amixer -D bluealsa sset "JBL Pulse 5 A2DP" 75% &>/dev/null;
                        /usr/bin/rm -f  "$MY_RADIO_INPUT_PIPE" "$MY_RADIO_OUTPUT_PIPE";
                        /usr/bin/mkfifo "$MY_RADIO_INPUT_PIPE" "$MY_RADIO_OUTPUT_PIPE";
                        sudo /usr/bin/killall -q my_radio_remote.sh;    /home/jj/raspberrypizero2w/my_radio/my_radio_remote.sh &
                        sudo /usr/bin/killall -q my_radio_input.py;     /home/jj/raspberrypizero2w/my_radio/my_radio_input.py &
                        sudo /usr/bin/killall -q my_radio_output.py;    /home/jj/raspberrypizero2w/my_radio/my_radio_output.py &
                        sudo /usr/bin/killall -q my_radio_song_feed.sh; /home/jj/raspberrypizero2w/my_radio/my_radio_song_feed.sh &
                        stop_radio; stop=1; voice=0; set_volume "$volume"; set_equalizer; load_net_playlist; display_page_preset; voice=1;
                        play_preset; }
talk_2_me()           { if [ "$stop" -eq 1 ] && [ "$voice" -eq 1 ]; then
                        /usr/bin/flite -t "$1" -o $FLITE -voice slt --setf duration_stretch=.7 --setf int_f0_target_mean=237 &>/dev/null &&
                        sudo /usr/bin/vlc2 -I dummy -q -A bluealsa --gain=0.8 --play-and-exit $FLITE </dev/null &>/dev/null &
                        /usr/bin/sleep 1; fi; }
load_net_playlist()   { /usr/bin/mpc stop &>/dev/null;
                        /usr/bin/mpc clear &>/dev/null;
                        /usr/bin/cat /home/jj/raspberrypizero2w/my_radio/playlist.db | /usr/bin/mpc add &>/dev/null;
                        /usr/bin/mpc repeat on &>/dev/null;
                        /usr/bin/mpc volume 100 &>/dev/null; }
page_up()             { setup_item=0; ((page+=1)); if [ "$page" -eq 10 ]; then page=1; fi; say_page; }
page_down()           { setup_item=0; ((page-=1)); if [ "$page" -eq 0  ]; then page=9; fi; say_page; }
say_page()            { display_page_preset;
                          if [ "$page" -eq 1 ]; then talk_2_me "$t2m_blank $t2m_internet_radio_page_one";
                        elif [ "$page" -eq 2 ]; then talk_2_me "$t2m_blank $t2m_internet_radio_page_two";
                        elif [ "$page" -eq 3 ]; then talk_2_me "$t2m_blank $t2m_internet_radio_page_three";
                        elif [ "$page" -eq 4 ]; then talk_2_me "$t2m_blank $t2m_internet_radio_page_four";
                        elif [ "$page" -eq 5 ]; then talk_2_me "$t2m_blank $t2m_random_internet_radio";
                        elif [ "$page" -eq 6 ]; then talk_2_me "$t2m_blank $t2m_mp3_player_320";
                        elif [ "$page" -eq 7 ]; then talk_2_me "$t2m_blank $t2m_mp3_player_flac";
                        elif [ "$page" -eq 8 ]; then talk_2_me "$t2m_blank $t2m_dab_server";
                        elif [ "$page" -eq 9 ]; then talk_2_me "$t2m_blank $t2m_setup $t2m_radio"; fi; }
preset_up()           { if [ "$page" -ne 6 ] && [ "$page" -ne 7 ]; then
                        if [ "$page" -ne 9 ]; then ((preset+=1));     if [ "$preset"     -eq 10 ]; then preset=0;     fi;
                                              else ((setup_item+=1)); if [ "$setup_item" -eq 5  ]; then setup_item=1; fi; fi;
                        say_preset; fi; }
preset_down()         { if [ "$page" -ne 6 ] && [ "$page" -ne 7 ]; then
                        if [ "$page" -ne 9 ]; then ((preset-=1));     if [ "$preset"     -lt 0 ]; then preset=9;     fi;
                                              else ((setup_item-=1)); if [ "$setup_item" -lt 1 ]; then setup_item=4; fi; fi;
                        say_preset; fi; }
say_preset()          { display_page_preset;
                        if   [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ] || [ "$page" -eq 8 ];
                        then talk_2_me "$t2m_blank $t2m_preset $preset";
                        elif [ "$page" -eq 5 ]; then talk_2_me "$t2m_blank $t2m_random ${t2m_random_table[$preset]}";
                        elif [ "$page" -eq 9 ]; then if   [ "$setup_item" -eq 1 ]; then talk_2_me "$t2m_blank $t2m_setup $t2m_equalizer";
                                                     elif [ "$setup_item" -eq 2 ]; then talk_2_me "$t2m_blank $t2m_setup $t2m_backlight";
                                                     elif [ "$setup_item" -eq 3 ]; then talk_2_me "$t2m_blank $t2m_setup $t2m_database";
                                                     elif [ "$setup_item" -eq 4 ]; then talk_2_me "$t2m_blank $t2m_pds"; fi; fi; }
display_page_preset() { display="";
                          if [ "$page" -eq 1 ]; then display="NET1 / P$preset";
                        elif [ "$page" -eq 2 ]; then display="NET2 / P$preset";
                        elif [ "$page" -eq 3 ]; then display="NET3 / P$preset";
                        elif [ "$page" -eq 4 ]; then display="NET4 / P$preset";
                        elif [ "$page" -eq 5 ]; then display="RAND ${t2m_random_table[$preset]}";
                        elif [ "$page" -eq 6 ]; then display="Play MP3 (320)";
                        elif [ "$page" -eq 7 ]; then display="Play MP3 (flac)";
                        elif [ "$page" -eq 8 ]; then display="DAB Server / P$preset";
                        elif [ "$page" -eq 9 ]; then if   [ "$setup_item" -eq 0 ]; then display="Setup Radio";
                                                     elif [ "$setup_item" -eq 1 ]; then display="Setup Equalizer";
                                                     elif [ "$setup_item" -eq 2 ]; then display="Setup Backlight";
                                                     elif [ "$setup_item" -eq 3 ]; then display="Setup Database";
                                                     elif [ "$setup_item" -eq 4 ]; then display="PowerDown System"; fi; fi;
                        set_display "PAGE_PRESET=$display"; }
volume_up()           { ((volume+=$1)); if [ "$volume" -gt 100 ]; then volume=100; fi; set_volume "$volume";
                        talk_2_me "$t2m_blank $t2m_volume $t2m_up $volume $t2m_percent"; }
volume_down()         { ((volume-=$1)); if [ "$volume" -lt 0 ]; then volume=0; fi; set_volume "$volume";
                        talk_2_me "$t2m_blank $t2m_volume $t2m_down $volume $t2m_percent"; }
set_volume()          { sudo /usr/bin/amixer sset "SoftVolume" "$1"% &>/dev/null; set_display "VOL:$1%"; }
set_equalizer()       { if [ "$equal" -eq 0 ]; then equal=1; talk_2_me "$t2m_blank $t2m_equalizer_is_on"; set_display "EQ:ON";
                                                    sudo /home/jj/raspberrypizero2w/my_radio/presets jbl &>/dev/null &
                        else                        equal=0; talk_2_me "$t2m_blank $t2m_equalizer_is_off"; set_display "EQ:OFF";
                                                    sudo /home/jj/raspberrypizero2w/my_radio/presets &>/dev/null & fi; }
set_backlight()       { if [ "$backlight" -eq 0 ]; then backlight=1; set_display "BACKLIGHT=ON";
                        else                            backlight=0; set_display "BACKLIGHT=OFF"; fi; }
play_preset()         { if [ "$page" -ne 9 ]; then stop_radio; set_display "Radio play!"; fi;
                          if [ "$page" -eq 1 ]; then if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_blank $t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_one";
                                                                                /usr/bin/sleep 5; fi; play_internet "$(($preset+1))"; stop=0;
                        elif [ "$page" -eq 2 ]; then if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_blank $t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_two";
                                                                                /usr/bin/sleep 5; fi; play_internet "$(($preset+11))"; stop=0;
                        elif [ "$page" -eq 3 ]; then if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_blank $t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_three";
                                                                                /usr/bin/sleep 5; fi; play_internet "$(($preset+21))"; stop=0;
                        elif [ "$page" -eq 4 ]; then if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_blank $t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_four";
                                                                                /usr/bin/sleep 5; fi; play_internet "$(($preset+31))"; stop=0;
                        elif [ "$page" -eq 5 ]; then if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_blank $t2m_play $t2m_random ${t2m_random_table[$preset]}";
                                                                                /usr/bin/sleep 5; fi; play_random "${play_random[$preset]}"; stop=0;
                        elif [ "$page" -eq 6 ]; then if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_blank $t2m_play $t2m_random $t2m_mp3";
                                                                                /usr/bin/sleep 3; fi; play_mp3_320; stop=0;
                        elif [ "$page" -eq 7 ]; then if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_blank $t2m_play $t2m_random $t2m_mp3";
                                                                                /usr/bin/sleep 3; fi; play_mp3_flac; stop=0;
                        elif [ "$page" -eq 8 ]; then if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_blank $t2m_play $t2m_preset $preset $t2m_from $t2m_dab_server";
                                                                                /usr/bin/sleep 5; fi; play_dab "$preset"; stop=0;
                        elif [ "$page" -eq 9 ]; then if   [ "$setup_item" -eq 1 ]; then set_equalizer;
                                                     elif [ "$setup_item" -eq 2 ]; then set_backlight;
                                                     elif [ "$setup_item" -eq 3 ]; then update_database;
                                                     elif [ "$setup_item" -eq 4 ]; then power_down_system; fi; fi; }
stop_radio()          { /usr/bin/mpc stop &>/dev/null; sudo /usr/bin/killall -q vlc2; }
play_internet()       { /usr/bin/mpc play "$1" &>/dev/null; }
play_random()         { while true; do
                           cmd=$(/home/jj/raspberrypizero2w/my_radio/random/random_run.py "$1");
                           if [ "$cmd" == "Nothing Found!" ]; then talk_2_me "$cmd"; break; fi;
                           url=$(/usr/bin/echo $cmd | /usr/bin/cut -f1 -d' ');
                           /usr/bin/mpc del 41 &>/dev/null;
                           /usr/bin/mpc add "$url" &>/dev/null;
                           /usr/bin/mpc play 41 &>/dev/null;
                           ok=$(/usr/bin/echo $?); /usr/bin/sleep 1; status=$(/usr/bin/mpc status);
                           if ! /usr/bin/echo "$status" | /usr/bin/grep -q "ERROR: Failed" && [ "$ok" -eq 0 ]; then break; fi;
                        done; }
play_mp3_320()        { sudo /usr/bin/vlc2 -I dummy -q -A $AUDIO_DEVICE -LZ "/home/jj/mp3/320"  </dev/null &>/dev/null & }
play_mp3_flac()       { sudo /usr/bin/vlc2 -I dummy -q -A $AUDIO_DEVICE -LZ "/home/jj/mp3/flac" </dev/null &>/dev/null & }
random_everything()   { stop_radio; talk_2_me "$t2m_play $t2m_random ${t2m_random_table[0]}"; page=5; preset=0; display_page_preset;
                        /home/jj/raspberrypizero2w/my_radio/random/random_run.sh &>/dev/null; stop=0; }
dab_channel()         { if [ "$1" != "$old_dab_channel" ]; then /usr/bin/curl -X POST --data "$1" "$dab_server_url/channel" &>/dev/null;
                                                                /usr/bin/sleep 15; old_dab_channel="$1"; fi; }
play_dab()            { if /usr/bin/ping -c1 -W1 "$dab_server_ip" &>/dev/null; then
                        if   [ "$1" == "0" ]; then   dab_channel "7B";    dab_radio="$FRANCE_INFO";
                        elif [ "$1" == "1" ]; then   dab_channel "7B";    dab_radio="$BFM_RADIO";
                        elif [ "$1" == "2" ]; then   dab_channel "7B";    dab_radio="$EUROPE_1";
                        elif [ "$1" == "3" ]; then   dab_channel "7A";    dab_radio="$RTL";
                        elif [ "$1" == "4" ]; then   dab_channel "7A";    dab_radio="$NOSTALGIE";
                        elif [ "$1" == "5" ]; then   dab_channel "7C";    dab_radio="$MELODY";
                        elif [ "$1" == "6" ]; then   dab_channel "10C";   dab_radio="$MELODY_CH";
                        elif [ "$1" == "7" ]; then   dab_channel "10C";   dab_radio="$KISS_COLLECTOR";
                        elif [ "$1" == "8" ]; then   dab_channel "8C";    dab_radio="$SPOON_CLASSICS";
                        elif [ "$1" == "9" ]; then   dab_channel "8C";    dab_radio="$SPOON_BALLADS"; fi;
                        sudo /usr/bin/vlc2 -I dummy -q -A $AUDIO_DEVICE $dab_server_url/mp3/$dab_radio </dev/null &>/dev/null & stop=0;
                        else stop_radio; stop=1; voice=1; /usr/bin/sleep 1; talk_2_me "$t2m_dab_server $t2m_is_down"; fi; }
radio_play_stop()     { if [ "$stop" -eq 0 ]; then stop=1; stop_radio; set_display "Radio stop!"; talk_2_me "$t2m_blank $t2m_radio $t2m_stop";
                                              else stop=0;             set_display "Radio play!"; talk_2_me "$t2m_blank $t2m_radio $t2m_play";
                          if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] ||
                             [ "$page" -eq 4 ] || [ "$page" -eq 5 ]; then /usr/bin/sleep 2; /usr/bin/mpc play &>/dev/null;
                        elif [ "$page" -eq 6 ];                      then /usr/bin/sleep 2; play_mp3_320;
                        elif [ "$page" -eq 7 ];                      then /usr/bin/sleep 2; play_mp3_flac;
                        elif [ "$page" -eq 8 ];                      then /usr/bin/sleep 2; play_dab "$preset"; fi; fi; }
play_next()           { /usr/bin/mpc next &>/dev/null; }
play_previous()       { /usr/bin/mpc prev &>/dev/null; }
update_database()     { stop_radio; stop=1; voice=1;
                        for _ in {1..3}; do sudo /usr/bin/vlc2 -I dummy -q -A bluealsa --gain=0.8 --play-and-exit $DIVE </dev/null &>/dev/null; done;
                        talk_2_me "$t2m_blank $t2m_update_db"; /home/jj/raspberrypizero2w/my_radio/random/random_set.sh &>/dev/null & }
power_down_system()   { stop_radio; stop=1; voice=1;
                        for _ in {1..3}; do sudo /usr/bin/vlc2 -I dummy -q -A bluealsa --gain=0.8 --play-and-exit $DIVE </dev/null &>/dev/null; done;
                        talk_2_me "$t2m_blank $t2m_pds"; eval "$dab_server_shutdown"; /usr/bin/sleep 5; sudo /usr/sbin/shutdown now; }
say_time()            { h=$(date +'%H'); m=$(date +'%M'); s=$(date +'%S'); talk_2_me "$t2m_blank $t2m_time $h $t2m_hour $m $t2m_minute $s $t2m_second"; }
set_display()         { /usr/bin/echo -e "$1\n" > "$MY_RADIO_OUTPUT_PIPE"; }

initialization

while true; do
    sudo /usr/bin/killall -q thd;
    /usr/sbin/thd --dump $INPUT_DEVICES | /usr/bin/grep "EV_KEY" --line-buffered > "$MY_RADIO_INPUT_PIPE" &
    while read line; do
        ### echo $line;
        case $line in
            ("remote_connected")        break;;
            ("GPIO=volume_up")          voice=0; volume_up   "$volume_step"; voice=1;;
            ("GPIO=volume_down")        voice=0; volume_down "$volume_step"; voice=1;;
            ("GPIO=volume_switch")      if [ "$stop" -eq 0 ]; then radio_play_stop; else play_preset; fi;;
            ("GPIO=button1")            page_up;;
            ("GPIO=button2")            preset_up;;
            ("GPIO=button3")            if [ "$stop" -eq 0 ]; then play_next;       else page_down;   fi;;
            ("GPIO=button4")            if [ "$stop" -eq 0 ]; then play_previous;   else preset_down; fi;;
            ($REMOTE_KEY_VOLUMEUP)      volume_up   "$(($volume_step*2))";;
            ($REMOTE_KEY_VOLUMEDOWN)    volume_down "$(($volume_step*2))";;
            ($REMOTE_KEY_UP)            page_up;;
            ($REMOTE_KEY_DOWN)          page_down;;
            ($REMOTE_KEY_LEFT)          preset_down;;
            ($REMOTE_KEY_RIGHT)         preset_up;;
            ($REMOTE_KEY_SELECT)        play_preset;;
            ($REMOTE_KEY_APPSELECT)     set_equalizer;;
            ($REMOTE_KEY_BACK)          radio_play_stop;;
            ($REMOTE_KEY_HOMEPAGE)      random_everything;;
            ($REMOTE_KEY_VIDEO)         if [ "$stop" -eq 0 ]; then play_previous; else say_time; fi;;
            ($REMOTE_KEY_YELLOW)        if [ "$stop" -eq 0 ]; then play_next;     else say_time; fi;;
        esac
    done < "$MY_RADIO_INPUT_PIPE"
done
