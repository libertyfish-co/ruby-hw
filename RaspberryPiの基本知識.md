# RaspberryPi基本知識

## Pin配置

* DC Power
  * 電源を給電・出力する
* Ground(GND)
  * 電気回路のマイナス(GND)をつなげる
* GPIO
  * プログラムから制御できるPin
* SPI
  * データ通信に用いる
* PWM
  * パルス信号を出力する
  * [PWMの詳しい説明](https://toshiba.semicon-storage.com/jp/semiconductor/knowledge/e-learning/brushless-motor/chapter3/what-pwm.html){: target="_blank"}
  * RaspberryPi は 2チャンネル用意されている。同じチャンネルは同一の周波数を出す。
    * channel 1: GPIO 12, 18
    * channel 2: GPIO 13, 19


![Pin配置](https://cdn-ak.f.st-hatena.com/images/fotolife/y/yuriai0001/20150524/20150524180432.png)
