# Railsアプリにセンサーの値を表示

これまでのプログラムでは、センサーと RaspberryPi のみで完結していました。今回は Webブラウザでセンサーの値を表示してみましょう。
Web ブラウザで表示するには、 Webサーバーを起動します。Webサーバーは不特定数多数のユーザーからアクセスされるため、セキュリティ上の理由で、物理サーバーを分ける必要があります。今回は、センサーから値を取得するプログラムと Webサーバーを RaspberryPi の上で両方起動します。
Webサーバーには Rails を使用します。

Webサーバーと センサープログラム間は別のサーバーでネットワークでは繋がっていると仮定します。
ネットワークで繋がっているので、 TCPSocket を利用します。

## 注意

本工程では、TCPSocket でポートをオープンしたり、ハードウェアに繋がったWebアプリを起動することになります。
認証の機構を設ける等、対策が必要です。
今回はテストプログラムなので、考慮していません。

## 配線

[フォトトランジスターから値取得](フォトトランジスターから値取得.md)

## Rails アプリ作成

### `bundle init`

```bash
cd ~/
mkdir get-value-from-sensor ; cd $_
bundle init
```

### Gemfile 編集

```ruby
# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "rails" # ここのコメントアウトを外します。
```

```bash
bundle install --path vendor/bundle
# かなり時間がかかります
```

### `rails new`

```bash
bundle exec rails new . --skip-yarn --skip-coffee --skip-javascript --skip-webpack-install
# 途中で Gemfile を上書きするか確認されますが、 Enter キーを押下する
# かなり時間がかかります
```

### 設定

`Gemfile` の最後に次の行を追加します。

```ruby
gem 'pi_piper' # => PiPiper を使用するので追加
```

追加した gem をインストールします。

```bash
bundle install
```

### センサーサーバー作成

#### `phototransistor_server` タスク

このタスクは、TCP 2000番ポートで通信を待ち受けて、クライアントから `VALUE_REQUEST` のトークンが送られた場合に、フォトトランジスターの値を返します。

まず、コンソールでタスクのファイルを作成します。

```bash
bundle exec rails generate task phototransistor_server
```

`lib/tasks/phototransistor_server.rake` が作成されているので、以下の通り修正します。

```ruby
require 'socket'

namespace :phototransistor_server do
  task wake_up: :environment do
    server_method
  end

  # サーバ接続 OPEN
  Server = TCPServer.new(2000)

  def server_method
    loop do
      # ソケット OPEN （クライアントからの接続待ち）
      socket = Server.accept

      while token = socket.gets
        token.chomp!

        case token
        when 'VALUE_REQUEST'
          puts "RECV: #{token}"

          lux_value = lux
          puts "SEND: #{lux_value}"

          # クライアントへ文字列返却
          socket.puts lux_value
        else
          puts "Unknown token type. Recived token: #{token}"
        end
      end

    ensure
      # ソケット CLOSE
      socket.close
    end
  end

  VOLT = 5.0

  def lux
    value = read(0)
    volt = convert_volt(value)
    convert_lux(volt)
  end

  def read(channel)
    PiPiper::Spi.begin do |spi|
      adc = spi.write [0x1, (0x8 + channel) << 4, 0x0]
      ((adc[1] & 0x3) << 8) + adc[2]
    end
  end

  def convert_volt(data)
    volt = (data * VOLT) / 1023
    volt.round(4)
  end

  def convert_lux(volt)
    volt / 0.0003
  end
end
```

ここまでできたら、動作確認をします。ターミナルを2つ立ち上げて、1つでは、「センサーサーバー」をもう一つでは、「`rails console`」 を起動します。
`rails console` でTCPサーバーにアクセスして、応答が返ってくるか確認します。

1つめ

```bash
cd ~/get-value-from-sensor
rbenv sudo bundle exec rails phototransistor_server:wake_up
```

2つめ

```bash
cd ~/get-value-from-sensor
bundle exec rails console

socket = TCPSocket.open('localhost', 2000)
socket.puts 'VALUE_REQUEST'
socket.flush
socket.gets
socket.close
```

### センサーの内容を表示するトップページの作成

TopPageを作成するために、次のコマンドを入力します。

```bash
bundle exec rails generate controller Top show
```

`app/controllers/top_controller.rb` を修正してフォトトランジスターから値を取得して、Viewに渡すインスタンスを作成します。

```ruby
class TopController < ApplicationController
  def show
    @sensor_value = read
    @sensor_value = 'Communication was tried to a sensor, but I failed.' if @sensor_value.nil?
  end

  def read
    socket = TCPSocket.open('localhost', 2000)

    socket.puts 'VALUE_REQUEST'
    socket.flush
    response = socket.gets
    response if response.present?
  rescue
    nil
  ensure
    socket.close if socket
  end
end
```


`app/views/top/show.html.erb` を修正して `@sensor_value` の内容を修正します。

```ruby
<h1>Sensor value</h1>

<div><%= @sensor_value %></div>
```

このままでは、`/top/show` にアクセスする必要があります。 `routes.rb` を修正して `/` でアクセスできるようにします。

```ruby
Rails.application.routes.draw do
  root 'top#show'

  get 'top/show'
end
```

### 動作確認

1つめ

```bash
cd ~/get-value-from-sensor
rbenv sudo bundle exec rails phototransistor_server:wake_up
```

2つめ

```bash
cd ~/get-value-from-sensor
bundle exec rails server -b 0.0.0.0
```

`-b` オプションをつける理由は、外部からアクセスするためです。`-b` オプションをつけないと、`localhost`からのみアクセスできます。

RaspberryPi の IPアドレスを調べます。

```bash
ifconfig wlan0

wlan0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet <ここの値>  netmask 255.255.255.0  broadcast ?????????
        inet6 ?????????  prefixlen 64  scopeid 0x20<link>
        ether ?????????  txqueuelen 1000  (イーサネット)
        RX packets 110218  bytes 88854717 (84.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 82412  bytes 15156413 (14.4 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

今操作しているPCでWebブラウザを起動して、`<先ほど調べたIP>:3000` にアクセスします。
すると、フォトトランジスターの値が表示されます。
フォトトランジスターを手で覆って、ページをリロードすると、値が変動します。

## Let's try

1. ページに表示している、フォトトランジスターの値をボタン押下で、更新する様にしましょう。
2. Lチカの配線を参考にして、LEDを配線して、ページ上のボタンで、LED を On Off できる様にしましょう。
