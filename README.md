# PicoRuby RP2040 Peripheral Demo

## Build

```console
rake
```

## Peripherals

- PCF8523 RTC module

- FTDI USB to TTL Serial Adapter Cable (3.3V)

## Wiring

|Raspi Pico|Peripheral|
|---------------|----------|
|GPIO 0|Serial Adapter RX|
|GPIO 1|Serial Adapter TX|
|GND|Serial Adapter GND|
|3V3|Serial Adapter VCC|
|GPIO 4|PCF8523 SDA|
|GPIO 5|PCF8523 SCL|
|GND|PCF8523 GND|
|VBUS(5V)|PCF8523 VCC|
