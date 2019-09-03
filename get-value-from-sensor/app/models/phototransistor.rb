require 'pi_piper'

class Phototransistor
  VOLT = 5.0

  def self.lux
    value = read(0)
    volt = convert_volt(value)
    convert_lx(volt)
  end

  private

  def self.read(channel)
    PiPiper::Spi.begin do |spi|
      adc = spi.write [0x1, (0x8 + channel) << 4, 0x0]
      ((adc[1] & 0x3) << 8) + adc[2]
    end
  end

  def self.convert_volt(data)
    volt = (data * VOLT) / 1023
    volt.round(4)
  end

  def self.convert_lx(volt)
    volt / 0.0003
  end
end
