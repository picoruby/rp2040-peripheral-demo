# PicoRuby RP2040 Peripheral Demo

## Prerequisites

- CMake
- [raspberrypi/pico-sdk](https://github.com/raspberrypi/pico-sdk)
  - tag 1.5.0
  - PICO_SDK_PATH
- Raspberry Pi Pico
  - Other RP2040 boards should work making sure to connect appropriate pins

## Build

`git clone` this repo and `cd` into it.

Then,

```console
rake
```

## Peripherals

- PCF8523 RTC module

- FTDI USB to TTL Serial Adapter Cable (3.3V)

## Wiring

|Raspi Pico|Peripheral|
|---------------|----------|
|GPIO 0|Serial Adapter RX (Yellow)|
|GPIO 1|Serial Adapter TX (Orange)|
|GND|Serial Adapter GND (Black)|
|VBUS(5V)|Serial Adapter VCC (Red)[^1]|
|GPIO 4|PCF8523 SDA|
|GPIO 5|PCF8523 SCL|
|GND|PCF8523 GND|
|VBUS(5V)[^2]|PCF8523 VCC|

[^1]: Optional. Connect if you want to supply bus power from the host PC

[^2]: 3V3 also should work though, 5V would be better for the reliability of switching over from battery


