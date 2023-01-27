How to rasterize an image with Processing

この投稿では，画像のデータにアクセスする方法と，それを使っておしゃれなカスタム画像フィルタを作成する方法を紹介します．

私([Tim Rodenbröker](https://timrodenbroeker.de/about/) さん)はProcessingで画像データにアクセスする方法を示す方法として[ラスタライズ](https://w.wiki/6GPx)を選択しました．結局のところ，あらゆる種類の画像で創造性を発揮するための何百万もの可能性のうちの一つに過ぎないのです．このページの下に，インスピレーションを得るための素晴らしいプロジェクトがいくつかリストアップされています．

![woman](../image/woman.jpg)
![raster51](../image/raster51-731x1024.png)

このチュートリアルでは，いくつかの非常に重要なトピックを扱います．多次元配列のループ処理から，色値の変換，グリッドの再計算まで．

さあ，はじめましょう．

# Setting up the sketch

いつものように，基本的な設定からはじめます． `setup()` メソッドの前に2つの色を定義し，データフォルダから画像をロードするプログラムです[^1]．

```processing
color FG = #111111;
color BG = #f1f1f1;

PImage img;

void setup() {
  size(500, 700);
  background(BG);
  img = loadImage("woman.jpg");
}

void draw() {
  background(BG);
  fill(FG);
  noStroke();
}
```

[*1]: Processingで画像を扱うには，https://yoppa.org/proga10/1353.htmlを参考にしてください．
