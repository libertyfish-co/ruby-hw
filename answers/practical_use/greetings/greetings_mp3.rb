require 'pi_piper'

sensor_pin = PiPiper::Pin.new(pin: 21, direction: :in, pull: :down)

loop do
  sensor_pin.read
  puts sensor_pin.on?
  if sensor_pin.on?
    # .wavファイルを再生する前に21番pinの利用を終了しておく
    unexp = open("/sys/class/gpio/unexport", "w")
    unexp.write(21)
    unexp.close
    
    # .wavファイルを再生 mpg321 => .mp3
    exec('sudo mpg321 gm_maoudamashii_8bit16.mp3')
  end
  sleep 0.5
end
