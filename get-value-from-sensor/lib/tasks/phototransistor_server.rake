# coding: utf-8
require 'socket'

namespace :phototransistor_server do
  task wake_up: :environment do
    server_method
  end

  # サーバ接続 OPEN
  Server = TCPServer.new(2000)

  def server_method
    loop do
      # ソケット OPEN （クライアントからの接続待ち）
      socket = Server.accept

      while token = socket.gets
        token.chomp!
        puts "RECV: #{token}"

        case token
        when 'VALUE_REQUEST'
          lux_value = lux
          puts "SEND: #{lux_value}"

          # クライアントへ文字列返却
          socket.puts lux_value
        when 'LED_ON'
          led_on(21)
          socket.puts 'on'
        when 'LED_OFF'
          led_off(21)
          socket.puts 'off'
        else
          puts "Unknown token type. Recived token: #{token}"
        end
      end

    ensure
      # ソケット CLOSE
      socket.close
    end
  end

  VOLT = 5.0
  LED_PIN = PiPiper::Pin.new pin: 21, direction: :out

  def lux
    value = read(0)
    volt = convert_volt(value)
    convert_lux(volt)
  end

  def read(channel)
    PiPiper::Spi.begin do |spi|
      adc = spi.write [0x1, (0x8 + channel) << 4, 0x0]
      ((adc[1] & 0x3) << 8) + adc[2]
    end
  end

  def convert_volt(data)
    volt = (data * VOLT) / 1023
    volt.round(4)
  end

  def convert_lux(volt)
    volt / 0.0003
  end

  def led_on(pin)
    LED_PIN.on
  end

  def led_off(pin)
    LED_PIN.off
  end
end
