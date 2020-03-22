#!/bin/bash

######################################
#                                    #
#              radio.sh              #
#                                    #
######################################
# RADIO / JJR / FEBRUARY 2020        #
#------------------------------------#
# PLAY                               #
#------------------------------------#
# |--> receive commands from arduino #
######################################

stty -F /dev/ttyUSB0 9600 raw -echo -echoe -echok -echonl -echoctl -echoprt -noflsh

IFS=$'\n' read -d '' -r -a lines < /home/pi/temp/playlist.db
lines[40]=$(cat /home/pi/temp/special.db)

preset=0; mute=0; volume=0; equal=0; adjust=0;
mode=0 # (1)=FM RADIO, (2)=DAB+ RADIO,
       # (3)=INTERNET RADIO #1, (4)=INTERNET RADIO #2, (5)=INTERNET RADIO #3, (6)=INTERNET RADIO #4,
       # (7)=RANDOM INTERNET RADIO, (8)=MP3 PLAYER.

shout0="the radio is on"; shout1="fm radio"; shout2="dab+ radio"; shout3="internet radio number one";
shout4="internet radio number two"; shout5="internet radio number three"; shout6="internet radio number four";
shout7="random internet radio"; shout8="mp3 player"; shout11="volume up"; shout12="volume down"; shout13="percent";
shout14="mute"; shout15="unmute"; shout16="volume is"; shout17="random mp3"; shout18="equalizer is on";
shout19="equalizer is off"; shout88="unknown key pressed"; shout99="shutting down the radio";

ps="preset"; p=( "zero" "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" );
rd="random"; r=( "everything" "talk" "classical" "alternative" "country" "scanner" "60s" "70s" "80s" "90s" );
random=( "" "talk" "classical" "alternative" "country" "scanner" "60s" "70s" "80s" "90s" );

fm=( "-c freq=98100000,srate=300000"
     "-c freq=107600000,srate=300000 -M"
     "-c freq=94400000,srate=300000 -M"
     "-c freq=93000000,srate=300000"
     "-c freq=104000000,srate=300000"
     "-c freq=102100000,srate=300000"
     "-c freq=103300000,srate=300000 -M"
     "-c freq=107200000,srate=300000"
     "-c freq=91200000,srate=300000 -M"
     "-c freq=96200000,srate=300000 -M" );

fm_desc=( "Nostalgie"
          "RTL"
          "France Inter"
          "La Radio Plus"
          "Sud Radio"
          "Radio Classique"
          "LFM"
          "One FM"
          "RTS - La Premiere"
          "RTS - Espace 2" );

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

dab_desc=( "SPOON RADIO"
           "PIRATES RADIO"
           "Lifestyle 74"
           "WRS"
           "20 Minutes Radio"
           "RTS-1ERE"
           "OPTION MUSIQUE"
           "Swiss Pop"
           "Suisse Classique"
           "SRF Musikwelle" );

SoundOn()      { amixer cset numid=2 on &>/dev/null; }
SoundOff()     { amixer cset numid=2 off &>/dev/null; }
SetVolume()    { amixer cset numid=1 "$1"% &>/dev/null; }
SayMode()      { if [ "$1" -eq 1 ]; then shout="$shout1"; elif [ "$1" -eq 2 ]; then shout="$shout2"; elif [ "$1" -eq 3 ]; then shout="$shout3"; adjust=0; elif [ "$1" -eq 4 ]; then shout="$shout4"; adjust=10; elif [ "$1" -eq 5 ]; then shout="$shout5"; adjust=20; elif [ "$1" -eq 6 ]; then shout="$shout6"; adjust=30; elif [ "$1" -eq 7 ]; then shout="$shout7"; elif [ "$1" -eq 8 ]; then shout="$shout8"; fi; }
Talk2Me()      { flite -t "$1" -voice slt --setf duration_stretch=.9 --setf int_f0_target_mean=237 &>/dev/null; }
KillEmAll()    { sudo pkill vlc; sudo pkill softfm; sudo pkill dab-rtlsdr; }
EqualizerOn()  { /home/pi/presets jj &>/dev/null & }
EqualizerOff() { /home/pi/presets &>/dev/null & }
StopMPC()      { /usr/bin/mpc stop &>/dev/null; }
InitIcecast()  { /home/pi/icecast_play/init.sh &>/dev/null & }
PlayFM()       { softfm -t rtlsdr ${fm[$1]} -Pequal </dev/null &>/dev/null & }
PlayDAB()      { dab-rtlsdr-2 -M 1 -B "BAND III" ${dab[$1]} -Q -G 70 -A equal </dev/null &>/dev/null & }
PlayINTERNET() { url="${lines[(($1 + $adjust))]}"; vlc -I dummy --alsa-audio-device equal $url </dev/null &>/dev/null & }
PlayRANDOM()   { url=$(/home/pi/icecast_play/icecast_http.py ${random[$1]}); vlc -I dummy --alsa-audio-device equal $url </dev/null &>/dev/null & }
PlayMP3()      { vlc -I dummy --alsa-audio-device equal -LZ "/home/pi/mp3" </dev/null &>/dev/null & }
SaveURL()      { echo $url | sudo tee /home/pi/temp/url > /dev/null; }
SendData()     { echo "$1" > /dev/ttyUSB0; }

