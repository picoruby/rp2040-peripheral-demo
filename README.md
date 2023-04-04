# PicoRuby RP2040 Peripheral Demo

## Peripherals

- GPIO: RP2040 on-board LED
- UART: FTDI USB to TTL Serial Adapter Cable (3.3V)
- I2C: PCF8523 RTC module
- ADC: RP2040 on-board temperature sensor

## Wiring

|Function|Raspi Pico|Peripheral|
|----|---------------|----------|
|GPIO|GPIO 25 (Connected internally)|LED|
|UART|GPIO 0|Serial Adapter RX (Yellow)|
|UART|GPIO 1|Serial Adapter TX (Orange)|
|UART|GND|Serial Adapter GND (Black)|
||VBUS(5V)|Serial Adapter VCC (Red)[^1]|
|I2C|GPIO 4|PCF8523 SDA|
|I2C|GPIO 5|PCF8523 SCL|
|I2C|GND|PCF8523 GND|
|I2C|VBUS(5V)[^2]|PCF8523 VCC|
|ADC|ADC4 (Connected internally)|Temperature sensor|

[^1]: Optional. Connect if you want to supply bus power from the cable

[^2]: 3V3 also should work though, 5V would be better for the reliability of switching over from battery

## Build by yourself or use a release binary

### Prerequisites

- CMake
- [raspberrypi/pico-sdk](https://github.com/raspberrypi/pico-sdk)
  - tag 1.5.0
  - PICO_SDK_PATH
- Raspberry Pi Pico
  - Other RP2040 boards should work making sure to connect appropriate pins

### Build

`git clone` this repo and `cd` into it.

```console
rake
```

Then you'll get `build/PicoRuby-RP2040-Peripheral-Demo.uf2`.

## Install and run

- Install `PicoRuby-RP2040-Peripheral-Demo.uf2` into RP2040
- Connect the USB serial cable to the host PC
- Open a serial terminal with values below:
    |entry|value|
    |----|----|
    |Baudrate|115200|
    |Data bits|8|
    |Stop bits|1|
    |Parity|none|
    |Flow control|none|
- Start RP2040 by connecting a power or pushing the reset button

## Usage

You can figure it out in `mrblib/app.rb`

https://user-images.githubusercontent.com/8454208/229699464-78763c11-6912-41be-8f44-7c897a67a8be.mp4
