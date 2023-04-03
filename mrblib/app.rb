require "gpio"
require "i2c"
require "adafruit_pcf8523"
require "time"
require "uart"

ENV = Hash.new
ENV['TZ'] = 'JST-9'

uart = UART.new(unit: :RP2040_UART0, txd_pin: 0, rxd_pin: 1, baudrate: 115200)
uart.write "\r\n\r\nInitializing...\r\n\r\n"

begin
  led = GPIO.new(25, GPIO::OUT)
  rtc = PCF8523.new(unit: :RP2040_I2C0, sda_pin: 4, scl_pin: 5)
rescue => e
  uart.write "Error: #{e}\r\n"
  uart.write "#{e.message}\r\n"
end

uart.write "\r\nCurrent time: #{rtc.current_time}\r\n"
uart.write "Input time in `yyyy mm dd hh mm ss` or leave blank if you don't update\r\n"
uart.write "> "
line = ""
while true
  case c = uart.read(1)
  when nil
    next
  else
    uart.write c # echo back
    if c != "\n"
      line << c
    else
      line.chomp!
      if line.empty?
        uart.write "Time not updated\r\n"
        break
      else
        begin
          time = Time.new(*line.split(" "))
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
end

uart.write "\r\nStarting loop\r\n\r\n"

while true
  sleep 1
  led.write 1
  uart.write "Current time: #{rtc.current_time}\r\n"
  sleep 1
  led.write 0
end

