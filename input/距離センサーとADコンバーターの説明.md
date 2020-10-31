# 距離センサーとADコンバーターの説明

今回使用する機材は次の通りです。

* [距離センサー](../用語集.md#距離センサー(測距センサー))
  * 赤外線を出して、赤外線検知機で受け取り、帰ってきた赤外線の量によって、距離を測定します。
  * 今回使用するセンサーは [GP2Y0A21YK0F](https://www.mouser.jp/datasheet/2/365/gp2y0a21yk_e-1149917.pdf) です。
* [ADコンバーター](../用語集.md#ADコンバーター(AD変換器))
  * RaspberryPi はアナログ信号を受け取ることができない。デジタル信号のみ取得できる。アナログ信号をデジタル信号に置き換えるパーツ。
  * [MCP3008](http://ww1.microchip.com/downloads/en/DeviceDoc/21295d.pdf)

## 距離センサー

[GP2Y0A21YK0F のデータシート](https://www.mouser.jp/datasheet/2/365/gp2y0a21yk_e-1149917.pdf) の `Fig. 2 Example of distance measuring characteristice(output)` を参考にします。
このセンサーは、 10 〜 80 cm までの距離が測れます。 0 〜 10 cm の間は、近い距離と遠い距離で同じ電圧になるのでどちらの距離かわからないので、 0 〜 10 cm の距離は測れません。

<img src='https://raw.githubusercontent.com/libertyfish-co/ruby-hw/images/documents/GP2Y0A21YK0F_volt_graph1.png' alt='Example of distance measuring characteristice' width="400" />

## ADコンバーター

MCP3008 は 8ch のセンサー入力端子を持っています。
それぞれの、入力端子にフォトトランジスターなどのセンサーを取り付けます。

詳しい説明は 「[「SPI」の解説](https://synapse.kyoto/glossary/glossary.php?word=SPI)」をご覧ください。
