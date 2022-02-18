import Humidity_Library
from time import sleep

device = Humidity_Library.Humidity()

print("Initialisation completed")

while True:
    device.collect_readings()
    sleep(1)

print("Test completed")