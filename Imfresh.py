from time import sleep
from CluelessIoT.Sensors.SensorLibrary import SensorLibrary
import paho.mqtt.client as mqtt
from datetime import datetime
import sqlite3
import yaml
import json
import threading

class Imfresh():
    # Address to communicate through MQTT. These must be set beforehand
    IP_ADDRESS = "54.174.95.180"
    PORT = 1883

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
        self.do_real_time = False
        self.measuring_real_time = False
        self.do_periodic = True
        self.measuring_periodic = False
        # Load current settings from config.yaml
        self.load_config()
        # Initialise library
        self.sensor_library = SensorLibrary()
        # Initialise MQTT Client
        self.client = mqtt.Client("", True, None, mqtt.MQTTv31)
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
    # Calculate average data from temporary database values
        data_cursor = self.data_con.cursor()
        voc = 0
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
        while self.do_periodic:
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
                voc = 50 if voc > 50 else voc
                self.record_data(voc, humidity, temperature, datetime.now(), "PeriodicTemp")
            else:
                voc_avg, humidity_avg, temperature_avg = self.average_data("PeriodicTemp")
                if(voc_avg or humidity_avg or temperature_avg):
                    self.record_data(voc_avg, humidity_avg, temperature_avg, self.prev_time, "PeriodicAvg")
        self.measuring_periodic = False

    def realtime(self):
    # Conduct realtime measurements
        datapoint = 0
        while self.do_real_time:
            if(datapoint == 5):
                datapoint = 0
                voc_avg, humidity_avg, temperature_avg = self.average_data("RealTimeTemp")
                # TODO: Use MQTT to send realtime data to the server
            (voc, humidity, temperature) = self.sensor_library.collect_data()
            sleep(1)
            self.record_data(voc, humidity, temperature, datetime.now(), "RealTimeTemp")
            datapoint += 1
        self.measuring_real_time = False

    def mqtt_on_connect(client, userdata, flags, rc):
        # Callback for when the client connects to the broker
        if rc == 0:
            client.connected_flag = True #set flag
            print("Connected OK Returned code = ",rc)
        else:
            print("Bad connection Returned code = ",rc)

    def mqtt_on_message(client, userdata, message) :
    # Callback for when a message is received
        m_decode=str(message.payload.decode("utf-8","ignore"))
        try:
            m_in=json.loads(m_decode) #decode json data
            print("Received {} message on topic {}".format(m_in["type"], message.topic))
            # TODO: Save settings received on device
        except ValueError:
            print("The message was not a valid JSON")
        
    def mqtt_client(self):
    # Connect as client to the MQTT broker and start listening
        self.client.on_connect = self.mqtt_on_connect
        self.client.on_message = self.mqtt_on_message
        self.client.username_pw_set(username="cluelessIoT",password="Imfresh")
        self.client.connect(self.IP_ADDRESS, self.PORT)
        self.client.subscribe("IC.embedded/cluelessIoT")
        self.client.loop_start()
        pass
                    
    def activate(self):
    # Activate main loop for device
        self.mqtt_client()
        while True:
            if(self.do_periodic and not self.measuring_periodic):
                self.measuring_periodic = True
                self.periodic_thread = threading.Thread(target=self.periodic)
                self.periodic_thread.start()
            if(self.do_real_time and not self.measuring_real_time):
                self.measuring_real_time = True
                self.realtime()
                realtimethread = threading.Thread(target=self.realtime)
                realtimethread.start()
            
            # TODO: Use algorithm to produce data
            # TODO: Use MQTT to send periodic data to the server
             
# Main Loop
def main():
    device = Imfresh()

if __name__ == '__main__':
    main()