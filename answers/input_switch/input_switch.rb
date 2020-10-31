# coding: utf-8
require 'pi_piper'

switch_pin = PiPiper::Pin.new(pin: 21, direction: :in)
led_pin = PiPiper::Pin.new(pin: 18, direction: :out)

loop do
  switch_pin.read
  puts switch_pin.off?
  if switch_pin.on?
    led_pin.off
  else
    led_pin.on
  end
  sleep 0.5
end
