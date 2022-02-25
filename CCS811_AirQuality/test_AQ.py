import AirQuality_Library
from time import sleep

device = AirQuality_Library.AirQuality()

print("Initialisation completed")

while True:
    [co2, voc, error] = device.get_gas_amounts()
    sleep(1)
