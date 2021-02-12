# Rails RailsWebラジコン画面回答

## ラジコン制御するトップページの作成

### JQueryを使用できるように修正します。

```bash
yarn add jquery
```

config/webpack/environment.js
```javascript
const { environment } = require('@rails/webpacker')
// 以下追記
const webpack = require('webpack')

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)
// ここまで
module.exports = environment
```

#### Topページ作成
TopPageを作成するために、次のコマンドを入力します。

```bash
bundle exec rails generate controller Top show
```

##### Topページ スタイルシート作成
ラジコンボタン風スタイルシートを作成します。
`app/assets/stylesheets/top.scss` を修正して、コントロールボタンのスタイルを作成します。
```css
/** 下準備_ボタン **/

.btn {
    border-style: none;
    cursor: pointer;
}

/** 下準備_十字配置部品 **/

.cross-layout {
    display: grid;
    grid-template-columns: 30px 30px 30px;
    grid-template-rows: 30px 30px 30px;
}

.cross-layout .position-top {
    grid-row: 1 / 2;
    grid-column: 2 / 3;
}

.cross-layout .position-left {
    grid-row: 2 / 3;
    grid-column: 1 / 2;
}

.cross-layout .position-center {
    grid-row: 2 / 3;
    grid-column: 2 / 3;
}

.cross-layout .position-right {
    grid-row: 2 / 3;
    grid-column: 3/4;
}

.cross-layout .position-bottom {
    grid-row: 3 / 4;
    grid-column: 2/3;
}

/**　コントローラーの左側_十字キー**/

.cross-key-btn {
    width: 30px;
    height: 30px;
    background-color: rgba(66, 86, 123, 0.5);
}

.left-mark {
    display: block;
    transform: rotate(-90deg);
}

.right-mark {
    display: block;
    transform: rotate(90deg);
}

.bottom-mark {
    display: block;
    transform: rotate(180deg);
}

/**　コントローラーの左側_十字キーを灰色の円形で囲む**/

.controller-left {
    display: inline-block;
    background-color: rgb(229, 227, 250);
    padding: 30px;
    border-radius: 50%;
}
```

##### Topページ javascript作成
`app/javascript/packs/top/mortor.js` を作成して、ラジコン画面操作部を作成します。
```javascript
$(function() {
  $('#forward').on('click', function() {
    radioApi('forward')
  });

  $('#left').on('click', function() {
    radioApi('left')
  });

  $('#right').on('click', function() {
    radioApi('right')
  });

  $('#back').on('click', function() {
    radioApi('back')
  });

  $('#breake').on('click', function() {
    radioApi('breake')
  });
});
var mortorControls ={ArrowUp: false, ArrowLeft: false, ArrowRight: false, ArrowDown: false};

$(window).keydown(function(e){
  var code = e.code;
  if(!(code == 'ArrowUp' || code == 'ArrowLeft' || code == 'ArrowRight' || code == 'ArrowDown'))
  {
    return false;
  }

  if(mortorControls[code])
  {
    return false;
  }

  mortorControls[code] = true;

  console.log('keydown:' + code);

  switch (code) {
    case 'ArrowUp':
      radioApi('forward')
      break;
    case 'ArrowLeft':
      radioApi('left')
      break;
    case 'ArrowRight':
      radioApi('right')
      break;
    case 'ArrowDown':
      radioApi('back')
      break;
    default:
      break;
  }

  return true;
});

$(window).keyup(function(e){
  var code = e.code;
  console.log('keyup:' + code);
  mortorControls[code] = false;

  radioApi('breake')
  return true;
});

function radioApi(apiName)
{
  var url = '/mortor/' + apiName;
  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'json',
    timeout: 5000,
  })
  .done(function(data) {
  })
  .fail(function() {
  });
}
```



`app/views/top/show.html.erb` を修正して、ラジコン画面を作成します。

```ruby
<%= javascript_pack_tag 'top/mortor', 'data-turbolinks-track': 'reload' %>
<h1>RadioControll</h1>
<div class="controller-left">
  <div class="cross-layout">
    <button id="forward" class="position-top btn cross-key-btn"><span class="top-mark">▲</span></button>
    <button id="left" class="position-left btn cross-key-btn"><span class="left-mark">▲</span></button>
    <button id="breake" class="position-center btn cross-key-btn"><span class="center-mark">●</span></button>
    <button id="right" class="position-right btn cross-key-btn"><span class="right-mark">▲</span></button>
    <button id="back" class="position-bottom btn cross-key-btn"><span class="bottom-mark">▲</span></button>
  </div>
</div>
```

このままでは、`/top/show` にアクセスする必要があります。 `config/routes.rb` を修正して `/` でアクセスできるようにします。

```ruby
Rails.application.routes.draw do
  root 'top#show' # 追加

  get 'top/show' # 追加
  get 'mortor/forward'
  get 'mortor/left'
  get 'mortor/right'
  get 'mortor/back'
  get 'mortor/breake'
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

ラジコン操作画面が表示されます。

ボタンまたはキーで操作してみましょう。

回答ソースの例は[こちら](https://github.com/libertyfish-co/ruby-hw/blob/master/answers/web_radio_controller/RadioControl)

※ラジコンAPI、ラジコン画面、カメラストリーム配信の対応が入った回答ソースです。
