# Instructions for running the examples

## 1. Connect to Raspberry Pi

1. Local: COM7, 115200, Serial
2. Over the WiFi with SSH
   1. At (Yanni's) Home: 192.168.59.120
   2. At School: 146.169.xxx.xx (Will change)
3. File transfer via SCP protocol
4. Detect module

   ```bash
   sudo i2cdetect -y 1
   ```

## 2. Installations

```bash
pip3 install adafruit-circuitpython-busdevice
pip3 install adafruit-circuitpython-tmp006
```

## 3. Run

```bash
python3 example_tmp006.py
```
