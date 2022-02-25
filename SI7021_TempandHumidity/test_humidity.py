import Humidity_Library
from time import sleep

device = Humidity_Library.Humidity()

print("Initialisation completed")

while True:
    [humidity, temp, error] = device.collect_readings()
    # print("{:.2f}".format(temp) + "°C, " + "{:.2f}".format(humidity) + "% ")  
    sleep(1)
