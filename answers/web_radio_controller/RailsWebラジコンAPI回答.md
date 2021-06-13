# Rails Webラジコン作成回答

## モーター制御WEBAPIの作成

`app/controllers/application_controller.rb` を修正して、`Can't verify CSRF token authenticity` を回避します。

```ruby
class ApplicationController < ActionController::Base
  skip_forgery_protection
end
```

`app/controllers/mortor_controller.rb` を作成してモーター制御WebAPIを作成します。

```ruby
class MortorController < ApplicationController
  def control
    function_name = params["control"]
    send_request(function_name)
    render json: [ status: :ok , control: function_name]
  end

  private

  def send_request(function_name)
    socket = TCPSocket.open('localhost', 2000)

    socket.puts function_name
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

WebAPIのルートを追加します。

`RadioControl/config/routes.rb`
```ruby
Rails.application.routes.draw do
  post 'mortor/control'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
```


### 動作確認
動作確認をします。ターミナルを2つ立ち上げます。

1つめ

```bash
cd ~/RadioControl
rbenv sudo bundle exec rails mortorcontrol_server:wake_up
```

2つめ

```bash
cd ~/RadioControl
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

今操作しているPCでWebブラウザを起動して、以下URLにアクセスし
モーターが想定通り動いていることを確認します。

http://XXX.XXX.XXX.XXX:3000/mortor/forward

http://XXX.XXX.XXX.XXX:3000/mortor/left

http://XXX.XXX.XXX.XXX:3000/mortor/right

http://XXX.XXX.XXX.XXX:3000/mortor/back

http://XXX.XXX.XXX.XXX:3000/mortor/breake

※XXX XXX XXX.XXXは調べたIPアドレスです。

回答ソースの例は[こちら](RadioControl)

※ラジコンAPI、ラジコン画面、カメラストリーム配信の対応が入った回答ソースです。
