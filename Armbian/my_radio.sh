#!/bin/bash

####################################################
#                                                  #
#                   my_radio.sh                    #
#                                                  #
#--------------------------------------------------#
#                                                  #
#           Android TV Boxes - Armbian             #
#                                                  #
#        Internet Radio On A Tight Budget!         #
#                                                  #
#--------------------------------------------------#
#                                                  #
#               JJR / Wed 10 Mar 2021              #
#                                                  #
####################################################

flite='/tmp/flite.wav'; remote='/root/Strong_SRT_2023.toml'; device='/dev/input/event*';
page=3; preset=0; stop=0; volume=25; volume_step=1; equal=1;

t2m_fm_radio="fm radio"; t2m_dab_plus_radio="dab plus radio"; t2m_internet_radio_page_one="internet radio page one";
t2m_internet_radio_page_two="internet radio page two"; t2m_internet_radio_page_three="internet radio page three";
t2m_internet_radio_page_four="internet radio page four"; t2m_random_internet_radio="random internet radio"; t2m_mp3_player="mp3 player";
t2m_page="page"; t2m_preset="preset"; t2m_random="random"; t2m_mp3="mp3"; t2m_radio="radio"; t2m_play="play"; t2m_stop="stop"; t2m_volume="volume";
t2m_down="down"; t2m_up="up"; t2m_percent="percent"; t2m_equalizer_is_on="equalizer is on"; t2m_equalizer_is_off="equalizer is off"; t2m_from="from";
t2m_pds="power down system"; t2m_time="the time is. "; t2m_hour="hour. "; t2m_minute="minute. "; t2m_second="second. ";
t2m_random_table=( "everything" "talk" "pop" "alternative" "country" "oldies" "60s" "70s" "80s" "90s" );
play_random=( "" "talk" "pop" "alternative" "country" "oldies" "60" "70" "80" "90" );

fm=( "-c freq=98100000,srate=300000"
     "-c freq=107600000,srate=300000"
     "-c freq=94400000,srate=300000"
     "-c freq=93000000,srate=300000"
     "-c freq=104000000,srate=300000"
     "-c freq=102100000,srate=300000"
     "-c freq=103300000,srate=300000"
     "-c freq=107200000,srate=300000"
     "-c freq=91200000,srate=300000"
     "-c freq=96200000,srate=300000" );

dab=( "-C 8C  -P SPOON RADIO"
      "-C 8C  -P PIRATES RADIO"
      "-C 8C  -P Lifestyle 74"
      "-C 8C  -P WRS"
      "-C 8C  -P 20 Minutes Radio"
      "-C 12A -P RTS-1ERE"
      "-C 12A -P OPTION MUSIQUE"
      "-C 12A -P Swiss Pop"
      "-C 12A -P SuisseClassique"
      "-C 12A -P SRF Musikwelle" );

remote_key_power='*EV_KEY	KEY_POWER	1*'
remote_key_audio='*EV_KEY	KEY_AUDIO	1*'
remote_key_home='*EV_KEY	KEY_HOMEPAGE	1*'
remote_key_up='*EV_KEY	KEY_UP	1*'
remote_key_down='*EV_KEY	KEY_DOWN	1*'
remote_key_left='*EV_KEY	KEY_LEFT	1*'
remote_key_right='*EV_KEY	KEY_RIGHT	1*'
remote_key_ok='*EV_KEY	KEY_OK	1*'
remote_key_vol_down_slow='*EV_KEY	KEY_VOLUMEDOWN	1*'
remote_key_vol_down_fast='*EV_KEY	KEY_VOLUMEDOWN	2*'
remote_key_vol_up_slow='*EV_KEY	KEY_VOLUMEUP	1*'
remote_key_vol_up_fast='*EV_KEY	KEY_VOLUMEUP	2*'
remote_key_previous='*EV_KEY	KEY_PREVIOUS	1*'
remote_key_next='*EV_KEY	KEY_NEXT	1*'
remote_key_play='*EV_KEY	KEY_PLAYPAUSE	1*'

talk_2_me()          { if [ "$stop" -eq 1 ]; then
                       /usr/bin/flite -t "$1" -o $flite -voice slt --setf duration_stretch=.9 --setf int_f0_target_mean=237 &>/dev/null &&
                       /usr/bin/play -qV0 -v 1.5 $flite reverb &>/dev/null; fi; }
