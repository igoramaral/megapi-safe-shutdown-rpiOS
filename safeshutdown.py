#!/usr/bin/env python3
from gpiozero import Button, LED
import os
import time
import threading

# GPIOs
power_button = Button(3, pull_up=True)
reset_button = Button(2, pull_up=True)
led = LED(14)

shutdown_in_progress = False

led.on()

def blink_led():
    print("LED blink thread started")
    while power_button.value == 0:
        led.toggle()
        time.sleep(0.2)

def handle_power_off():
    global shutdown_in_progress
    if shutdown_in_progress:
        return

    shutdown_in_progress = True
    
    blink_thread = threading.Thread(
        target=blink_led,
        daemon=True
    )
    blink_thread.start()

    print("Shutting down...")
    os.system("sudo shutdown -h now")

def handle_reset():
    print("Rebooting system...")
    os.system("sudo reboot -h now")

power_button.when_released = handle_power_off
reset_button.when_pressed = handle_reset

from signal import pause
pause()