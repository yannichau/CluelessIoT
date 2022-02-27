from gpiozero import Buzzer
from time import sleep

class Alarm:

    bz = Buzzer(17)

    def __init__(self):
        pass

    def buzz(self, cycles=10):
        for i in range(0,cycles):
            self.bz.on()
            sleep(1.5)
            self.bz.off()
            sleep(0.5)