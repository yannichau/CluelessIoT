import smbus2
from time import sleep

'''
Overview

SERIAL BUS ADDRESS
- To communicate with the TMP006 or TMP006B, the master must first address slave devices via a slave address byte. 
- The slave address byte consists of 7 address bits, and 1 direction bit that indicate the intent to execute a read or write operation.

READ/WRITE OPERATIONS
- Access a particular register on the TMP006 and TMP006B by writing the appropriate value to the Pointer Register. 
- The pointer value is the first byte transferred after the slave address byte with the R/W bit low. 
- Every write operation to the TMP006 and TMP006B requires a value for the pointer (see Figure 7). 
- When reading from the TMP006 or TMP006B, the last value stored in the pointer by a write operation is used to determine which
register is read by a read operation. 
- To change the register pointer for a read operation, a new value must be written to the pointer. 
    - This transaction is accomplished by issuing a slave address byte with the R/W bit low,
    followed by the pointer byte. No additional data are required. 
    - The master can then generate a START condition and send the slave address byte with the 
    R/W bit high to initiate the read command. If repeated reads from thesame register are desired, 
    it is not necessary to continually send the pointer bytes because the TMP006 and TMP006B 
    retain the pointer value until it is changed by the next write operation. 
    
Note that register bytes are sent MSB first, followed by the LSB.
'''

'''
Data registers for info, measurements and status. 8-bit Pointers in Hex. See section 8.5 (Table 6)
'''

