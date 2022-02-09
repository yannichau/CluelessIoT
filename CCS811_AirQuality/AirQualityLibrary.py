# Dependancies for Air Quality Library
import smbus2
from time import sleep

# Main Class for Air Quality Sensor
class AirQuality:
    # Define the I2C bus
    device = smbus2.SMBus(3)
    # Address for Device
    _ADDRESS = 0x5a
    # Register Addresses
    _STATUS = 0x00
    _MEAS_MODE = 0x01
    _ALG_RESULT_DATA = 0x02
    _RAW_DATA = 0x03
    _ENV_DATA = 0x05
    # _NTC = 0x06
    # _THRESHOLDS = 0x10
    # _BASELINE = 0x11
    _HW_ID = 0x20
    _HW_VERSION = 0x21
    _FW_BOOT_VERSION = 0x23
    _FW_APP_VERSION = 0x24
    _ERROR_ID = 0xE0
    _APP_START = 0xF4
    #_SW_RESET = 0xFF
    # Universal Values
    _STATUS_VAL = 0b10010000
    _MEAS_MODE_VAL = 0
    _HW_ID_VAL = 0x81
    _HW_VERSION_VAL = 0x10
    #_BOOT_SEQUENCE_VAL = [0x11, 0xE5, 0x72, 0x8A]

    # Initialize the Air Quality Sensor
    def __init__(self):
        # Check Versions
        HW_ID_VAL = self.device.read_byte_data(self._ADDRESS, self._HW_ID)
        assert (HW_ID_VAL == self._HW_ID_VAL), "HW_ID is incorrect!"
        sleep(0.01)
        HW_VERSION_VAL = self.device.read_byte_data(self._ADDRESS, self._HW_VERSION)
        HW_VERSION_VAL &= 0xF0
        assert (HW_VERSION_VAL == self._HW_VERSION_VAL), "HW_VERSION is incorrect!"
        sleep(0.01)
        print("Device versions are correct. \n")

        # Checking if Device is Ready
        STATUS_VAL = self.device.read_byte_data(self._ADDRESS, self._STATUS)
        self.load_firmware(STATUS_VAL)


    def load_firmware(self, current_status):
        assert (current_status & 0b00000001 == 0b00000001), "There is an error on the I²C or sensor!"
        assert (current_status & 0b00010000 == 0b00000000), "No valid firmware application is loaded!"
        if (current_status & 0b10010000 == 0b00010000):
            print("Loading firmware... \n")
            self.device.write_byte_data(self._ADDRESS, self._APP_START, 0x00)
            print("Firmware loaded. \n")
        elif(current_status & 0b10010000 == 0b10010000):
            print("Firmware is already loaded. \n")
        

def main():
    AirQuality()

if __name__ == '__main__':
    main()