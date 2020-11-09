#!/bin/sh

####################################################
# OpenWrtRadio - Internet Radio On A Tight Budget! #
####################################################
#                                                  #
#                     input.sh                     #
#                                                  #
#--------------------------------------------------#
# Handles the wired keypad, the wireless mouse and #
# the bluetooth gamepad.                           #
#--------------------------------------------------#
#                                                  #
#               JJR / Sun Nov 8 2020               #
#                                                  #
####################################################

my_pipe='/tmp/ubi1/my_pipe'; rm -f $my_pipe; mkfifo $my_pipe;
device='/dev/input/event*'; page=1; preset=0; stop=0; gamepad=0;

t2m_page="page"; t2m_preset="preset"; t2m_play="play"; t2m_next="next"; t2m_previous="previous"; t2m_random="random"; t2m_radio="radio";
t2m_stopped="stopped"; t2m_volume="volume"; t2m_down="down"; t2m_up="up"; t2m_minus="minus"; t2m_plus="plus"; t2m_from="from";
t2m_time="the time is..."; t2m_hour="hour..."; t2m_minute="minute..."; t2m_second="second."; t2m_pds="power down system";
t2m_random_0="everything"; t2m_random_1="talk"; t2m_random_2="pop"; t2m_random_3="alternative"; t2m_random_4="country"; t2m_random_5="oldies";
t2m_random_6="60s"; t2m_random_7="70s"; t2m_random_8="80s"; t2m_random_9="90s";

play_random_0=""; play_random_1="talk"; play_random_2="pop"; play_random_3="alternative"; play_random_4="country"; play_random_5="oldies";
play_random_6="60"; play_random_7="70"; play_random_8="80"; play_random_9="90";

key_enter='*EV_KEY	KEY_KPENTER	1*'
key_numlock='*EV_KEY	KEY_NUMLOCK	1*'
key_minus='*EV_KEY	KEY_KPMINUS	1*'
key_minus_2='*EV_KEY	KEY_KPMINUS	2*'
key_plus='*EV_KEY	KEY_KPPLUS	1*'
key_plus_2='*EV_KEY	KEY_KPPLUS	2*'
key_dot='*EV_KEY	KEY_KPDOT	1*'
key_slash='*EV_KEY	KEY_KPSLASH	1*'
key_asterisk='*EV_KEY	KEY_KPASTERISK	1*'
key_back='*EV_KEY	KEY_BACKSPACE	1*'
key_equal='*EV_KEY	KEY_EQUAL	1*'
key_tab='*EV_KEY	KEY_TAB	1*'
key_0='*EV_KEY	KEY_KP0	1*'
key_1='*EV_KEY	KEY_KP1	1*'
key_2='*EV_KEY	KEY_KP2	1*'
key_3='*EV_KEY	KEY_KP3	1*'
key_4='*EV_KEY	KEY_KP4	1*'
key_5='*EV_KEY	KEY_KP5	1*'
key_6='*EV_KEY	KEY_KP6	1*'
key_7='*EV_KEY	KEY_KP7	1*'
key_8='*EV_KEY	KEY_KP8	1*'
key_9='*EV_KEY	KEY_KP9	1*'

mouse_button_left='*EV_KEY	BTN_LEFT	1*'
mouse_button_right='*EV_KEY	BTN_RIGHT	1*'
mouse_button_middle='*EV_KEY	BTN_MIDDLE	1*'
mouse_wheel_up='*EV_REL	REL_WHEEL	1*'
mouse_wheel_down='*EV_REL	REL_WHEEL	-1*'

gamepad_button_tl='*EV_KEY	BTN_TL	1*'
gamepad_button_tr='*EV_KEY	BTN_TR	1*'
gamepad_button_a='*EV_KEY	BTN_GAMEPAD	1*'
gamepad_button_b='*EV_KEY	BTN_B	1*'
gamepad_button_x='*EV_KEY	BTN_NORTH	1*'
gamepad_button_y='*EV_KEY	BTN_WEST	1*'
gamepad_button_start='*EV_KEY	BTN_START	1*'
gamepad_button_select='*EV_KEY	BTN_SELECT	1*'
gamepad_button_up='*EV_ABS	ABS_Y	0*'
gamepad_button_down='*EV_ABS	ABS_Y	255*'
gamepad_button_left='*EV_ABS	ABS_X	0*'
gamepad_button_right='*EV_ABS	ABS_X	255*'

talk_2_me ()         { if [ "$stop" -eq 1 ]; then espeak --stdout "$1" | aplay &>/dev/null; fi; }
page_up ()           { page=$(($page+1)); if [ "$page" -eq 6 ]; then page=1; fi; say_page; }
page_down ()         { page=$(($page-1)); if [ "$page" -eq 0 ]; then page=5; fi; say_page; }
say_page ()          { if [ "$page" -ne 5 ]; then talk_2_me "$t2m_page $page"; else talk_2_me "$t2m_random $t2m_page"; fi; }
random_everything () { talk_2_me "$t2m_random $t2m_play"; /tmp/ubi1/random/random_run.sh; stop=0; }
power_down_system () { if [ "$stop" -eq 1 ]; then talk_2_me "$t2m_pds"; poweroff; fi; }
volume_down ()       { /usr/bin/amixer sset "Speaker" "$1"%- &>/dev/null; talk_2_me "$t2m_volume $t2m_down $t2m_minus $1"; }
volume_up ()         { /usr/bin/amixer sset "Speaker" "$1"%+ &>/dev/null; talk_2_me "$t2m_volume $t2m_up $t2m_plus $1"; }
radio_play_stop ()   { if [ "$stop" -eq 0 ]; then stop=1; /usr/bin/mpc stop &>/dev/null; talk_2_me "$t2m_radio $t2m_stopped";
                       else talk_2_me "$t2m_radio $t2m_play"; stop=0; /usr/bin/mpc play &>/dev/null; fi; }
