# coding: utf-8
require 'pi_piper'

def read(channel)
  PiPiper::Spi.begin do |spi|
    adc = spi.write [0x1, (0x8 + channel) << 4, 0x0]
    (((adc[1] & 0x3) << 8) + adc[2])
  end
end

loop do
  brightness = read(0)
  case brightness
  when 0..100
    puts "暗い(#{brightness})"
  when 101..250
    puts "普通(#{brightness})"
  when 251..Float::INFINITY
    puts "明るい(#{brightness})"
  end
  sleep 3
end
