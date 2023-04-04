require "gpio"
require "i2c"
require "adafruit_pcf8523"
require "time"
require "uart"
require "adc"

ENV = Hash.new
ENV['TZ'] = 'JST-9'

uart = UART.new(unit: :RP2040_UART0, txd_pin: 0, rxd_pin: 1, baudrate: 115200)
uart.write "\r\n\r\nInitializing...\r\n\r\n"
sleep 1

begin
  led = GPIO.new(25, GPIO::OUT)
  rtc = PCF8523.new(unit: :RP2040_I2C0, sda_pin: 4, scl_pin: 5)
  adc = ADC.new(:temperature)
rescue => e
  uart.write "Error: #{e}\r\n"
  uart.write "#{e.message}\r\n"
end

uart.write "Input time in `yyyy mm dd hh mm ss`\r\n"
uart.write "> "
line = ""
while true
  case c = uart.read(1)
  when nil
    next
  else
    line << c
    uart.write c # echo back
    if c == "\n"
      line.chomp!
      begin
        time = Time.local(*line.split(" "))
        rtc.current_time = time
        Time.hwclock = time
        uart.write "Time updated: #{rtc.current_time}\r\n"
        break
      rescue
        uart.write "Invalid time format\r\n"
        uart.write "(again)> "
        line.clear
        next
      end
    end
  end
end

uart.write "\r\nStarting loop\r\n\r\n"

ADC_CONVERSION_FACTOR = 3.3 / (1<<12)

while true
  sleep 1
  led.write 1
  uart.write "Current time: #{rtc.current_time}\r\n"
  uart.write "Temperature: #{27 - (adc.read * ADC_CONVERSION_FACTOR - 0.706) / 0.001721} C\r\n"
  sleep 1
  led.write 0
end
