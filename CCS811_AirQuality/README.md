# CCS811 Library

## 1. Interfacing

1. Access raspberry pi locally: COM7, 115200, Serial
2. Or over the WiFi with SSH:
   1. At (Yanni's) Home: (IP address removed)
   2. At School: 146.169.xxx.xx (Will change)
3. File transfer via SCP protocol (e.g. WinSCP)
4. Detect module

   ```bash
   sudo i2cdetect -y 3
   ```

   We've utilised software based GPIO for this sensor. Hence the SCL and SDA are effectively pins 23 and 24 on the device.

## 2. Python Packages Required

Note: tested with Python 3.9.6 on Windows

```bash
from time import sleep
import smbus2
```

## 3. Things to do

1. Run tests

   ```bash
   python3 test_AQ.py
   ```

2. To use library functions, include the library as an import. (This assumes that the library is in the same folder as your file.)

   ```python
   import AirQuality_Library
   ```

3. A simple routine to collect data

   ```python
    device = AirQuality_Library.AirQuality()
    while True:
        [co2, voc, error] = device.get_gas_amounts()
        sleep(1)
   ```

### 4. Useful methods

1. Constructor

   ```python
   def __init__(self, address=_ADDRESS)
   ```

   No parameters are required for the constructor, i.e. run `device = AirQuality_Library.AirQuality()` to initialise with default parameters.

   In the constructor, the program:
   - checks the hardware ID and version and matches with that of the CCS811,
   - calls `load_firmware()`,
   - activates measurement mode. Note that the device must sleep for a couple seconds before it is fully activated for measurement.

2. Collect Readings for humdity and ambient temperature

   To collect readings for an instance called "device":

   ```python
   [co2, voc, error] = device.get_gas_amounts()
   ```

   The method returns a tuple, with units ppm (parts per million) and ppb (parts per billion) respectively. 
   
   The error code format is as follows.

   | Sensor  | Bit  | Error |
    |---|---|---|
    | CCS811  | 3  | Data out of range.  |
    | CCS811  | 2  | Hardware ID or version is incorrect. |
    | CCS811  | 1  | I2C error. |
    | CCS811  | 0  | No valid firmware application is loaded. |

   Before returning the values, it calls `check_range()` to verify the range of the values collected. Specifically, it checks that CO2 levels are between 400-8192ppm, and that VOC levels are between 0 and 1187ppb.
   