page_up()            { ((page+=1)); if [ "$page" -eq 9 ]; then page=1; fi; say_page "$page"; }
page_down()          { ((page-=1)); if [ "$page" -eq 0 ]; then page=8; fi; say_page "$page"; }
say_page()           { if [ "$1" -eq 1 ]; then talk_2_me "$t2m_fm_radio";
                     elif [ "$1" -eq 2 ]; then talk_2_me "$t2m_dab_plus_radio";
                     elif [ "$1" -eq 3 ]; then talk_2_me "$t2m_internet_radio_page_one";
                     elif [ "$1" -eq 4 ]; then talk_2_me "$t2m_internet_radio_page_two";
                     elif [ "$1" -eq 5 ]; then talk_2_me "$t2m_internet_radio_page_three";
                     elif [ "$1" -eq 6 ]; then talk_2_me "$t2m_internet_radio_page_four";
                     elif [ "$1" -eq 7 ]; then talk_2_me "$t2m_random_internet_radio";
                     elif [ "$1" -eq 8 ]; then talk_2_me "$t2m_mp3_player"; fi; }
preset_up()          { if [ "$page" -ne 8 ]; then ((preset+=1)); if [ "$preset" -eq 10 ]; then preset=0; fi; say_preset "$preset"; fi; }
preset_down()        { if [ "$page" -ne 8 ]; then ((preset-=1)); if [ "$preset" -lt 0 ]; then preset=9; fi; say_preset "$preset"; fi; }
say_preset()         { if [ "$page" -eq 1 ] || [ "$page" -eq 2 ] || [ "$page" -eq 3 ] || [ "$page" -eq 4 ] || [ "$page" -eq 5 ] || [ "$page" -eq 6 ];
                       then talk_2_me "$t2m_preset $1"; elif [ "$page" -eq 7 ]; then talk_2_me "$t2m_random ${t2m_random_table[$1]}"; fi; }
volume_up()          { ((volume+=$1)); if [ "$volume" -gt 100 ]; then volume=100; fi; set_volume "$volume"; talk_2_me "$t2m_volume $t2m_up $volume $t2m_percent"; }
volume_down()        { ((volume-=$1)); if [ "$volume" -lt 0 ]; then volume=0; fi; set_volume "$volume"; talk_2_me "$t2m_volume $t2m_down $volume $t2m_percent"; }
set_volume()         { /usr/bin/amixer sset "Speaker" "$1"% &>/dev/null; }
set_equalizer()      { if [ "$equal" -eq 0 ]; then equal=1; talk_2_me "$t2m_equalizer_is_on"; /root/presets jj &>/dev/null &
                       else equal=0; talk_2_me "$t2m_equalizer_is_off"; /root/presets &>/dev/null & fi; }