InitIcecast;

cat -v /dev/ttyUSB0 | while read data; do
  operation="${data%=*}"
  parameter="${data#*=}"
  case "${operation}" in
    $"FFFFFFFF^M");;
    $"FFFFFFFF");;
    $"init_mode")      value="$((parameter * 1))"; mode="$value"; KillEmAll; StopMPC; SayMode "$mode";;
    $"init_volume")    value="$((parameter * 1))"; volume="$value"; SoundOn; SetVolume "$volume"; Talk2Me "$shout0";;
    $"init_equalizer") value="$((parameter * 1))"; equal="$value"; if [ "$equal" -eq 1 ]; then EqualizerOn; else EqualizerOff; fi;;
    $"init_mute")      value="$((parameter * 1))"; mute="$value"; if [ "$mute" -eq 1 ]; then SoundOff; else SoundOn; fi;;
    $"volume_up")      value="$((parameter * 1))"; volume="$value"; SetVolume "$volume"; Talk2Me "$shout11 $volume $shout13";;
    $"volume_down")    value="$((parameter * 1))"; volume="$value"; SetVolume "$volume"; Talk2Me "$shout12 $volume $shout13";;
    $"change_mode")    value="$((parameter * 1))"; mode="$value"; KillEmAll; StopMPC; SayMode "$mode"; Talk2Me "$shout";;
    $"set_preset")     value="$((parameter * 1))"; preset="$value"; KillEmAll; StopMPC;
                       if   [ "$mode" -eq 1 ]; then Talk2Me "$ps ${p[$preset]}"; PlayFM "$preset";
                       elif [ "$mode" -eq 2 ]; then Talk2Me "$ps ${p[$preset]}"; PlayDAB "$preset";
                       elif [ "$mode" -eq 3 ] || [ "$mode" -eq 4 ] || [ "$mode" -eq 5 ] || [ "$mode" -eq 6 ];
                                               then Talk2Me "$ps ${p[$preset]}"; PlayINTERNET "$preset"; SaveURL;
                       elif [ "$mode" -eq 7 ]; then Talk2Me "$rd ${r[$preset]}"; PlayRANDOM "$preset"; SaveURL;
                       elif [ "$mode" -eq 8 ]; then Talk2Me "$shout17";          PlayMP3; fi;;
    $"set_mute")       value="$((parameter * 1))"; mute="$value";
                       if [ "$mute" -eq 1 ]; then SayMode "$mode"; Talk2Me "$shout14 $shout"; SoundOff;
                       else SoundOn; SayMode "$mode"; Talk2Me "$shout15 $shout $shout16 $volume $shout13"; fi;;
    $"set_equalizer")  value="$((parameter * 1))"; equal="$value";
                       if [ "$equal" -eq 1 ]; then Talk2Me "$shout18"; EqualizerOn;
                       else Talk2Me "$shout19"; EqualizerOff; fi;;
    $"shutdown")       KillEmAll; StopMPC; sleep 0.5; SoundOn; Talk2Me "$shout99"; SoundOff; sudo shutdown now;;
    $"random")         PlayRANDOM "0"; SaveURL;;
    $"special")        PlayINTERNET "((40 - $adjust))"; SaveURL;;
    $"get_title")      if   [ "$mode" -eq 1 ]; then SendData "${fm_desc[$preset]}";
                       elif [ "$mode" -eq 2 ]; then SendData "${dab_desc[$preset]}";
                       elif [ "$mode" -eq 3 ] || [ "$mode" -eq 4 ] || [ "$mode" -eq 5 ] || [ "$mode" -eq 6 ] || [ "$mode" -eq 7 ];
                       then url=$(cat /home/pi/temp/url);
                       details=$(sudo /home/pi/icecast_play/get_the_stream_title.py $url 2>&1);
                       url2=$(cat /home/pi/temp/url2);
                       SendData "$url2"; fi;;
    $"get_url")        if [ "$mode" -eq 3 ] || [ "$mode" -eq 4 ] || [ "$mode" -eq 5 ] || [ "$mode" -eq 6 ] || [ "$mode" -eq 7 ];
                       then url=$(cat /home/pi/temp/url);
                       SendData "$url"; fi;;
    *)                 if [ "$mute" -eq 0 ]; then Talk2Me "$shout88"; fi;;
  esac
done
