# PicoRuby RP2040 Peripheral Demo

## Prerequisites

- CMake
- [raspberrypi/pico-sdk](https://github.com/raspberrypi/pico-sdk)
  - tag 1.5.0
  - PICO_SDK_PATH
- Raspberry Pi Pico
  - Other RP2040 boards should work making sure to connect appropriate pins

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

[^1]: Optional. Connect if you want to supply bus power from the cable

[^2]: 3V3 also should work though, 5V would be better for the reliability of switching over from battery


## Build

`git clone` this repo and `cd` into it.

Then,

```console
rake
```

## Install and run

- Install `build/PicoRuby-RP2040-Peripheral-Demo.uf2` into RP2040
- Connect the USB serial cable to the host PC
- Open a serial terminal with values below:
    |entry|value|
    |----|----|
    |Baudrate|115200|
    |Data bits|8|
    |Stop bits|1|
    |Parity|none|
    |Flow control|none|
- Start RP2040 by connecting a power of pushing the reset button

## Usage

You can figure it out in `mrblib/app.rb`

https://user-images.githubusercontent.com/8454208/229503048-495847fb-8f55-48de-8517-5a005ec301a6.mp4
