require "gpio"
require "i2c"
require "adafruit_pcf8523"
require "time"
require "uart"

led = GPIO.new(25, GPIO::OUT)
rtc = PCF8523.new(unit: :RP2040_I2C0, sda_pin: 4, scl_pin: 5)
uart = UART.new(unit: :RP2040_UART0, tx_pin: 0, rx_pin: 1, baud: 115200)

uart.write "\r\nCurrent time: #{rtc.current_time}\r\n"
uart.write "Input time in `yyyy mm dd hh mm ss` of blank if you don't update\r\n"
uart.write "> "
input = ""
while (c = uart.read(1))
  uart.write c
  input << c
  next if c != "\n"
  input.chomp!
  if input.empty?
    uart.write "Time not updated\r\n"
    break
  else
    begin
      time = Time.new(*input.split(" ").map{|e|e.to_i})
    rescue
      uart.write "Invalid time format\r\n"
      uart.write "> "
      next
    end
    rtc.cuttent_time = time
    Time.hwclock = time
    uart.write "Time updated: #{rtc.current_time}\r\n"
    break
  end
end

while
  sleep 1
  led.write 1
  uart.write "Current time: #{rtc.current_time}\r\n"
  sleep 1
  led.write 0
end

