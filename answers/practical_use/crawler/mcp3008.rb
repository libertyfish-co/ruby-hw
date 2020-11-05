require 'pi_piper'

class Mcp3008
  attr_reader :channel

  def initialize(channel)
    @channel = channel
  end

  def read
    PiPiper::Spi.begin do |spi|
      adc = spi.write [0x1, (0x8 + @channel) << 4, 0x0]
      ((adc[1] & 0x3) << 8) + adc[2]
    end
  end
end
