import adafruit_si7021

from busio import I2C
from board import SCL, SDA

i2c = I2C(SCL, SDA)

sensor = adafruit_si7021.SI7021(i2c)

print(sensor.temperature)
print(sensor.relative_humidity)

# Even this returns crappy values