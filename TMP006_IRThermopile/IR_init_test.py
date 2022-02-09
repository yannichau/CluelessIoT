import IR_Library

device = IR_Library.Infrared()

# Test active
print("SHOULD BE ACTIVE")
active = device.is_active() # Should be true: Device should be active upon startup

# Turn off
device.set_active(False)
print("SHOULD BE POWERED OFF")
active = device.is_active() # Should return false

# Turn back on again
device.set_active(True)
print("SHOULD BE ACTIVE")
active = device.is_active()

# Test ready
# ready = device.is_ready()

temp = device.read_temp()
voltage = device.read_voltage()