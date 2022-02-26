from time import sleep
from Middleman.SensorLibrary import Middleman
import paho.mqtt.client as mqtt
from datetime import datetime, timedelta
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
        self.id = "asu343ui41823jisdjajdio1jo2i"
        self.device_name = "Kitchen Imfresh"
        self.alarm_status = True
        self.alarm_time = datetime.fromisoformat('2022-01-01T12:00:00')
        self.device_location = "London"
        self.do_real_time = False
        self.measuring_real_time = False
        self.do_periodic = True
        self.measuring_periodic = False
        self.measurement_interval = 1
        self.measurement_times = []
        self.cleanliness_threshold = 1
        # Other Variables
        self.wash_day = datetime.fromisoformat('2022-02-28T12:00:00')
        self.next_time = datetime.fromisoformat('2022-01-01T12:00:00')
        self.prev_time = datetime.fromisoformat('2022-01-01T12:00:00')
        # Load current settings from config.yaml
        self.load_config()
        # Initialise library
        self.sensor_library = Middleman()
        # Initialise MQTT Client
        self.client = mqtt.Client("", True, None, mqtt.MQTTv31)
        # Initialise database
        self.data_con = sqlite3.connect('data.sqlite')
        data_cursor = self.data_con.cursor()
        data_cursor.execute("CREATE TABLE IF NOT EXISTS ImFreshData (time TIME, voc REAL, humidity REAL, temperature REAL, type TEXT)")
        self.data_con.commit()
        self.data_con.close()
        # Activate main loop for device
        self.activate()

    def load_config(self):
    # Load configuration from config.yaml
        with open('config.yaml', 'r') as file:
            config = yaml.safe_load(file)
            self.id = config["deviceId"] # string
            self.device_name = config["deviceName"] # string
            self.alarm_status = config["alarmStatus"] # bool
            self.alarm_time = datetime.fromisoformat(config["alarmTime"]) # string
            self.device_location = config["deviceLocation"] # string
            self.do_real_time = config["doRealTime"] # bool
            self.do_periodic = config["doPeriodic"] # bool
            self.measurement_interval = config["periodicMeasurementTimePeriod"] # int
            self.measurement_times = [datetime.fromisoformat(time) for time in config["periodicMeasurementTimes"]] # list of strings
            self.wash_day = datetime.fromisoformat(config["washDay"]) # string

    def save_config(self):
    # Save configuration to config.yaml
        with open('config.yaml', 'w') as file:
            config = {}
            config["deviceId"] = self.id # string
            config["deviceName"] = self.device_name # string
            config["alarmStatus"] = self.alarm_status # bool
            config["alarmTime"] = self.alarm_time.isoformat() # string
            config["deviceLocation"] = self.device_location # string
            config["doRealTime"] = self.do_real_time # bool
            config["doPeriodic"] = self.do_periodic # bool
            config["periodicMeasurementTimePeriod"] = self.measurement_interval # int
            config["periodicMeasurementTimes"] = [time.isoformat() for time in self.measurement_times] # list of strings
            config["washDay"] = self.wash_day.isoformat() # string
            yaml.dump(config, file)

    def record_data(self, voc, humidity, temperature, time, type):
    # Record data to database
        current_stamp = time.isoformat()
        self.data_con = sqlite3.connect('data.sqlite')
        data_cursor = self.data_con.cursor()
        data_cursor.execute("INSERT INTO ImFreshData VALUES(?, ?, ?, ?, ?)", (current_stamp, voc, humidity, temperature, type))
        self.data_con.commit()
        self.data_con.close()

    def average_data(self, type):
    # Calculate average data from temporary database values
        self.data_con = sqlite3.connect('data.sqlite')
        data_cursor = self.data_con.cursor()
        voc = 0
        humidity = 0
        temperature = 0
        temp_data = data_cursor.execute("SELECT * FROM ImFreshData WHERE type = ?", (type))
        if len(temp_data) == 0:
            self.data_con.close()
        else:
            for row in temp_data:
                voc += row[1]
                humidity += row[2]
                temperature += row[3]
            voc = voc / len(temp_data)
            humidity = humidity / len(temp_data)
            temperature = temperature / len(temp_data)
            data_cursor.execute("DELETE FROM ImFreshData WHERE type = ?", (type))
            self.data_con.commit()
            self.data_con.close()
        return (voc, humidity, temperature)

    def periodic(self):
    # Conduct periodic measurements
        while self.do_periodic:
            if datetime.now() > self.next_time + timedelta(hours=self.measurement_interval):
                no_time_available = True
                for new_time in self.measurement_times:
                    if datetime.now() < new_time + timedelta(hours=self.measurement_interval):
                        self.prev_time = self.next_time
                        self.next_time = new_time
                        no_time_available = False
                        break
                if no_time_available:
                    [timedelta(days=7) + time for time in self.measurement_times]
            elif datetime.now() > self.next_time - timedelta(minutes=20) and datetime.now() < self.next_time:
                self.sensor_library.collect_data()
            elif datetime.now() > self.next_time and datetime.now() < self.next_time + timedelta(hours=self.measurement_interval):
                (dc1, voc, dc2, humidity, temperature, errval) = self.sensor_library.collect_data()
                if(errval == 0):
                    voc = 50 if voc > 50 else voc
                    self.record_data(voc, humidity, temperature, datetime.now(), "PeriodicTemp")
                else:
                    print("Error: " + str(errval))
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
            (dc1, voc, dc2, humidity, temperature, errval) = self.sensor_library.collect_data()
            sleep(1)
            if(errval == 0):
                self.record_data(voc, humidity, temperature, datetime.now(), "RealTimeTemp")
                datapoint += 1
            else:
                print("Error: " + str(errval))
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
        self.client.subscribe(["IC.embedded/cluelessIoT"])
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