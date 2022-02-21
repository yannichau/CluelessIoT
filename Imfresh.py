from re import T
from numpy import record
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
    # Initialise Imfresh Object with relevant parameters
        # Config Variables (With Placeholders for examples)
        self.measurement_times = []
        self.measurement_interval = 60
        self.cleanliness_threshold = 1
        self.alarm_status = True
        self.alarm_time = datetime.time.fromisoformat('12:00:00')
        self.wash_day = datetime.date.fromisoformat('2022-2-30')
        self.next_time = datetime.fromisoformat('2022-01-01T12:00:00')
        self.prev_time = datetime.fromisoformat('2022-01-01T12:00:00')
        # Load settings
        self.load_config()
        # Initialise objects
        self.sensor_library = SensorLibrary()
        self.client = mqtt.Client()
        # Initialise database
        self.data_con = sqlite3.connect('data.sqlite')
        data_cursor = self.data_con.cursor()
        data_cursor.execute("CREATE TABLE IF NOT EXISTS ImFreshData (time TIME, voc REAL, humidity REAL, temperature REAL, type TEXT)")
        data_cursor.commit()
        data_cursor.close()
        # Activate main loop for device
        self.activate()

    def load_config(self):
    # Load configuration from config.yaml
        with open('config.yaml') as f:
            config = yaml.load(f, Loader=yaml.FullLoader)
            self.measurement_schedule = [datetime.fromisoformat(time) for time in config["MeasurementSchedule"]["Times"]]
            self.measurement_interval = config["MeasurementSchedule"]["Interval"]
            self.cleanliness_threshold = config["CleanlinessThreshold"]
            self.alarm_status = config["Alarm"]["Status"]
            self.alarm_time = datetime.time.fromisoformat(config["Alarm"]["Time"])
            self.wash_day = datetime.date.fromisoformat(config["WashDay"])

    def save_config(self):
    # Save configuration to config.yaml
        with open('config.yaml') as f:
            config = yaml.load(f, Loader=yaml.FullLoader)
            config["MeasurementSchedule"]["Times"] = [time.isoformat() for time in self.measurement_schedule]
            config["MeasurementSchedule"]["Interval"] = self.measurement_interval
            config["CleanlinessThreshold"] = self.cleanliness_threshold
            config["Alarm"]["Status"] = self.alarm_on
            config["Alarm"]["Time"] = self.alarm_time.isoformat()
            config["WashDay"] = self.wash_day.isoformat()

    def record_data(self, voc, humidity, temperature, time, type):
    # Record data to database
        current_stamp = time.isoformat()
        data_cursor = self.data_con.cursor()
        data_cursor.execute("INSERT INTO ImFreshData VALUES(?, ?, ?, ?, ?, ?)", (current_stamp, voc, humidity, temperature, type))
        data_cursor.commit()
        data_cursor.close()

    def average_data(self, type):
        data_cursor = self.data_con.cursor()
        voc= 0
        humidity = 0
        temperature = 0
        temp_data = data_cursor.execute("SELECT * FROM ImFreshData WHERE type = ?", (type))
        if len(temp_data) == 0:
            data_cursor.close()
        else:
            for row in temp_data:
                voc += row[1]
                humidity += row[2]
                temperature += row[3]
            voc = voc / len(temp_data)
            humidity = humidity / len(temp_data)
            temperature = temperature / len(temp_data)
            data_cursor.execute("DELETE FROM ImFreshData WHERE type = ?", (type))
            data_cursor.commit()
            data_cursor.close()
        return (voc, humidity, temperature)

    def periodic(self):
    # Conduct periodic measurements
        while True:
            if datetime.now() > self.next_time + datetime.timedelta(minutes=self.measurement_interval):
                no_time_available = True
                for new_time in self.measurement_times:
                    if datetime.now().time() < new_time:
                        self.prev_time = self.next_time
                        self.next_time = new_time
                        no_time_available = False
                        break
                if no_time_available:
                    [datetime.timedelta(days=7) + time for time in self.measurement_times]
            elif datetime.now() > self.next_time - datetime.timedelta(minutes=20) and datetime.now() < self.next_time:
                self.sensor_library.collect_data()
            elif datetime.now() > self.next_time and datetime < self.next_time + datetime.timedelta(minutes=self.measurement_interval):
                (voc, humidity, temperature) = self.sensor_library.collect_data()
                self.record_data(voc, humidity, temperature, datetime.now(), "PeriodicTemp")
            else:
                voc_avg, humidity_avg, temperature_avg = self.average_data("PeriodicTemp")
                if(voc_avg or humidity_avg or temperature_avg):
                    self.record_data(voc_avg, humidity_avg, temperature_avg, datetime.now(), "PeriodicAvg")

    def realtime(self):
    # TODO: Implement Loop with real-time measurements
        pass

    def mqtt_listener(self):
    # TODO: Use MQTT Loop to listen to data from the server
        pass
                    
    def activate(self):
    # Activate main loop for device
        while True:
            self.periodic()
            # TODO: Use algorithm to produce data
            # TODO: Use MQTT to send data to the server
            # TODO: Use Multithreading to start and stop threads when required
             
# Main Loop
def main():
    device = Imfresh()

if __name__ == '__main__':
    main()