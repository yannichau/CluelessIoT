# Dependancies for Air Quality Library
from smbus2 import SMBus, i2c_msg
from time import sleep

# Main Class for Air Quality Sensor
class AirQuality:
    # Define the I2C bus
    device = SMBus(3)
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

    RANGE_ERROR = 0b0
    HW_ERROR = 0b0
    I2C_ERROR = 0b0
    FW_ERROR = 0b0

    # Initialize the Air Quality Sensor
    def __init__(self):
        # Check Versions
        HW_ID_VAL = self.device.read_byte_data(self._ADDRESS, self._HW_ID)
        sleep(0.01)
        HW_VERSION_VAL = self.device.read_byte_data(self._ADDRESS, self._HW_VERSION)
        HW_VERSION_VAL &= 0xF0
        sleep(0.01)

        if (HW_VERSION_VAL == self._HW_VERSION_VAL) and (HW_ID_VAL == self._HW_ID_VAL):
            print("[CCS811] Device versions correct.")
            self.HW_ERROR = 0b0
        else:
            self.HW_ERROR = 0b1
            if not (HW_ID_VAL == self._HW_ID_VAL):
                print("[CCS811] ERROR: HW_ID is incorrect!")
            if not (HW_VERSION_VAL == self._HW_VERSION_VAL):
                print("[CCS811] ERROR: HW_VERSION is incorrect!")

        # Checking if Device is Ready
        STATUS_VAL = self.device.read_byte_data(self._ADDRESS, self._STATUS)
        self.load_firmware(STATUS_VAL)

        # self.read_gas_amounts()
        self.start_measurements()

    def load_firmware(self, current_status):
        if not ((current_status & 0b00000001) == 0b00000000):
            print("[CCS811] ERROR: There is an error on the I²C or sensor!")
            self.I2C_ERROR = 0b1
        if not (current_status & 0b00010000 == 0b00010000):
            print("[CCS811] ERROR: No valid firmware application is loaded!")
            self.FW_ERROR = 0b1
            
        if (current_status & 0b10010001 == 0b00010000):
            print("[CCS811] Loading firmware...")
            self.device.write_byte(self._ADDRESS, self._APP_START)
            sleep(0.01)
            current_status = self.device.read_byte_data(self._ADDRESS, self._STATUS)
            sleep(0.01)
        if(current_status & 0b10010001 == 0b10010000):
            print("[CCS811] Firmware is loaded.")
            self.FW_ERROR = 0b0
            self.I2C_ERROR = 0b0
        sleep(0.01)

    def start_measurements(self):
        print("[CCS811] Activating Measurements...")
        self.device.write_byte_data(self._ADDRESS, self._MEAS_MODE, 0b00010000)
        print("[CCS811] Measurements Activated.")
        sleep(4)

    # MUST RUN start_measurements() before getting gas amounts
    def get_gas_amounts(self):
        Alg_data = self.device.read_i2c_block_data(self._ADDRESS, self._ALG_RESULT_DATA, 4)
        Co2_data = Alg_data[0]*256+Alg_data[1]
        Voc_data = Alg_data[2]*256+Alg_data[3]

        self.check_range(Co2_data, Voc_data)
        error = (self.RANGE_ERROR<<3) | (self.HW_ERROR << 2) | (self.I2C_ERROR<<1) | (self.FW_ERROR)
        print("[CCS811] {:.2f}".format(Co2_data) + "ppm, " + "{:.2f}".format(Voc_data) + "ppb, error: " + bin(error))

        return [Co2_data,Voc_data, error]
    
    def check_range(self, co2, voc):
        if co2 > 8192 or co2 < 400 or voc > 1187 or voc < 0:
            self.RANGE_ERROR = 0b1
            print("[CCS811] ERROR: Readings out of range.")
        else:
            self.RANGE_ERROR = 0b0

def main():
    AirQuality()

if __name__ == '__main__':
    main()