play_next ()         { talk_2_me "$t2m_play $t2m_next"; /usr/bin/mpc next &>/dev/null; stop=0; }
play_previous ()     { talk_2_me "$t2m_play $t2m_previous"; /usr/bin/mpc prev &>/dev/null; stop=0; }
play_preset ()       { if [ "$page" -ne 5 ]; then talk_2_me "$t2m_play $t2m_preset $1 $t2m_from $t2m_page $page";
                       /usr/bin/mpc play "$((($1+(($page-1))*10)+1))" &>/dev/null; else random_by_genre "$1"; fi; stop=0; }
preset_up ()         { preset=$(($preset+1)); if [ "$preset" -eq 10 ]; then preset=0; fi; say_preset; }
preset_down ()       { preset=$(($preset-1)); if [ "$preset" -lt 0 ]; then preset=9; fi; say_preset; }
say_preset ()        { if [ "$page" -ne 5 ]; then talk_2_me "$t2m_preset $preset"; else what_say_genre "$preset"; talk_2_me "$t2m_random $say"; fi; }
what_say_genre ()    { say=""; genre="";
                       if   [ "$1" -eq 0 ]; then say=$t2m_random_0; genre=$play_random_0;
                       elif [ "$1" -eq 1 ]; then say=$t2m_random_1; genre=$play_random_1;
                       elif [ "$1" -eq 2 ]; then say=$t2m_random_2; genre=$play_random_2;
                       elif [ "$1" -eq 3 ]; then say=$t2m_random_3; genre=$play_random_3;
                       elif [ "$1" -eq 4 ]; then say=$t2m_random_4; genre=$play_random_4;
                       elif [ "$1" -eq 5 ]; then say=$t2m_random_5; genre=$play_random_5;
                       elif [ "$1" -eq 6 ]; then say=$t2m_random_6; genre=$play_random_6;
                       elif [ "$1" -eq 7 ]; then say=$t2m_random_7; genre=$play_random_7;
                       elif [ "$1" -eq 8 ]; then say=$t2m_random_8; genre=$play_random_8;
                       elif [ "$1" -eq 9 ]; then say=$t2m_random_9; genre=$play_random_9; fi; }
random_by_genre ()   { what_say_genre "$1"; talk_2_me "$t2m_play $t2m_random $say";
                       while true; do
                          cmd=$(/tmp/ubi1/random/random_run.py "$genre");
                          if [ "$cmd" == "Nothing Found!" ]; then talk_2_me "$cmd"; break; fi;
                          url=$(echo $cmd | cut -f1 -d' ');
                          /usr/bin/mpc del 41 &>/dev/null;
                          /usr/bin/mpc add "$url" &>/dev/null;
                          /usr/bin/mpc play 41 &>/dev/null;
                          ok=$(echo $?); sleep 1; status=$(/usr/bin/mpc status);
                          if ! echo "$status" | grep -q "ERROR: Failed" && [ "$ok" -eq 0 ]; then echo "$url"; break; fi;
                       done; }
say_time ()          { h=$(date +'%H'); m=$(date +'%M'); s=$(date +'%S'); talk_2_me "$t2m_time $h $t2m_hour $m $t2m_minute $s $t2m_second"; }

while true; do
   killall -q thd
   thd --dump $device > $my_pipe &
   while read line; do
      case $line in
         ($key_enter)             page_up;;
         ($key_tab)               page_down;;
         ($key_back)              random_everything;;
         ($key_equal)             power_down_system;;
         ($key_minus)             volume_down "1";;
         ($key_minus_2)           volume_down "2";;
         ($key_plus)              volume_up "1";;
         ($key_plus_2)            volume_up "2";;
         ($key_dot)               radio_play_stop;;
         ($key_slash)             play_next;;
         ($key_asterisk)          play_previous;;
         ($key_0)                 play_preset "0";;
         ($key_1)                 play_preset "1";;
         ($key_2)                 play_preset "2";;
         ($key_3)                 play_preset "3";;
         ($key_4)                 play_preset "4";;
         ($key_5)                 play_preset "5";;
         ($key_6)                 play_preset "6";;
         ($key_7)                 play_preset "7";;
         ($key_8)                 play_preset "8";;
         ($key_9)                 play_preset "9";;
         ($mouse_button_left)     play_next;;
         ($mouse_button_right)    play_previous;;
         ($mouse_button_middle)   random_everything;;
         ($mouse_wheel_up)        volume_up "1";;
         ($mouse_wheel_down)      volume_down "1";;
         ($gamepad_button_tr)     volume_up "3";;
         ($gamepad_button_tl)     volume_down "3";;
         ($gamepad_button_a)      radio_play_stop;;
         ($gamepad_button_b)      play_preset "$preset";;
         ($gamepad_button_x)      play_previous;;
         ($gamepad_button_y)      play_next;;
         ($gamepad_button_up)     page_up;;
         ($gamepad_button_down)   page_down;;
         ($gamepad_button_right)  preset_up;;
         ($gamepad_button_left)   preset_down;;
         ($gamepad_button_select) random_everything;;
         ($gamepad_button_start)  say_time;;
      esac
      bluetooth=$(/usr/bin/hcitool con)
      if echo "$bluetooth" | grep -q "E4:17:D8:1C:09:6A"; then
         if [ "$gamepad" -eq 0 ]; then gamepad=1; break; fi
      else
         if [ "$gamepad" -eq 1 ]; then gamepad=0; break; fi
      fi
   done < $my_pipe
done
