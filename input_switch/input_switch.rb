require 'pi_piper'

PiPiper.watch pin: 23 do |pin|
  pin.read
  puts "#{pin.last_value} -> #{pin.value}"
end

PiPiper.wait
