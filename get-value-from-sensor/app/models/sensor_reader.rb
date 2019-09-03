require 'socket'

class SensorReader
  def self.read
    socket = TCPSocket.open(Settings.sensor.ip_address, Settings.sensor.port)

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
