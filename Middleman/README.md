# Middleman Library

# Methods

## Initialisation

The following is an example of a `Middleman` instance being created, unimaginatively named `middleman`.

```python
middleman = Middleman()
```

NOTE: The path of the libraries are relative to where the file is being run, not where the file is located.

## Collect Data

The method `collect_data()` returns all the necessary data required in a tuple. The following is an example of it being called by the `middleman` instance.

```python
(co2, voc, temp, humidity, ambient_temp, error) = middleman.collect_data()
```

## Data range

CCS811 Air Quality Sensor
1. co2 (equivalent calculated carbon dioxide concentration): 400-8192ppm
2. voc (Total Volatile Organic Compound): 0-1187ppb

TMP006 Temperature Sensor

3. temp (Temperature): -40 - +125°C

SI7021

4. Humidity: 0-80%
5. ambient_temp (Ambient Temperature): -10 - +85°C

## Error Codes

Each bit in the error code represents an independent error. They are normally all 0's, but the relevant bit(s) is toggled to 1 upon an error. By design, these errors do not disturb the operation of the devices.

"Out of range" errors automatically reset to 0 when the value returns within the range.

| Sensor  | Bit  | Error |
|---|---|---|
| CCS811  | 9  | Data out of range.  |
| CCS811  | 8  | Hardware ID or version is incorrect. |
| CCS811  | 7  | I2C error. |
| CCS811  | 6  | No valid firmware application is loaded. |
| TMP006  | 5  | Data out of range.   |
| TMP006  | 4  | Manufacturer or device ID is incorrect.  |
| TMP006  | 3  | Operation mode is invalid. For example, configuration register specified inactive, or invalid ADC (analogue digital conversion) rates.  |
| SI7021  | 2  | Data out of range.  |
| SI7021  | 1  | Device ID incorrect.  |
| SI7021  | 0  | Invalid device firmware.  |
