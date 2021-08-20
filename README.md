# Ruby ハードウェアプログラミング体験教材

これは、Ruby で RasperryPi に接続された電子部品を使用して遊ぶ教材です。

RasperryPi を全く触ったことがない場合は、 [RaspberryPiの基本知識](RaspberryPiの基本知識.md){:target='_blank'} を参考にしながら、電子部品をピンに刺してください。
電子工作の経験がない方は、 [用語集](用語集.md){:target='_blank'} を参考にすると理解が進みます。

教材の、[必要な設定](#必要な設定) が終われば、まずは、[Lチカ](output/Lチカ.md) から実践するのがおすすめです。
各教材ページには、教材作成に用いたパーツを記載しておりますので、参考にしてください。

## 教材を進めるために最低限必要なパーツ

### RasperryPi

いずれかの商品を購入します。

* RasberryPi 3 B+
* Raspberry Pi 4 Model B

**RasberryPi 3 B+ はプレミアム価格になっている可能性があります。**

### パーツ類

記載している製品は同等のものであれば代替えが可能です。

| メーカー | 秋月 通販コード | 型番 | 商品名 | 備考 |
|--|--|--|--|--|
| SanDisk | - | SDSQUNS-032G-GN3MN | SanDisk microSDHC ULTRA 32GB 80MB/s SDSQUNS-032G Class10 サンディスク | 8GB以上の容量が必要 |
| Cixi Wanjie Electronic Co.,Ltd | P-05294 | BB-801 | ブレッドボード | |
| Herwell Asia Limited | C-08932 | DG01032-0024-BK-015 | ブレッドボード・ジャンパーワイヤ（オス－メス）　１５ｃｍ（黒） | |
| Cixi Wanjie Electronic Co.,Ltd | C-05159 | BBJ-65 | ブレッドボード・ジャンパーワイヤ（オス－オス）セット　各種 合計６０本以上 | |

## 教材

### 必要な設定

RaspberryPiの初期設定が必要なので、 [RaspberryPi初期設定](RaspberryPi初期設定.md) を参考に設定します。

各教材を進めるために、 [プロジェクトフォルダ作成](プロジェクトフォルダ作成.md) を行ってください。

### 出力系

* [Lチカ](output/Lチカ.md)
* [圧電スピーカー](output/圧電スピーカー.md)
* [モーターを動かす](output/モーターを動かす.md)
* [モーターを正転・逆転する](output/モーターを正転・逆転する_2.md)

### 入力系

* [スイッチ入力](input/スイッチ入力.md)
* [フォトトランジスターとADコンバーターの説明](input/フォトトランジスターとADコンバーターの説明.md)
* [フォトトランジスターから値取得](input/フォトトランジスターから値取得.md)
* [距離センサーとADコンバーターの説明](input/距離センサーとADコンバーターの説明.md)
* [距離センサーから値を取得](input/距離センサーから値を取得.md)
* [Railsアプリにセンサーの値を表示](input/Railsアプリにセンサーの値を表示.md)

### 応用

* [クローラーを動かす](practical_use/クローラーを動かす.md)
* [WEBラジコン作成](web_radio_controller/WEBラジコン作成.md)
* [帰宅時に挨拶する](practical_use/帰宅時に挨拶する.md)
* [IRラジコン作成](ir_radio_controller/IRラジコン作成.md)
