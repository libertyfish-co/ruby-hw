require 'pi_piper'

pin_motor = PiPiper::Pin.new pin: 20, direction: :out

loop do
  pin_motor.on
  sleep 1
  pin_motor.off
  sleep 1
end
