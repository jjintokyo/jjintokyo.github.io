#!/usr/bin/python3

from RPLCD.i2c import CharLCD
from threading import Timer
from threading import Thread
from time import sleep

my_radio_output_pipe         = "/tmp/my_radio_output"
blanks16                     = "                "
blanks8                      = "        "
blanks6                      = "      "
blanks3                      = "   "
backlight_timeout_in_seconds = 30
backlight_always_on          = False
play_stop_timeout_in_seconds = 3
save_page_preset_string      = ""
save_volume_string           = ""
save_equalizer_string        = ""
show_song                    = False
do_scrolling                 = False
scroll_text_hold_in_seconds  = 4
scroll_text_delay_in_seconds = 0.3

HAPPY_ALIEN = ( 0b11111, 0b10101, 0b11111, 0b11111, 0b01110, 0b01010, 0b01010, 0b11011 )
SAD_DUDE    = ( 0b11111, 0b10101, 0b11111, 0b11011, 0b11011, 0b11111, 0b10001, 0b11111 )

#---------------------------------------------------------------------------------------------------------------------------#
def init_lcd():
    global LCD
    LCD = CharLCD(i2c_expander='PCF8574', address=0x27, port=1, cols=16, rows=2, dotsize=8, auto_linebreaks=False, charmap='A02')
    LCD.display_enabled   = True
    LCD.backlight_enabled = True
    LCD.cursor_mode       = 'hide'
    LCD.create_char(1, HAPPY_ALIEN)
    LCD.create_char(2, SAD_DUDE)
    LCD.clear()
#---------------------------------------------------------------------------------------------------------------------------#

def backlight(toggle):
    LCD.backlight_enabled = toggle

def backlight_timeout():
    screen_cleanup()
    backlight(False)

def play_stop_timeout():
    LCD.cursor_pos = (1, 0)
    LCD.write_string(blanks16)
    display_volume(save_volume_string)
    display_equalizer(save_equalizer_string)

def display_volume(data):
    LCD.cursor_pos = (1, 0)
    LCD.write_string(blanks8)
    LCD.cursor_pos = (1, 0)
    LCD.write_string(data)

def display_equalizer(data):
    LCD.cursor_pos = (1, 10)
    LCD.write_string(blanks6)
    LCD.cursor_pos = (1, 10)
    LCD.write_string(data)

def display_line_1(data):
    LCD.home()
    LCD.write_string(blanks16)
    LCD.home()
    LCD.write_string(data)

def display_line_2(data):
    LCD.cursor_pos = (1, 0)
    LCD.write_string(blanks16)
    LCD.cursor_pos = (1, 0)
    LCD.write_string(data)

def display_song(data):
    global show_song, do_scrolling
    show_song = True
    LCD.cursor_pos = (1, 0)
    LCD.write_string(blanks16)
    LCD.cursor_pos = (1, 0)
    song = data.strip()
    if len(song) > 16:
        do_scrolling = True
        setup_scroll_text = Thread(target=scroll_text, args=(song,))
        setup_scroll_text.start()
    else:
        do_scrolling = False
        LCD.write_string(song)

def scroll_text(song):
    song_text_full     = song + blanks3
    song_text_length   = len(song_text_full)
    song_text_lcd      = song_text_full[0:16]
    song_text_position = 15
    while do_scrolling == True:
        LCD.cursor_pos = (1, 0)
        LCD.write_string(song_text_lcd)
        sleep(scroll_text_hold_in_seconds) if song_text_position == 15 else sleep(scroll_text_delay_in_seconds)
        song_text_position += 1
        if song_text_position >= song_text_length: song_text_position = 0
        song_text_lcd = song_text_lcd[1:16] + song_text_full[song_text_position:song_text_position + 1]

def screen_cleanup():
    global do_scrolling, show_song
    if do_scrolling == True:
        do_scrolling = False
        init_lcd()
        display_line_1(save_page_preset_string)
        display_volume(save_volume_string)
        display_equalizer(save_equalizer_string)
    else:
        if show_song == True:
            show_song = False
            play_stop_timeout()

#---------------------------------------------------------------------------------------------------------------------------#

init_lcd()

while True:
    if backlight_always_on == False:
        backlight(True)
        setup_backlight_timeout = Timer(backlight_timeout_in_seconds, backlight_timeout)
        setup_backlight_timeout.start()

    fifo = open(my_radio_output_pipe, mode="rt")

    if backlight_always_on == False: setup_backlight_timeout.cancel()

    for line in fifo:
        if line.startswith("BACKLIGHT=ON"):
            do_scrolling = True
            screen_cleanup()
            backlight(True)
            backlight_always_on = True
            setup_backlight_timeout.cancel()
            display_line_2(line.strip())
            setup_play_stop_timeout = Timer(play_stop_timeout_in_seconds, play_stop_timeout)
            setup_play_stop_timeout.start()
            continue
        if line.startswith("BACKLIGHT=OFF"):
            do_scrolling = True
            screen_cleanup()
            backlight_always_on = False
            display_line_2(line.strip())
            setup_play_stop_timeout = Timer(play_stop_timeout_in_seconds, play_stop_timeout)
            setup_play_stop_timeout.start()
            continue
        if line.startswith("PAGE_PRESET="):
            screen_cleanup()
            save_page_preset_string = line.strip()[12:]
            display_line_1(save_page_preset_string)
            continue
        if line.startswith("VOL:"):
            screen_cleanup()
            save_volume_string = line.strip()
            display_volume(save_volume_string)
            continue
        if line.startswith("EQ:"):
            screen_cleanup()
            save_equalizer_string = line.strip()
            display_equalizer(save_equalizer_string)
            continue
        if line.startswith("Radio play!"):
            screen_cleanup()
            display_line_2(line.strip() + ' \x01')
            setup_play_stop_timeout = Timer(play_stop_timeout_in_seconds, play_stop_timeout)
            setup_play_stop_timeout.start()
            continue
        if line.startswith("Radio stop!"):
            screen_cleanup()
            display_line_2(line.strip() + ' \x02')
            setup_play_stop_timeout = Timer(play_stop_timeout_in_seconds, play_stop_timeout)
            setup_play_stop_timeout.start()
            continue
        if line.startswith("LCD1="):
            display_line_1(line.strip()[5:])
            continue
        if line.startswith("LCD2="):
            display_line_2(line.strip()[5:])
            continue
        if line.startswith("SONG="):
            screen_cleanup()
            display_song(line.strip()[5:])
            continue

LCD.close()
