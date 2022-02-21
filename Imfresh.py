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
        data_cursor.execute("CREATE TABLE IF NOT EXISTS periodic (time TIME, voc REAL, humidity REAL, temperature REAL, type TEXT)")
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
        data_cursor.execute("INSERT INTO periodic VALUES(?, ?, ?, ?, ?, ?)", (current_stamp, voc, humidity, temperature, type))
        data_cursor.commit()
        data_cursor.close()

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
            elif datetime.now() > self.next_time - datetime.timedelta(minutes=20):
                self.sensor_library.collect_data()
                if datetime.now() > self.next_time and datetime < self.next_time + datetime.timedelta(minutes=self.measurement_interval):
                    (voc, humidity, temperature) = self.sensor_library.collect_data()
                    self.record_data(voc, humidity, temperature, datetime.now(), "Temp")
            else:
                data_cursor = self.data_con.cursor()
                voc_acc = 0
                humidity_acc = 0
                temperature_acc = 0
                temp_data = data_cursor.execute("SELECT * FROM periodic WHERE type = ?", ("Temp"))
                for row in temp_data:
                    voc_acc += row[1]
                    humidity_acc += row[2]
                    temperature_acc += row[3]
                voc_avg = voc_acc / len(temp_data)
                humidity_avg = humidity_acc / len(temp_data)
                temperature_avg = temperature_acc / len(temp_data)
                data_cursor.execute("DELETE FROM periodic WHERE type = ?", ("Temp"))
                data_cursor.commit()
                data_cursor.close()
                self.record_data(voc_avg, humidity_avg, temperature_avg, datetime.now(), "Avg")
                # TODO: Use MQTT to send data to the server
                # TODO: Use algorithm to produce data
                    
    def activate(self):
    # Activate main loop for device
        while True:
            self.periodic()
            # TODO: Use MQTT to receive data from the server
            # TODO: Implement Loop with real-time measurements

            
# Main Loop
def main():
    device = Imfresh()

if __name__ == '__main__':
    main()