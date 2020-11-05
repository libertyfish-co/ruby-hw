require 'pi_piper'

pin_in1 = PiPiper::Pin.new pin: 20, direction: :out
pin_in2 = PiPiper::Pin.new pin: 21, direction: :out
vref = PiPiper::Pwm.new pin: 18

# スピードを設定
vref.off
vref.value = 6
vref.on

# 正転
pin_in1.on
pin_in2.off
sleep 2

# 逆転
pin_in1.off
pin_in2.on
sleep 2

# 後片付け
vref.off
pin_in1.off
pin_in2.off
