import os
import sys
from time import sleep

# IMPORTANT: path relative to where file is run, not relative to this file
script_dir = os.path.dirname( __file__ )
Humidity_dir = os.path.join( script_dir, '..', 'SI7021_TempandHumidity')
sys.path.append( Humidity_dir )
import Humidity_Library

script_dir = os.path.dirname( __file__ )
AirQuality_dir = os.path.join( script_dir, '..', 'CCS811_AirQuality')
sys.path.append( AirQuality_dir )
import AirQuality_Library

script_dir = os.path.dirname( __file__ )
IR_dir = os.path.join( script_dir, '..', 'TMP006_IRThermopile')
sys.path.append( IR_dir )
import IR_Library

class Middleman:

    def __init__(self):   
        self.IR_device = IR_Library.Infrared()
        self.AQ_device = AirQuality_Library.AirQuality()
        self.RH_device = Humidity_Library.Humidity()
        
        print("Middleman: All devices successfully initialised!")

        
    def collect_data(self):
        [co2, voc] = self.AQ_device.get_gas_amounts()
        [temp, voltage] = self.IR_device.collect_readings()
        [humidity, ambient_temp] = self.RH_device.collect_readings()

        print(str(co2) + ", " + str(voc) + ", " + "{:.2f}".format(temp) + "°C, " + "{:.2f}".format(voltage) + "V, " + "{:.2f}".format(humidity) + "%, " + "{:.2f}".format(ambient_temp) +"°C")

# For testing only
def main():
    middleman = Middleman()

    print("co2" + ", " + "voc" + ", " + "temp" + ", " + "voltage" + ", " + "humidity" + ", " + "ambient temperature" )
    while True:
        middleman.collect_data()
        sleep(1)

if __name__ == '__main__':
    main()