class Infrared:
    # Address for Device
    _ADDRESS = 0x40

    # Sensor Voltage Register: V15-V0 (16 bits) (R)
    _VOLTAGE_REG = 0x00
        # 16 bit, binary 2's complement. One LSB is 156.25nV, Full scale value is +-5.12mV
        # Read only registers, initialised to zeros

    # Local Temperature Register: T13-T0 (14 bits), 3 LSBs of zero (R)
    _TEMP_REG = 0x01 
        # Read only registers, initialised to zeros (after power up or software reset). 
        # Zero until first conversion complete
        # 1 LSB = 1/32oC = 0.03125oC
        # Maximum range is -55-150oC
        # MSB is sign bit: 1 to indicate that integer is negative. Invert all bits and add 1 for abs value.
        # To convert to physical temperature: Right shifting two LSBs, divide by 32

    # Configuration Register for various modes (R/W)
    _CONFIG_REG = 0x02 
        # Overview: RST, MOD[2:0], CR[2:0], EN, _DRDY, 7 LSBs of zeros
        # 15, Reset RST: 1 to reset, self-clears to zero afterwards
            # Initialises all memory locations with respective reset values
        # 14-12, Mode of operation MOD[2:0]: 
            # 111 for sensor and die continuous conversion
                # Performs an A/D conversion followed by low power delay to reduce avg power consumption
            # 000 for power-down/ shut-down
                # Aborts current conversion and puts device into low power shutdown mode
        # 11-9, ADC Conversion Rate CR[2:0]
            # 000 for 4 conversions/sec, 1 samples averaged in total, p-p noise of 0.5oC
            # 001 for 2 conversions/sec, 2 samples averaged in total, p-p noise of 0.35oC
            # 010 for 1 conversions/sec, 4 samples averaged in total, p-p noise of 0.25oC
            # 011 for 0.5 conversions/sec, 8 samples averaged in total, p-p noise of 0.18oC
            # 100 for 0.25 conversions/sec, 16 samples averaged in total, p-p noise of 0.125oC
        # 8, _DRDY: 1 to enable _DRDY pin (see below)
        # 7, _DRDY
            # Normally we don't care about this - only needed if we need to know exactly when a measurement is complete    
            # 0: Conversion in progress
            # 1: Object voltage and ambient temp results are ready to read. 
                # Temp or sensor voltage R/W to the config register is required to clear the condition.
        # 6-0: Unused LSBs

    # Config register values for some modes
    _RESET = 0x8000 # Enable CONFIG[15] to reset
    _MODEON = 0x7000 # Enable CONFIG[14:12] for continuous conversion
    _MODEOFF = 0x0000 
    _EN_DRDY = 0x0100 # Enable CONFIG[8] for DRDY
    _DIS_DRDY = 0x0000
    _DRDY_BIT = 0x0080 # CONFIG[7] contains data regarding DRDY (see above)

    # ADC Conversion Rates for _CONFIG[11:9]
    _ADC_1 = 0x0000 # 000 for 4 conversions/sec, 1 samples averaged in total, p-p noise of 0.5oC
    _ADC_2 = 0x0200 # 001 for 2 conversions/sec, 2 samples averaged in total, p-p noise of 0.35oC
    _ADC_4 = 0x0400 # 010 for 1 conversions/sec, 4 samples averaged in total, p-p noise of 0.25oC
    _ADC_8 = 0x0600 # 011 for 0.5 conversions/sec, 8 samples averaged in total, p-p noise of 0.18oC
    _ADC_16 =0x0800 # 100 for 0.25 conversions/sec, 16 samples averaged in total, p-p noise of 0.125oC

    # Manufacturer ID Register: ID15-ID0 (16 bits). Should read 0x5449 (R)
    _M_REG = 0xFE
    _M_ID = 0x5449

    # Device ID Register: ID15-ID0 (16 bits). Should read 0x0067 (R)
    _DEV_REG = 0xFF
    _DEV_ID = 0x67

    # Constructor to define class members/ attributes. Default to 1 conversions per second, with 4 samples in total.
    def __init__(self, address=_ADDRESS, op_mode=0b111, adc_rate=0b100, drdyen=0b1):
        self._ADDRESS = address
        self.device = smbus2.SMBus(1)
        # self.device.pec = 1 # Enable packet error checking (currently disabled)
        print("----------------------")
        print("Begin Initialisation")
        self.reset()
        self.check_ID()
        self.config(op_mode, adc_rate, drdyen) # Dont need to enable DRDY
        print("Initialisation Complete")
        
    # Write two bytes with 0 offset
    def write(self, register, value):
        # print("    Writing to register " + hex(register) + " with value " + hex(value))
        msb = (value >> 8) & 0xFF
        lsb = value & 0xFF
        # print("    Value bytes (msb, lsb): " + hex(msb) + " , " + hex(lsb))
        self.device.write_i2c_block_data(self._ADDRESS, register, [msb, lsb]) # Need to write byte by byte
    
    # Read 2 byte with 0 offset
    def read(self, register):
        # print("    Reading register " + hex(register))
        block = self.device.read_i2c_block_data(self._ADDRESS, register, 2)
        # print("    Block of bytes" + str(block))
        msb = block[0]
        lsb = block[1]
        res = (msb  << 8) | lsb ;
        return res
    
    def reset(self):
        self.write(self._CONFIG_REG, self._RESET) # Reset device and initialise memory
        sleep(1)
        print("Reset success")
    
    def check_ID(self):
        # Check Manufacturer ID
        res = self.read(self._M_REG)
        print("Checking Manufacturer and Device ID")
        print(" Manufacturer ID: " + hex(res))
        if res != self._M_ID:
            raise RuntimeError("    Not correct manufacturer ID")

        # Check Device ID
        res = self.read(self._DEV_REG)
        print(" Device ID: " + hex(res))
        if res != self._DEV_ID:
            raise RuntimeError("    Not correct manufacturer ID")

        print(" Manufacturer and Device ID matches expected value")
    
    # Configure device. Superposition configuration codes with a | operator.
    def config(self, op_mode, adc_rate, drdyen):
        op_mode_aligned = op_mode << 12
        adc_rate_aligned = adc_rate << 9
        drdyen_align = drdyen << 8
        if op_mode_aligned not in (self._MODEON, self._MODEOFF):
            raise ValueError("Operation maode must be 0b111 (Continuous conversion mode) or 0b000 (Shutdown)")
        if adc_rate_aligned not in (self._ADC_1, self._ADC_2, self._ADC_4, self._ADC_8, self._ADC_16):
            raise ValueError("ADC rate must be one of 0b000 (4 conv/s), 0b001 (2 conv/s), 0b010 (1 conv/s), 0b011 (0.5 conv/s), 0b100 (0.25 conv/s)")
        if drdyen_align not in (self._EN_DRDY, self._DIS_DRDY):
            raise ValueError("Data ready bit enable must 1 (enable) or 0 (disable)")
            
        config_cmd = op_mode_aligned | adc_rate_aligned | drdyen_align
        self.write(self._CONFIG_REG, config_cmd)
        sleep(1)        

    def print_config(self):
        config = self.read(self._CONFIG_REG)
        print("----------------------")
        print("DEBUG: Printing config")
        rst = config >> 15
        op_mode = (config >> 12 ) & 0b111
        adc_rate = (config >> 9) & 0b111
        drdy_en = (config >> 8) & 0b1
        drdy_bit = (config >> 7) & 0b1
        print(" Confiured to " + hex(config))
        print(" RST = " + str(hex(rst)))
        print(" MOD[2:0] = " + str(bin(op_mode)))
        print(" ADC_CR[2:0] = " + str(bin(adc_rate)))
        print(" DRDY_ENABLE = " + str(hex(drdy_en)))
        print(" DRDY_BIT = " + str(hex(drdy_bit)))

    def set_active(self, set):
        status = self.read(self._CONFIG_REG)
        cmd = None
        print("----------------------")
        if set:
            cmd = status | self._MODEON # Set to active
            print("NOTE: Device set to active")
        else:
            cmd = status & ~(self._MODEON) # Set to power off
            print("NOTE: Device powered off")
        self.write(self._CONFIG_REG, cmd)

    def is_active(self):
        msg = self.read(self._CONFIG_REG)
        res = (msg & 0b0111000000000000) == self._MODEON # Bitwise operator: Checks if operation mode bit in config reg is 1.
        if res:
            print("Device is active")
        else:
            print("Device is not active")    
        return res

    def is_ready(self):
        msg = self.read(self._CONFIG_REG)
        res = (msg & 0b0000000010000000) == self._DRDY_BIT # Bitwise operator: Checks if _DRDY bit in config reg is 1.
        if res:
            print("Device is ready")
        else:
            print("Conversion in progress or data ready pin not enabled.")  
        return res

    def collect_reading(self):
        sleep(0.1)
        temp = self.read_temp()
        voltage = self.read_voltage()
        print("----------------------")
        print("Collecting Readings")
        print(" Temperature: " + str(temp))
        print(" Voltage: " + str(voltage))
        return [temp,voltage]

    def read_temp(self):
        raw = self.read(self._TEMP_REG)
        temp = (raw >> 2)/32.0
        msb = (raw >> 15)
        negative = msb == 1
        if negative:
            return -temp
        else:
            return temp
    
    def read_voltage(self):
        msg = self.read(self._VOLTAGE_REG)
        voltage = msg * 156.25e-9
        return voltage
    
    def process_temp(self):
        # If we want to deal with calibration, then we will need to implement a bunch of parameters here
        pass