play_preset()        { stop_radio; if [ "$stop" -eq 0 ]; then /usr/bin/sleep 1; fi;
                       if [ "$page" -eq 1 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_fm_radio"; play_fm "$preset";
                     elif [ "$page" -eq 2 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_dab_plus_radio"; play_dab "$preset";
                     elif [ "$page" -eq 3 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_one"; play_internet "$(($preset+1))";
                     elif [ "$page" -eq 4 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_two"; play_internet "$(($preset+11))";
                     elif [ "$page" -eq 5 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_three"; play_internet "$(($preset+21))";
                     elif [ "$page" -eq 6 ]; then talk_2_me "$t2m_play $t2m_preset $preset $t2m_from $t2m_internet_radio_page_four"; play_internet "$(($preset+31))";
                     elif [ "$page" -eq 7 ]; then talk_2_me "$t2m_play $t2m_random ${t2m_random_table[$preset]}"; play_random "${play_random[$preset]}";
                     elif [ "$page" -eq 8 ]; then talk_2_me "$t2m_play $t2m_random $t2m_mp3"; play_mp3; fi; stop=0; }
stop_radio()         { /usr/bin/pkill softfm; /usr/bin/pkill dab-rtlsdr-3; /usr/bin/pkill vlc2; /usr/bin/pkill aplay; /usr/bin/mpc stop &>/dev/null; }
play_fm()            { /usr/local/bin/softfm -t rtlsdr ${fm[$1]} -r 48000 -b 2 -R - | /usr/bin/aplay -D equal -r 48000 -f S16_LE -t raw -c 2 & }
play_dab()           { /usr/local/bin/dab-rtlsdr-3 -M 1 -B "BAND III" ${dab[$1]} -G 30 -Q | /usr/bin/aplay -D equal -r 48000 -f S16_LE -t raw -c 2 & }
play_internet()      { /usr/bin/mpc play "$1" &>/dev/null; }
play_random()        { while true; do
                          cmd=$(/root/random/random_run.py "$1");
                          if [ "$cmd" == "Nothing Found!" ]; then talk_2_me "$cmd"; break; fi;
                          url=$(echo $cmd | cut -f1 -d' ');
                          /usr/bin/mpc del 41 &>/dev/null;
                          /usr/bin/mpc add "$url" &>/dev/null;
                          /usr/bin/mpc play 41 &>/dev/null;
                          ok=$(echo $?); /usr/bin/sleep 1; status=$(/usr/bin/mpc status);
                          if ! echo "$status" | grep -q "ERROR: Failed" && [ "$ok" -eq 0 ]; then break; fi;
                       done; }
play_mp3()           { /usr/bin/vlc2 -I dummy -q --alsa-audio-device "equal" -LZ "/root/mp3" </dev/null &>/dev/null & }
random_everything()  { stop_radio; talk_2_me "$t2m_play $t2m_random ${t2m_random_table[0]}"; /root/random/random_run.sh &>/dev/null; stop=0; }
radio_play_stop()    { if [ "$stop" -eq 0 ]; then stop=1; stop_radio; talk_2_me "$t2m_radio $t2m_stop"; else talk_2_me "$t2m_radio $t2m_play"; stop=0;
                       if   [ "$page" -eq 1 ]; then play_fm "$preset";
                       elif [ "$page" -eq 2 ]; then play_dab "$preset";
                       elif [ "$page" -eq 3 ] || [ "$page" -eq 4 ] || [ "$page" -eq 5 ] || [ "$page" -eq 6 ] || [ "$page" -eq 7 ]; then /usr/bin/mpc play &>/dev/null;
                       elif [ "$page" -eq 8 ]; then play_mp3; fi; fi; }
play_next()          { /usr/bin/mpc next &>/dev/null; }
play_previous()      { /usr/bin/mpc prev &>/dev/null; }
power_down_system()  { if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_pds"; /usr/sbin/shutdown now; fi; }
say_time()           { h=$(date +'%H'); m=$(date +'%M'); s=$(date +'%S'); talk_2_me "$t2m_time $h $t2m_hour $m $t2m_minute $s $t2m_second"; }

echo "my_radio.sh is starting..... `date`" > /dev/kmsg
/usr/bin/sleep 10
stop_radio
set_volume "$volume"
set_equalizer
/usr/bin/mpc clear &>/dev/null
cat /root/playlist.db | /usr/bin/mpc add &>/dev/null
/root/random/random_set.sh &
ir-keytable -c -w $remote &>/dev/null
play_preset

thd --dump $device | while read line; do
   case $line in
      ($remote_key_power)         power_down_system;;
      ($remote_key_audio)         set_equalizer;;
      ($remote_key_home)          random_everything;;
      ($remote_key_up)            page_up;;
      ($remote_key_down)          page_down;;
      ($remote_key_left)          preset_down;;
      ($remote_key_right)         preset_up;;
      ($remote_key_ok)            play_preset;;
      ($remote_key_vol_down_slow) volume_down "$volume_step";;
      ($remote_key_vol_down_fast) volume_down "$(($volume_step*5))";;
      ($remote_key_vol_up_slow)   volume_up "$volume_step";;
      ($remote_key_vol_up_fast)   volume_up "$(($volume_step*5))";;
      ($remote_key_previous)      if [ "$stop" -eq 0 ]; then play_previous; else say_time; fi;;
      ($remote_key_next)          if [ "$stop" -eq 0 ]; then play_next; else say_time; fi;;
      ($remote_key_play)          radio_play_stop;;
   esac
done
