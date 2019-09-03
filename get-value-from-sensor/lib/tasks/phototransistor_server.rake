# coding: utf-8
require 'socket'

namespace :phototransistor_server do
  task wake_up: :environment do
    server_method
  end

  # サーバ接続 OPEN
  Serv = TCPServer.new(Settings.sensor.port)

  def server_method
    loop do
      # ソケット OPEN （クライアントからの接続待ち）
      sock = Serv.accept

      while msg = sock.gets
        msg.chomp!

        case msg
        when 'VALUE_REQUEST'
          puts "RECV: #{msg}"

          lux = Phototransistor.lux
          puts "SEND: #{lux}"

          # クライアントへ文字列返却
          sock.puts lux
        else
          puts "Unknown message type. Recived message: #{msg}"
        end
      end

      # ソケット CLOSE
      sock.close
    end
  end
end
