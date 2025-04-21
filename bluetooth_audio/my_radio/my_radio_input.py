#!/usr/bin/python3

from RPi import GPIO
from time import sleep

my_radio_input_pipe = "/tmp/my_radio_input"
volume_clock        = 24
volume_data         = 23
volume_switch       = 25
button1             = 13
button2             = 21
button3             = 7
button4             = 5

GPIO.setmode(GPIO.BCM)
GPIO.setup(volume_clock,  GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(volume_data,   GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(volume_switch, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(button1,       GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(button2,       GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(button3,       GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(button4,       GPIO.IN, pull_up_down=GPIO.PUD_UP)

volume_clock_previous_state  = GPIO.input(volume_clock)
volume_switch_previous_state = GPIO.input(volume_switch)
button1_previous_state       = GPIO.input(button1)
button2_previous_state       = GPIO.input(button2)
button3_previous_state       = GPIO.input(button3)
button4_previous_state       = GPIO.input(button4)

sleep(5)

fifo = open(my_radio_input_pipe, mode="wt")

#---------------------------------------------------------------------------------------------------------------------------#
def write_to_fifo(data):
    fifo.write(data + "\n")
    fifo.flush()
#---------------------------------------------------------------------------------------------------------------------------#

while True:
    volume_clock_state = GPIO.input(volume_clock)
    volume_data_state  = GPIO.input(volume_data)
    if volume_clock_state != volume_clock_previous_state:
        if volume_data_state != volume_clock_state: write_to_fifo("GPIO=volume_up")
        else:                                       write_to_fifo("GPIO=volume_down")
        volume_clock_previous_state = volume_clock_state

    volume_switch_state = GPIO.input(volume_switch)
    if volume_switch_state != volume_switch_previous_state:
        if volume_switch_state == GPIO.LOW: write_to_fifo("GPIO=volume_switch")
        volume_switch_previous_state = volume_switch_state

    button1_state = GPIO.input(button1)
    if button1_state != button1_previous_state:
        if button1_state == GPIO.LOW: write_to_fifo("GPIO=button1")
        button1_previous_state = button1_state

    button2_state = GPIO.input(button2)
    if button2_state != button2_previous_state:
        if button2_state == GPIO.LOW: write_to_fifo("GPIO=button2")
        button2_previous_state = button2_state

    button3_state = GPIO.input(button3)
    if button3_state != button3_previous_state:
        if button3_state == GPIO.LOW: write_to_fifo("GPIO=button3")
        button3_previous_state = button3_state

    button4_state = GPIO.input(button4)
    if button4_state != button4_previous_state:
        if button4_state == GPIO.LOW: write_to_fifo("GPIO=button4")
        button4_previous_state = button4_state

    sleep(0.01)

fifo.close()
GPIO.cleanup()
