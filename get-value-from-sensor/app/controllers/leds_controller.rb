class LedsController < ApplicationController
  def on
    socket_access(true)
    render json: [ status: :ok ]
  end

  def off
    socket_access(false)
    render json: [ status: :ok ]
  end

  private

  def socket_access(led_flg)
    socket = TCPSocket.open('localhost', 2000)

    if led_flg
      socket.puts 'LED_ON'
    else
      socket.puts 'LED_OFF'
    end

    socket.flush
    response = socket.gets
    response if response.present?
  rescue
    nil
  ensure
    socket.close if socket
  end
end
