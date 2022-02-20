# TODO: Implement Main Loop with scheduled measurements
# TODO: Implement Main Loop with real-time measurements
# TODO: Use algorithm to produce data
# TODO: Store important values in settings
# TODO: Use MQTT to receive data from the server
# TODO: Use MQTT to send data to the server

from time import sleep
from CluelessIoT.Sensors.SensorLibrary import SensorLibrary
import paho.mqtt.client as mqtt
from datetime import datetime
import sqlite3
import yaml

class Imfresh():
    # Address to communicate through MQTT. These must be set beforehand
    broker_address = "placeholder"
    port_number = 0

    def __init__(self):
        # Config Variables (With Placeholders for examples)
        self.measurement_schedule = []
        self.real_time_measurement = False
        self.cleanliness_threshold = 1
        self.alarm_status = True
        self.alarm_time = datetime.time.fromisoformat('12:00:00')
        self.wash_day = datetime.date.fromisoformat('2022-2-30')
        # Load settings
        self.load_config()
        # Initialise objects
        self.sensor_library = SensorLibrary()
        self.client = mqtt.Client()
        self.settings = sqlite3.connect('settings.sqlite')

        self.activate()

    def load_config(self):
        with open('config.yaml') as f:
            config = yaml.load(f, Loader=yaml.FullLoader)
            self.measurement_schedule = [datetime.time.fromisoformat(time) for time in config["measurement_times"]]
            self.cleanliness_threshold = config["cleanliness_threshold"]
            self.alarm_status = config["alarm"]["status"]
            self.alarm_time = datetime.time.fromisoformat(config["alarm"]["time"])
            self.wash_day = datetime.date.fromisoformat(config["wash_day"])

    def save_config(self):
        with open('config.yaml') as f:
            config = yaml.load(f, Loader=yaml.FullLoader)
            config["measurement_times"] = [time.isoformat() for time in self.measurement_schedule]
            config["cleanliness_threshold"] = self.cleanliness_threshold
            config["alarm"]["status"] = self.alarm_on
            config["alarm"]["time"] = self.alarm_time.isoformat()
            config["wash_day"] = self.wash_day.isoformat()

# Main Loop
def main():
    device = Imfresh()

if __name__ == '__main__':
    main()