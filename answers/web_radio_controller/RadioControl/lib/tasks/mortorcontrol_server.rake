require 'socket'
require './lib/components/ta7291p'

namespace :mortorcontrol_server do
  task wake_up: :environment do
    server_method
  end

  # モーター左
  # GPIO 20 -> 正転?
  # GPIO 21 -> 逆転?
  # GPIO 12 -> PWM
  @motor_left = Ta7291p.new(12, 20, 21, 0.7)
  
  # モーター右
  # GPIO 5 -> 正転?
  # GPIO 6 -> 逆転?
  # GPIO 13 -> PWM
  @motor_right = Ta7291p.new(13, 5, 6, 0.7)
  
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
        when 'Forward'
          forward()
          puts_result(token, socket)
        when 'Left'
          left()
          puts_result(token, socket)
        when 'Right'
          right()
          puts_result(token, socket)
        when 'Back'
          back()
          puts_result(token, socket)
        when 'Breake'
          breake()
          puts_result(token, socket)
        else
          puts "Unknown token type. Recived token: #{token}"
        end
      end

    ensure
      # ソケット CLOSE
      socket.close
    end
  end

  private
  
  def puts_result(recived_request, socket)
    puts recived_request
    socket.puts "OK"
  end

  def forward()
    @motor_left.forward()
    @motor_right.forward()
  end

  def left()
    @motor_left.back()
    @motor_right.forward()
  end

  def right()
    @motor_left.forward()
    @motor_right.back()
  end

  def back()
    @motor_left.back()
    @motor_right.back()
  end

  def breake()
    @motor_left.breake()
    @motor_right.breake()
  end

end
