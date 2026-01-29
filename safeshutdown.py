#!/usr/bin/env python3
from gpiozero import Button, LED
import os
import time

# GPIO mapping (BCM)
power_button = Button(3, pull_up=True)        # Power switch
safe_shtd_button = Button(4, pull_up=True)   # Safe shutdown enable
reset_button = Button(2, pull_up=True)        # Reset (momentary)
led = LED(14)                                 # Case LED

shutdown_in_progress = False

# Inicialização
led.on()

def do_shutdown():
    global shutdown_in_progress
    if shutdown_in_progress:
        return

    shutdown_in_progress = True
    led.blink(on_time=0.2, off_time=0.2)
    os.system("shutdown -h now")

def do_reset():
    os.system("reboot")

reset_button.when_pressed = do_reset

while True:
    # Power OFF + SafeShutdown ON → shutdown
    if (not power_button.is_pressed) and safe_shtd_button.is_pressed:
        do_shutdown()

    time.sleep(0.2)