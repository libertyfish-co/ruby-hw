class TopController < ApplicationController
  def show
    @sensor_value = read
    @sensor_value = 'Communication was tried to a sensor, but I failed.' if @sensor_value.nil?
  end

  def read
    socket = TCPSocket.open('localhost', 2000)

    socket.puts 'VALUE_REQUEST'
    socket.flush
    response = socket.gets
    response if response.present?
  rescue
    nil
  ensure
    socket.close if socket
  end
end
