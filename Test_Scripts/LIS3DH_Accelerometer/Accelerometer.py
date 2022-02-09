# Libraries for Dependancies go here
import smbus2
import time

# Define the I2C bus
bus = smbus2.SMBus(1)

# Send Reboot Command
bus.write_byte_data(0x18, 0x24, 0x80)
time.sleep(0.01)  # takes 5ms 

# Enable all axes, normal mode.
bus.write_byte_data(0x18, 0x20, 0x07)
        
ctl1 = bus.read_byte_data(0x18, 0x20)
ctl1 &= ~(0xF0)
ctl1 |= 0x70

bus.write_byte_data(0x18, 0x20, ctl1)

# Read the data
while (True):
    x_low = bus.read_byte_data(0x18, 0x28)
    x_high = bus.read_byte_data(0x18, 0x29)
    x = x_high * 256 + x_low
    if x > 32767:
        x -= pow(2, 16)
    print(x)