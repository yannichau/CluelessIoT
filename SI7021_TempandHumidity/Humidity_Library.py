from smbus2 import SMBus, i2c_msg
from time import sleep
class Humidity:
    _ADDRESS = 0x40

    # Commands
    _READ_HUMIDITY = [0xF5]
    _READ_PREV_TEMP = [0xE0]
    _READ_TEMP = [0xF3]
    _RESET = [0xFE]
    _READ_USER_REG = [0xE7]
    _WRITE_USER_REG = [0xE6]
    _READ_HEATER_REG = [0x11]
    _WRITE_HEATER_REG = [0x51]
    _ID1_CMD = [0xFA, 0x0F]
    _ID2_CMD = [0xFC, 0xC9] # Expect 0x15 in SNB3
    # FIRMWARE_REV = bytearray([0x84, 0xB8]) 
    _FIRMWARE_REV = [0x84, 0xB8] # Expect 0xFF(Version 1.0) or #0x20(Version 2.0)

    # Errors
    DEVICE_ERROR = 0b0
    FIRMWARE_ERROR = 0b0
    RANGE_ERROR = 0b0

    # Heater Settings
    _HEATER_ON = [0b0111110]
    _HEATER_OFF =[0b0111010]

    def __init__(self, address=_ADDRESS):
        self._ADDRESS = address
        self.device = SMBus(3)
        self.check_device()

    # Write bytes (default 1 byte)
    def write(self, value): 
        write = i2c_msg.write(self._ADDRESS, value)
        self.device.i2c_rdwr(write)
        sleep(0.1)
    
    # Read bytes (default 1 byte)
    def read(self, cmd, bytes):
        write = i2c_msg.write(self._ADDRESS, cmd)
        self.device.i2c_rdwr(write)
        sleep(0.1)
        read = i2c_msg.read(self._ADDRESS, bytes)
        self.device.i2c_rdwr(read)
        return list(read)

    def collect_readings(self):
        humidity_bytes = self.read(self._READ_HUMIDITY, 2)
        humidity_raw = self.bytes_to_int(humidity_bytes)
        # lsb = int.from_bytes(humidity_bytes[1], 'big')
        # checksum = int.from_bytes(humidity_bytes[2],'big')
        # print("[Si7021] checksum and lsb: " + hex(checksum) + ", " + hex(lsb))

        temp_bytes = self.read(self._READ_PREV_TEMP, 2) # checksum is not necessary
        temp_raw = self.bytes_to_int(temp_bytes)

        humidity = (humidity_raw * 125 / 65536.0) - 6
        temp = (temp_raw * 175.72 / 65536.0) - 46.85

        self.check_range(temp, humidity)
        error = (self.RANGE_ERROR<<2) | (self.DEVICE_ERROR<<1) | (self.FIRMWARE_ERROR)
        print("[Si7021] {:.2f}".format(temp) + "°C | " + "{:.2f}".format(humidity) + "%, error: " + bin(error))

        return [humidity, temp, error]
    
    def check_range(self, temp, humidity):
        if humidity > 80 or humidity < 0 or temp > 85 or temp < -10:
            self.RANGE_ERROR = 0b1
            print("[Si7021] ERROR: Readings out of range.")
        else:
            self.RANGE_ERROR = 0b0


    def bytes_to_int(self, block):
        length = len(block)
        res = 0
        for i in range(length):
            byte = block[i]        
            res = res | (byte  << (length-i-1)*8)
        return res

    def check_device(self):
        print("[Si7021] Read electronic ID 1st byte")
        ID_read1 = self.read(self._ID1_CMD,8)
        # SNA3, CRC, SNA2, CRC, SNA1, CRC, SNA0, CRC

        # Electronic ID
        print("[Si7021] Read electronic ID 2nd byte")
        ID_read2 = self.read(self._ID2_CMD,6)
        device_id = ID_read2[0]
        device = ""
        if device_id == 0x15:
            device = "Si7021"
        else: 
            self.DEVICE_ERROR = 0b1
            print("[Si7021] ERROR: unexpected device")
            if device_id == 0x00 or device_id == 0xFF:
                device = "Engineering Sample"
            if device_id == 0x0D:
                device = "Si7013"
            if device_id == 0x14:
                device = "Si7020"
        print("[Si7021] Device Identification: " + hex(device_id) + " (" + device + ")") # SNB3
        # SNB3, SNB2, CRC, SNB1, SNB0, CRC

        # Read Firmware Revision
        msg = self.read(self._FIRMWARE_REV,1)
        fw_ver = msg[0]
        print()
        if fw_ver == 255:
            print("[Si7021] Firmware version: " + hex(fw_ver) + " (1.0)")        
        elif fw_ver == 32:
            print("[Si7021] Firmware version: " + hex(fw_ver) + " (2.0)")
        else:
            print("[Si7021] ERROR: Firmware version unknown")
            self.FIRMWARE_ERROR = 0b1

        # Measurement Settings
        msg = self.read_userreg()
        res = (msg>>7) | (msg&0b1)
        res_text = ""
        if res == 0:
            res_text = "RH: 12bit, Temp: 14bit"
        elif res == 1:
            res_text = "RH: 08bit, Temp: 12bit"
        elif res == 2:
            res_text = "RH: 10bit, Temp: 13bit"
        elif res == 3:
            res_text = "RH: 11bit, Temp: 11bit"
        print("[Si7021] Measurement Resolution Settings - " + res_text)

        self.test_heater()

    def read_userreg(self):
        user_reg = self.read(self._READ_USER_REG, 1)
        print("[Si7021] User register: " + bin(user_reg[0]))
        sleep(0.1)
        return user_reg[0]

    def test_heater(self):
        self.write(self._WRITE_USER_REG + self._HEATER_ON)
        print("[Si7021] Test: is heater switched on?")
        msg = self.read_userreg()
        self.check_heater(msg)
        self.read_heater_settings()
        self.write(self._WRITE_USER_REG + self._HEATER_OFF)
        print("[Si7021] Test: Is heater off?")
        msg = self.read_userreg()
        self.check_heater(msg)
        self.read_heater_settings()

    def check_heater(self, user_reg):
        heater_bit = (user_reg >> 2) & 0b1
        if heater_bit == 0:
            print("[Si7021] Heater Disabled")
        elif heater_bit == 1:
            print("[Si7021] Heater Enabled")
    
    def read_heater_settings(self):
        msg = self.read(self._READ_HEATER_REG, 1)
        setting = msg[0]
        current_draw = ""
        if setting == 0:
           current_draw = 3.09
        elif setting == 1:
            current_draw = 9.18
        elif setting == 2:
            current_draw = 15.24
        elif setting == 4:
            current_draw = 27.39
        elif setting == 8:
            current_draw = 51.69
        elif setting == 15:
            current_draw = 94.2
        print("[Si7021] Heater current draw: " + str(current_draw) + "mA")