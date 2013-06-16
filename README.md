# kosen-firework

for kosenconf 5th anniversary party.

## 準備いろいろ

- [Processing](https://processing.org/download/) をインストールしましょう
- Processing のライブラリに Twitter4J を追加
  - [Twitter4J](http://twitter4j.org/ja/index.html) をダウンロードして、Processing のあるフォルダの libraries フォルダの中に、twitter4j という名前で展開しましょう
  - 展開したフォルダの中にある lib というフォルダの名前を library に変えましょう。さっきは libraries で今回は library です
  - さらにその中にある twitter4j-core-x.x.x.jar というファイルの名前を twitter4j.jar に変えましょう
- Processing のライブラリに ControlP5 を追加
  - [Sketch] -> [Import Library...] -> [Add Library...] で開いた画面の中から ControlP5 を探してインストールしましょう。これだけ！簡単！
- Twitter の Consumer 何々を設定
  - kosen-firework フォルダの中に twitter4j.properties というファイルを作り、1行目に Consumer key を、2行目に Consumer secret を書きましょう
  - Twitter4J 自体のプロパティファイルの書き方とは違うので注意！
  - Consumer なんちゃらって何？って疑問についてはおググりください

Enjoy!!
