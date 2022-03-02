# CluelessIoT: ImFresh

## Start

Run `python3 ./ImFresh.py` to initialise connections to the Raspberry Pi Zero and the AWS MQTT server. This also starts storing data in the local sqlite database.

## Folder structure

1. Hardware Libraries
   1. Alarm: hardware buzzer
   2. CCS811: Air quality sensor
   3. SI7021: Temperature and humidity sensor
   4. TMP006: Temperature sensor
2. Middleman: Collates readings from all 3 sensors.
3. `/imfresh`: Flutter app for displaying statistics and configuring device settings, such as measurement intervals.
4. `Imfresh.py`: Master file to initialise connections to the Raspberry Pi Zero. Depending on the command sent from the app, this will put the device in real time mode or periodic mode, which returns averaged data to the server for statistics.

## Marketing Material

1. Promotional video: https://www.youtube.com/watch?v=jqBLdhIyjRM
2. Website: https://yannichau.wixsite.com/imfresh/

## Hardware connections on Raspberry Pi

- 3V3, GND: connections to VCC/3V3 and GND for all devices
- SCL, SDA: connections to SCL and SDA of TMP006 Temperature Sensor
- 23: Acts as an SDA for the CCS811 and SI7021 sensors
- 24: Acts as an SCL for the CCS811 and SI7021 sensors
- 17: Simple output for the buzzer