require 'pi_piper'

pwm = PiPiper::Pwm.new pin: 19, value: 0.2

loop do
  pwm.on
  sleep 0.5
  pwm.off
  sleep 0.5
end
