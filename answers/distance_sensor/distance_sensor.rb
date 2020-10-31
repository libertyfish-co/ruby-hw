# coding: utf-8
require 'pi_piper'

def volt_to_distance(volt)
  return 0 if volt == 0

  dist = (6787 / (volt - 3)) - 4
  dist.round(4)
end

def read(channel)
  PiPiper::Spi.begin do |spi|
    adc = spi.write [0b0001, (0b1000 + channel) << 4, 0b0000]
    # adc = spi.write [0x1, (0x8 + channel) << 4, 0x0]
    ((adc[1] & 0b0011) << 8) + adc[2]
    #((adc[1] & 0x3) << 8) + adc[2]
  end
end

loop do
  distance = volt_to_distance(read(0))
  case distance
  when 0..20
    puts "近すぎる(#{distance})"
  when 21..70
    puts "ちょうど良い(#{distance})"
  when 71..nil
    puts "遠すぎる(#{distance})"
  end
  sleep 3
end
