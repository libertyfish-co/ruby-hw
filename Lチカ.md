# Lチカ

## 配線

今回は GPIO 21 番ピンを使用します。
LED と 1K 抵抗を用いて次の配線図の通りに配線します。

LEDの足が長い方がアノード(+)で短い方がカソード(-)です。

<img src='https://raw.githubusercontent.com/libertyfish-co/ruby-hw/images/l_chika.png' alt='Lチカ 回路図' width="350" />

## コーディング

`l_chika.rb` を作成します。

```ruby
require 'pi_piper'

pin_l = PiPiper::Pin.new(pin: 21, direction: :out) # `21`番ピンを出力用として準備しています。

loop do
  pin_l.on    # 21番ピンに電流を流す
  sleep 0.5   # 0.5秒の間、実行を停止
  pin_l.off   # 21番ピンに電流を流す
  sleep 0.5
end
```

次のコマンドを実行すれば、LEDが点滅します。

```bash
rbenv sudo bundle exec ruby l_chika.rb
```

終了するには、`Ctrl + C` を押下します。

## やってみよう

* 21番ピンを使用しましたが、別のピンに接続して、コードを変更してみましょう。
* 点滅の間隔を変更してみましょう。
