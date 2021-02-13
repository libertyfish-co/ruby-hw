class MortorController < ApplicationController
  def forward
    send_request("Forward")
    render json: [ status: :ok ]
  end

  def left
    send_request("Left")
    render json: [ status: :ok ]
  end

  def right
    send_request("Right")
    render json: [ status: :ok ]
  end

  def back
    send_request("Back")
    render json: [ status: :ok ]
  end

  def breake
    send_request("Breake")
    render json: [ status: :ok ]
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
