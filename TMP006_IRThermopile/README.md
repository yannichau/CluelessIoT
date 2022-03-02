# TMP006 Temperature Sensor Library

## 1. Interfacing

1. Access raspberry pi locally: COM7, 115200, Serial
2. Or over the WiFi with SSH:
   1. At (Yanni's) Home: (IP address removed)
   2. At School: 146.169.xxx.xx (Will change)
3. File transfer via SCP protocol (e.g. WinSCP)
4. Detect module

   ```bash
   sudo i2cdetect -y 1
   ```

## 2. Python Packages Required

Note: tested with Python 3.9.6 on Windows

```bash
from time import sleep
import smbus2
```

## 3. Things to do

1. Run tests

   ```bash
   python3 IR_init_test.py
   ```

2. To use library functions, include the library as an import. (This assumes that the library is in the same folder as your file.)

   ```python
   import IR_Library
   ```

3. A simple routine to collect data

   ```python
   import IR_Library
   device = IR_Library.Infrared()
   [temp, voltage, error] = device.collect_reading()
   ```

### 4. Useful methods

1. Constructor

   ```python
   def __init__(self, address=_ADDRESS, op_mode=0b111, adc_rate=0b100, drdyen=0b1)
   ```

   No parameters are required for the constructor, i.e. run `device = IR_Library.Infrared()` to initialise with default parameters.

   If you would like to specify parameters, they must be confined to the following:

   ```txt
   address: 2 byte address of the sensor (by default 0x40)
   op_mode (Operation Mode): 0b111 (Continuous conversion mode), 0b000 (Shutdown)
   adc_rate (ADC conversion rate): 0b000 (4 conv/s), 0b001 (2 conv/s), 0b010 (1 conv/s), 0b011 (0.5 conv/s), 0b100 (0.25 conv/s)
   drydyen (Data Ready Bit Enable): 1 (enable), 0 (disable)
   ```

2. Reset

   ```python
   def reset(self)
   ```

   Resets the device.

3. Configure

   ```python
   def config(self, op_mode, adc_rate, drdyen)
   ```

   Configure settings (continuous/disabled operation mode, analogue to discrete conversion rate, and data ready enable bit) for the device. Parameters are confined in the same way as parameters for the constructor.

4. Debug Configuration

   ```python
   def print_config(self)
   ```

5. Device operation mode setter and getter

   ```python
   def set_active(self, set) # If Set is true, device would be put into continuous conversion mode. Otherwise, the device would be powered off.
   def is_active(self) # Returns a boolean
   ```

6. Collect Readings for temperature and voltage

   To collect readings for an instance called "device":

   ```python
   [temp,voltage, error] = device. collect_reading(self)
   ```

   The method returns a tuple `[temperature, voltage, error]`, with units degrees celsius and volts respectively. The error code format is as follows:

   | Sensor  | Bit  | Error |
   |---|---|---|
   | TMP006  | 2  | Data out of range.   |
   | TMP006  | 1  | Manufacturer or device ID is incorrect.  |
   | TMP006  | 0  | Operation mode is invalid. For example, configuration register specified inactive, or invalid ADC (analogue digital conversion) rates.  |

   Before returning the values, it calls `check_readings()` to verify the range of the values collected. Specifically the temperatures should be between -40 and 125°C.
   
