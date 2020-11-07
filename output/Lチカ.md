# Lチカ

## 必要なパーツ

| メーカー | 秋月 通販コード | 型番 | 商品名 | 個数 |
|--|--|--|--|--:|
| OptoSupply | I-11577 | OSR5JA3Z74A | 赤色LED | 1 |
| FAITHFUL LINK INDUSTRIAL CORP. | R-25102 | CF25J1KB | カーボン抵抗（炭素皮膜抵抗）　１／４Ｗ　1KΩ | 1 |

## 配線

今回は GPIO 21 番ピンを使用します。
LED と 1K 抵抗を用いて次の配線図の通りに配線します。

LEDの足が長い方がアノード(+)で短い方がカソード(-)です。

<img src='https://raw.githubusercontent.com/libertyfish-co/ruby-hw/master/images/l_chika.png' alt='Lチカ 回路図' width="350" />

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

## Let's try

* 21番ピンを使用しましたが、別のピンに接続して、コードを変更してみましょう。
* 点滅の間隔を変更してみましょう。
