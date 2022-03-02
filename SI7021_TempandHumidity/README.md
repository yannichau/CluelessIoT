# SI7021 Library

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

   This is because this sensor has the same address as the TMP006 sensor (both 0x40). Hence We've utilised software based GPIO for this sensor. The SCL and SDA are effectively pins 23 and 24 on the device.

## 2. Python Packages Required

Note: tested with Python 3.9.6 on Windows

```bash
from time import sleep
import smbus2
```

## 3. Things to do

1. Run tests

   ```bash
   python3 test_humidity.py
   ```

2. To use library functions, include the library as an import. (This assumes that the library is in the same folder as your file.)

   ```python
   import Humidity_Library
   ```

3. A simple routine to collect data

   ```python
    device = Humidity_Library.Humidity()
    while True:
        [humidity, temp, error] = device.collect_readings()
        sleep(1)
   ```

### 4. Useful methods

1. Constructor

   ```python
   def __init__(self, address=_ADDRESS)
   ```

   No parameters are required for the constructor, i.e. run `device = Humidity_Library.Humidity()` to initialise with default parameters.

   In the constructor, it also calls `check_device()` which checks the electronic ID, firmware revision and measurement settings of the sensor, which are stored on the user register on board.

2. Collect Readings for humdity and ambient temperature

   To collect readings for an instance called "device":

   ```python
   [humidity, temp, error] = device.collect_readings()
   ```

   The method returns a tuple, with units percent and degrees celsius respectively. The error format is specified as follows:

   | Sensor  | Bit  | Error |
   |---|---|---|
   | SI7021  | 2  | Data out of range.  |
   | SI7021  | 1  | Device ID incorrect.  |
   | SI7021  | 0  | Invalid device firmware.  |


   Before returning the values, it calls `check_range()` to verify the range of the values collected. Specifically, it checks that the humidity is between 0-80% and the temperature is between -10-85°C.

1. Other complementary methods not utilised in the final code

    ```python
    def test_heater(self)
    ```

    It switches the heater between on and off states, checks whether it is enabled or disabled with `check_heater()`, and reads the current drawn by the heater using `read_heater_settings()`. The heater can be used to clear off condensation on the device.
   
