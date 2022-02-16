import Humidity_Library
from time import sleep

device = Humidity_Library.Humidity()

print("Initialisation completed")

device.collect_readings()

print("Test completed")