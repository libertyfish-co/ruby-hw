require 'pi_piper'

class Ta7291p
  attr_reader :forward_pin, :back_pin

  def initialize(pwm_pin_id:, forward_pin_id:, back_pin_id:, power_value: 0.5)
    @pwm_pin = pwm = PiPiper::Pwm.new pin: pwm_pin_id
    @forward_pin = PiPiper::Pin.new pin: forward_pin_id, direction: :out
    @back_pin = PiPiper::Pin.new pin: back_pin_id, direction: :out
    @power = power_value
    @pwm_pin.value = power_value
  end

  def power=(value)
    @power = value
    @pwm_pin.value = value
  end

  def power
    @power
  end

  def forward()
    @forward_pin.on
  end

  def back()
    @back_pin.on
  end

  def breake()
    @forward_pin.off
    @back_pin.off
  end
end