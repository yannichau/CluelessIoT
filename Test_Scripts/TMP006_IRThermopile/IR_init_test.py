import IR_Library
from time import sleep

device = IR_Library.Infrared()

# Test active
print("Test Hypothesis: SHOULD BE ACTIVE")
active = device.is_active() # Should be true: Device should be active upon startup

# Turn off
device.set_active(False)
print("Test Hypothesis: SHOULD BE POWERED OFF")
active = device.is_active() # Should return false

# Turn back on again
device.set_active(True)
print("Test Hypothesis: SHOULD BE ACTIVE")
active = device.is_active()

# Test ready
print("Test Hypothesis: SHOULD BE READY")
ready = device.is_ready()

device.print_config()

[temp, voltage] = device.collect_reading()