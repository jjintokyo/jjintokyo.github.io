#!/bin/sh

device='/dev/input/event*'; page=0; stop=0;

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

talk_2_me () { if [ "$stop" -eq 1 ]; then espeak --stdout "$1" | aplay; fi; }

thd --dump $device | while read line; do
   case $line in
      ($key_enter)           page=$(($page+1)); if [ "$page" -eq 4 ]; then page=0; fi; p=$(($page+1)); talk_2_me "page $p";;
      ($key_tab)             page=$(($page-1)); if [ "$page" -lt 0 ]; then page=3; fi; p=$(($page+1)); talk_2_me "page $p";;
      ($key_back)            talk_2_me "random play"; /tmp/ubi1/random/random_run.sh; stop=0;;
      ($key_equal)           if [ "$stop" -eq 1 ]; then talk_2_me "power down system"; poweroff; fi;;
      ($key_minus)           /usr/bin/amixer sset 'Speaker' 1%-; talk_2_me "volume down";;
      ($key_minus_2)         /usr/bin/amixer sset 'Speaker' 1%-; talk_2_me "volume down";;
      ($key_plus)            /usr/bin/amixer sset 'Speaker' 1%+; talk_2_me "volume up";;
      ($key_plus_2)          /usr/bin/amixer sset 'Speaker' 1%+; talk_2_me "volume up";;
      ($key_dot)             if [ "$stop" -eq 0 ]; then stop=1; /usr/bin/mpc stop; talk_2_me "radio stopped";
                             else talk_2_me "radio play"; stop=0; /usr/bin/mpc play; fi;;
      ($key_slash)           talk_2_me "play next"; /usr/bin/mpc next; stop=0;;
      ($key_asterisk)        talk_2_me "play previous"; /usr/bin/mpc prev; stop=0;;
      ($key_0)               talk_2_me "play preset 0"; /usr/bin/mpc play "$(((0+$page*10)+1))"; stop=0;;
      ($key_1)               talk_2_me "play preset 1"; /usr/bin/mpc play "$(((1+$page*10)+1))"; stop=0;;
      ($key_2)               talk_2_me "play preset 2"; /usr/bin/mpc play "$(((2+$page*10)+1))"; stop=0;;
      ($key_3)               talk_2_me "play preset 3"; /usr/bin/mpc play "$(((3+$page*10)+1))"; stop=0;;
      ($key_4)               talk_2_me "play preset 4"; /usr/bin/mpc play "$(((4+$page*10)+1))"; stop=0;;
      ($key_5)               talk_2_me "play preset 5"; /usr/bin/mpc play "$(((5+$page*10)+1))"; stop=0;;
      ($key_6)               talk_2_me "play preset 6"; /usr/bin/mpc play "$(((6+$page*10)+1))"; stop=0;;
      ($key_7)               talk_2_me "play preset 7"; /usr/bin/mpc play "$(((7+$page*10)+1))"; stop=0;;
      ($key_8)               talk_2_me "play preset 8"; /usr/bin/mpc play "$(((8+$page*10)+1))"; stop=0;;
      ($key_9)               talk_2_me "play preset 9"; /usr/bin/mpc play "$(((9+$page*10)+1))"; stop=0;;
      ($mouse_button_left)   /usr/bin/mpc next; stop=0;;
      ($mouse_button_right)  /usr/bin/mpc prev; stop=0;;
      ($mouse_button_middle) /tmp/ubi1/random/random_run.sh; stop=0;;
      ($mouse_wheel_up)      /usr/bin/amixer sset 'Speaker' 1%+;;
      ($mouse_wheel_down)    /usr/bin/amixer sset 'Speaker' 1%-;;
   esac
done
