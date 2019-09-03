# フォトトランジスターとADコンバーターの説明

今回使用する機材は次の通りです。

* [フォトトランジスター](用語集.md#フォトトランジスタ(照度センサー))
  * 光の量によって、流す電気の量を変動させる。
  * [NJL7502L](https://www.njr.co.jp/products/semicon/PDF/NJL7502L_J.pdf)
* [ADコンバーター](用語集.md#ADコンバーター(AD変換器))
  * RaspberryPi はアナログ信号を受け取ることができない。デジタル信号のみ取得できる。アナログ信号をデジタル信号に置き換えるパーツ。
  * [MCP3008](http://ww1.microchip.com/downloads/en/DeviceDoc/21295d.pdf)

## フォトトランジスター

[NJL7502L のデータシート](https://www.njr.co.jp/products/semicon/PDF/NJL7502L_J.pdf)の `NJL7502L Light Source` を参考にします。
5Vの電源に対して、どの抵抗値で幾つの電圧をカソードに流すかが記載されています。
例えば 500Ωの抵抗を使った場合に、1000Lx(ルクス)の光が当たった場合は、大体 0.25 Vの電圧が流れることになります。

<img src='https://raw.githubusercontent.com/libertyfish-co/ruby-hw/images/documents/NJL7502L_volt_graph.png' alt='NJL7502L Light Source' width="400" />

## ADコンバーター

MCP3008 は 8ch のセンサー入力端子を持っています。
それぞれの、入力端子にフォトトランジスターなどのセンサーを取り付けます。

詳しい説明は 「[「SPI」の解説](https://synapse.kyoto/glossary/glossary.php?word=SPI)」をご覧ください。
