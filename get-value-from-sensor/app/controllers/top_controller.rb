class TopController < ApplicationController
  def show
    @sensor_value = SensorReader.read
    @sensor_value = 'Communication was tried to a sensor, but I failed.' if @sensor_value.nil?
  end
end
