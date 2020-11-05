# coding: utf-8
require 'pi_piper'

def convert_volt(data, vref)
  volt = (data * vref) / 1023
  volt.round(4)
end

def convert_lx(volt)
  volt / 0.0003
end

def read(channel)
  PiPiper::Spi.begin do |spi|
    adc = spi.write [0b0001, (0b1000 + channel) << 4, 0b0000]
    # adc = spi.write [0x1, (0x8 + channel) << 4, 0x0]
    ((adc[1] & 0b0011) << 8) + adc[2]
    #((adc[1] & 0x3) << 8) + adc[2]
  end
end

VOLT = 5.0

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
  puts "volt = #{volt = convert_volt(brightness, VOLT)}"
  puts "lx = #{convert_lx(volt)}"
  sleep 3
end
