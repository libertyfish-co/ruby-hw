# RaspberryPi初期設定

## SSH設定

1. [Raspberry PiにNOOBSでOSをインストールする方法](https://raspida.com/raspixnoobs) を参考にOSのインストールを行います。
1. 新しい Raspberry Pi はデフォルトで SSH が無効になっていますので、有効に変更します。
    1. ベリーマーク -> 設定 -> Raspberry Pi の設定 まで進みます。
    2. インターフェースタブ の SSH を有効に変更します。
1. `ssh pi@raspberrypi.local` or `ssh pi@IPアドレス` でログインします。

## Samba インストール

Raspberry Pi 上のファイルを編集するのに使用します。
[Ubuntu samba インストールチュートリアル](https://tutorials.ubuntu.com/tutorial/install-and-configure-samba) に従ってインストールします。

## SPI設定

SPIはRaspberryPiで採用されているデバイス間で、データ通信を行う方式です。
shell からは、`raspi-config`を実行することで設定変更が行えます。

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

# オーディオ出力の無効化

PWM(パルス信号) が RaspberryPi のオーディオと同じ回路を使用しています。 そのため、念のために RaspberryPi のオーディオ出力を無効化します。

```bash
sudo vi /boot/config.txt
```

```
# ...

#dtparam=audio=on # コメントアウトします

# ...
```

## rbenv インストール

まず、ライブラリーをインストールします。

```bash
sudo apt install -y libssl-dev libreadline-dev
```

あとは [ubuntu + rbenvでrubyをインストール](https://qiita.com/tanagoda/items/44d12ef0d52b2dc9d560) を参考にインストールします。

## sudo権限付与

**※この設定は任意です。piユーザー以外を使用する場合に必要です**

ユーザー `pi` 以外で開発する場合は、 `sudo` 権限の付与が必要です。
`pi` には既に `sudo` 権限が割り当てられています。

今回は、`edu` ユーザーに管理者権限を割り当てます。 `edu` 部分を読み替えてください。

1. `ssh edu@raspberrypi.local` で `edu` ユーザーで ssh ログインする(ホスト名は適宜変更)
1. `su pi -` で `pi` ユーザーでログインする
1. `sudo su -` で `root` になる
1. `echo "edu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/010_edu-nopasswd` でパスワードなしで `sudo` ができるようする
1. `exit` で `root` からログアウト
1. `exit` で `pi`からログイアウト
1. `sudo ls /root` でエラーが表示されなければ、正しく設定されている

## 開発環境整備

`bundle install` でドキュメント類をインストールしない設定を行います。

```bash
echo 'gem: --no-rdoc --no-ri' > ~/.gemrc
```

Rasbery Pi から GPIO にアクセスするためには、`sudo` を行う必要がありますので、`bundler`から`sudo`を実行可能にするためのプラグインをインストールします。

```bash
git clone https://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo
```

## Node.js インストール

`rails new` を実行すると Node.js が必要になるのでインストール

```bash
sudo apt-get install nodejs
```
