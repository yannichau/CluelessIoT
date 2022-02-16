from smbus2 import SMBus, i2c_msg
from time import sleep

class Humidity:
    _ADDRESS = 0x40
    
    # Commands
    _READ_HUMIDITY = 0xE5
    _READ_PREV_TEMP = 0xE0
    _READ_TEMP = 0xE3
    _RESET = 0xFE
    _READ_USER_REG = 0xE7
    _WRITE_USER_REG = 0xE6
    _READ_HEATER_REG = 0x11
    _WRITE_HEATER_REG = 0x51
    # _ID1_CMD = bytearray([0xFA, 0x0F])
    _ID1_CMD = 0xFA0F
    # _ID2_CMD = bytearray([0xFC, 0xC9])
    _ID2_CMD = 0xFCC9 # Expect 0x15
    # FIRMWARE_REV = bytearray([0x84, 0xB8]) #0xFF(Version 1.0) or #0x20(Version 2.0)
    _FIRMWARE_REV = 0x84B8

    # TODO: Fix hardware check
    def __init__(self, address=_ADDRESS):
        self._ADDRESS = address
        self.device = SMBus(3)
        # self.check_device()

    # Write bytes (default 1 byte)
    def write(self, register, value, bytes=1):
        if bytes == 1:
            self.device.write_byte_data(self._ADDRESS, register, value)
        else:
            res = []
            # print("    Writing to register " + hex(register) + " with value " + hex(value))
            for i in range(bytes):
                lsb = (value >> (bytes-i-1)*8) & 0xFF
                res.append(lsb)
            print("    Writing block of bytes" + str(res))
            self.device.write_i2c_block_data(self._ADDRESS, register, res) # Need to write byte by byte
    
    # Read bytes (default 1 byte)
    # TODO: Read 3 bytes to check CRC (LSB would be error parity bit)
    def read(self, register, bytes=1):
        res = 0
        if bytes == 1:
            res = self.device.read_byte_data(self._ADDRESS, 0)
        else:
            # print("    Reading register " + hex(register))
            block = self.device.read_i2c_block_data(self._ADDRESS, register, bytes)
            # print("    Block of bytes" + str(block))
            for i in range(bytes):        
                msb = block[i]
                res = (msb  << (bytes-i-1)*8) | res ;
        return res
    
    def check_device(self):
        print("Read electronic ID 1st byte")
        write = i2c_msg.write(self._ADDRESS, [0XFA, 0x0F])
        read = i2c_msg.read(self._ADDRESS, 8)
        self.device.i2c_rdwr(write, read)
        print(write)
        print(read)

        print("Read electronic ID 2nd byte")
        write = i2c_msg.write(self._ADDRESS, [0XFC, 0xC9])
        read = i2c_msg.read(self._ADDRESS, 6)
        self.device.i2c_rdwr(write, read)
        print(write)
        print(read)

        print("Read Firmware Revision")
        write = i2c_msg.write(self._ADDRESS, [0x84, 0xB8])
        read = i2c_msg.read(self._ADDRESS, 8)
        self.device.i2c_rdwr(write, read)
        print(write)
        print(read)

        print("    Checking Device ID 1 ")
        # self.device.write_i2c_block_data(self._ADDRESS, [0xFA, 0x0F], )
        sleep(0.1)
        res = self.device.read_i2c_block_data(self._ADDRESS, 0xFA, 8)
        res_2 = self.device.read_i2c_block_data(self._ADDRESS, 0x0F, 8)
        print(res)
        print(res_2)

        # print("    Checking Device ID 2 ")
        # self.device.write_i2c_block_data(self._ADDRESS, 0x00, [0XFC, 0xC9])
        # sleep(0.1)
        # res = self.read(0,6)
        # print(res)

        # print("    Checking Device ID 2 ")
        # self.write(0x00, self._ID2_CMD, 2)
        # sleep(0.1)
        # res = self.read(0,6)
        # print(res)
        # print("    Firmware Rev ")
        # res = self.read(self._FIRMWARE_REV,1)
        # print(res)
    
    def collect_readings(self):
        sleep(0.1)
        humidity_raw = self.read(self._READ_HUMIDITY, 2)
        temp_raw = self.read(self._READ_PREV_TEMP, 2)

        humidity = (humidity_raw * 125 / 65536.0) - 6
        temp = (temp_raw * 175.72 / 65536.0) - 46.85

        print ("Humidity %%RH: %.2f%%" %humidity)
        print ("Temperature Celsius: %.2f°C" %temp)

        return [humidity, temp]




