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
        print("Device versions are correct.")

        # Checking if Device is Ready
        STATUS_VAL = self.device.read_byte_data(self._ADDRESS, self._STATUS)
        self.load_firmware(STATUS_VAL)

        # self.read_gas_amounts()

    def load_firmware(self, current_status):
        assert ((current_status & 0b00000001) == 0b00000000), "There is an error on the I²C or sensor!"
        assert (current_status & 0b00010000 == 0b00010000), "No valid firmware application is loaded!"
        if (current_status & 0b10010001 == 0b00010000):
            print("Loading firmware...")
            self.device.write_byte(self._ADDRESS, self._APP_START)
            sleep(0.01)
            current_status = self.device.read_byte_data(self._ADDRESS, self._STATUS)
            sleep(0.01)
        if(current_status & 0b10010001 == 0b10010000):
            print("Firmware is loaded.")
        sleep(0.01)

    def read_gas_amounts(self):
        print("Activating Measurements...")
        self.device.write_byte_data(self._ADDRESS, self._MEAS_MODE, 0b00010000)
        print("Measurements Activated.")
        print("________________________")
        print("Upper value is Co2, Lower two Bytes is TVOC.")
        sleep(4)
        file = open("gasdata.txt", "a")
        time = 0
        while (True):
            Alg_data = self.device.read_i2c_block_data(self._ADDRESS, self._ALG_RESULT_DATA, 4)
            Co2_data = Alg_data[0]*16+Alg_data[1]
            Voc_data = Alg_data[2]*16+Alg_data[3]
            file.write(str(time) + " CO2: " + str(Co2_data) + " VOC: " + str(Voc_data) + "\n")
            print(Co2_data, " | ", Voc_data)
            sleep(0.9)
            time += 1

    def get_gas_amounts(self):
        self.device.write_byte_data(self._ADDRESS, self._MEAS_MODE, 0b00010000)
        Alg_data = self.device.read_i2c_block_data(self._ADDRESS, self._ALG_RESULT_DATA, 4)
        Co2_data = Alg_data[0]*16+Alg_data[1]
        Voc_data = Alg_data[2]*16+Alg_data[3]
        return [Co2_data,Voc_data]

def main():
    AirQuality()

if __name__ == '__main__':
    main()