#!/usr/bin/env python3
from gpiozero import Button, LED
import os
import time

# GPIOs
power_button = Button(3, pull_up=True)
safe_shtd_button = Button(4, pull_up=True)
reset_button = Button(2, pull_up=True)
led = LED(14)

shutdown_in_progress = False

led.on()

def handle_power_off():
    global shutdown_in_progress

    # Executa SOMENTE se safe shutdown estiver habilitado
    if safe_shtd_button.is_pressed and not shutdown_in_progress:
        shutdown_in_progress = True
        led.blink(on_time=0.15, off_time=0.15)
        print("Shutting down...")
        os.system("shutdown -h now")

def handle_reset():
    print("Rebooting system...")
    os.system("sudo reboot -h now")

# Detecta TRANSIÇÃO (edge), não polling
power_button.when_released = handle_power_off
reset_button.when_pressed = handle_reset

# Mantém o script vivo
from signal import pause
pause()