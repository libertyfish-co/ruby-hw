require 'pi_piper'

pin_l = PiPiper::Pin.new pin: 21, direction: :out

loop do
  pin_l.on
  sleep 1
  pin_l.off
  sleep 1
end
