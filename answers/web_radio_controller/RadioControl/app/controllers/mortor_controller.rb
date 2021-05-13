class MortorController < ApplicationController
  protect_from_forgery
  def control
    function_name = params["control"]
    send_request(function_name)
    render json: [ status: :ok , control: function_name]
  end

  private

  def send_request(function_name)
    socket = TCPSocket.open('localhost', 2000)

    socket.puts function_name
    socket.flush
    response = socket.gets
    response if response.present?
  rescue
    nil
  ensure
    socket.close if socket
  end
end
