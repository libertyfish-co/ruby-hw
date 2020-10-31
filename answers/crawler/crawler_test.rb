# coding: utf-8
require './ta7291p'
require './mcp3008'
require './gp2y0a21yk0f'

# モーター1
# GPIO 20 -> 正転?
# GPIO 21 -> 逆転?
# GPIO 12 -> PWM
@motor_1 = Ta7291p.new(12, 20, 21, 0.7)

# モーター2
# GPIO 5 -> 正転?
# GPIO 6 -> 逆転?
# GPIO 13 -> PWM
@motor_2 = Ta7291p.new(13, 5, 6, 0.7)

# ADコンバーター
mcp3008 = Mcp3008.new(0)

def kick_combo_motor
  [@motor_1, @motor_2].map do |motor|
    Thread.new { yield(motor) }
  end.each { |t| t.join }    
end

loop do
  # モーターを交互に動かす
  @motor_1.forward(2)
  @motor_2.forward(2)

  sleep 2

  # モーターを左右同時に動かす
  kick_combo_motor { |motor| motor.forward(2) }

  # センサーの値を取得する
  puts Gp2y0a21yk0f.volt_to_distance(mcp3008.read)

  sleep 2
end
