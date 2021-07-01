require 'pi_piper'

sensor_pin = PiPiper::Pin.new(pin: 21, direction: :in, pull: :down)

loop do
  sensor_pin.read
  puts sensor_pin.on?
  if sensor_pin.on? # センサーがON(近い)?
    # .wavファイルを再生する前に21番pinの利用を終了しておく
    unexp = open("/sys/class/gpio/unexport", "w")
    unexp.write(21)
    unexp.close
    
    # .wavファイルを再生 aplay => .wav
    exec('sudo aplay se_maoudamashii_onepoint12.wav')
  end
  sleep 0.5
end
