# RaspberryPi初期設定

## SSH設定

1. [Raspberry PiにNOOBSでOSをインストールする方法](https://raspida.com/raspixnoobs) を参考にOSのインストールを行います。
1. 新しい Raspberry Pi はデフォルトで SSH が無効になっていますので、有効に変更します。
    1. ベリーマーク -> 設定 -> Raspberry Pi の設定 まで進みます。
    2. インターフェースタブ の SSH を有効に変更します。

## Samba インストール

Raspberry Pi 上のファイルを編集するのに使用します。
[Ubuntu samba インストールチュートリアル](https://tutorials.ubuntu.com/tutorial/install-and-configure-samba) に従ってインストールします。

## SPI設定

SPIはRaspberryPiで採用されているデバイス間で、データ通信を行う方式です。
shell からは、`rsspi-config`を実行することで設定変更が行えます。

```bash
sudo raspi-config
```

`5 Interfacing Options` -> `P4 SPI` -> `Yes`

RaspberryPi を再起動します。

```bash
sudo reboot
```

正しく設定されていることを確認します。

```bash
ls /dev/spi*
```

次の通り表示されれば正しく設定されています。

```
/dev/spidev0.0  /dev/spidev0.1
```

## rbenv インストール

まず、ライブラリーをインストールします。

```bash
sudo apt install -y libssl-dev libreadline-dev
```

あとは [ubuntu + rbenvでrubyをインストール](https://qiita.com/tanagoda/items/44d12ef0d52b2dc9d560) を参考にインストールします。

## 開発環境整備

`bundle install` でドキュメント類をインストールしない設定を行います。

```bash
echo 'gem: --no-rdoc --no-ri' > ~/.gemrc
```

Rasbery Pi から GPIO にアクセスするためには、`sudo` を行う必要がありますので、`bundler`から`sudo`を実行可能にするためのプラグインをインストールします。

```bash
git clone https://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo
```
