# How to rasterize an image with Processing

この投稿では，画像のデータにアクセスする方法と，それを使っておしゃれなカスタム画像フィルタを作成する方法を紹介します．

私([Tim Rodenbröker](https://timrodenbroeker.de/about/) さん)はProcessingで画像データにアクセスする方法を示す方法として[ラスタライズ](https://w.wiki/6GPx)を選択しました．結局のところ，あらゆる種類の画像で創造性を発揮するための何百万もの可能性のうちの一つに過ぎないのです．このページの下に，インスピレーションを得るための素晴らしいプロジェクトがいくつかリストアップされています．

![woman](../image/woman.jpg)
![raster51](../image/raster51-731x1024.png)

このチュートリアルでは，いくつかの非常に重要なトピックを扱います．多次元配列のループ処理から，色値の変換，グリッドの再計算まで．

さあ，はじめましょう．

# Setting up the sketch

いつものように，基本的な設定からはじめます． `setup()` メソッドの前に2つの色を定義し，データフォルダから画像をロードするプログラムです[^1]．

```Processing
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

> この時点で実行結果は以下のように何も表示されません．プログラムとしては，画像データを読み込んでいるだけキャンバスには表示していません．

![output001](../ImageRasterize/output001.png)

## The rasterization-algorithm

今回使用する画像(718 x 950)は，キャンバスのサイズ(500 x 700)と若干異なっています．そのため，`setup()` で `resize()` 関数を使用しています[^2]．

```Processing
img.resize(500, 700);
```

これから `draw()` ループの中にラスタライズアルゴリズムを作成していきます．グリッドのすべてのタイルの幅と高さは等しいので，画像のアスペクト比を計算します．これによって，縦方向にいくつタイルが必要かがわかります．

```Processing
void draw() {
    ...
    float ratio = float(height)/flaot(width);
}
```
次に，X軸のタイルの数をマウスのX座標にバインドさせます[^3]．これにより，様々な解像度をテストすることができます．

```Processing
void draw() {
    ...
    float ratio = float(height)/flaot(width);
    float tilesX = map(mouseX, 0, width, 10, 100);
}
```

そして，画像のアスペクト比に基づいてY軸のタイル数を計算します．

```Processing
void draw() {
    ...
    float ratio = float(height)/flaot(width);
    float tilesX = map(mouseX, 0, width, 10, 100);
    float tilesY = ratio * tilesX;
}
```

最後に，各タイルの幅と高さを計算する必要があります．今回は，正方形のタイルを使って作業することを目指しているので，この計算は一度だけで実行します．

```Processing
void draw() {
    ...
    float ratio = float(height)/flaot(width);
    float tilesX = map(mouseX, 0, width, 10, 100);
    float tilesY = ratio * tilesX;
    float tileSize = width / tilesX;
}
```

## Creatig the loop

素晴らしい！！必要な値はすべて適切な変数に格納されています．では，ループを作りましょう．

最初にY軸のループをつくります．なぜなら，二次元のものを一列ずつではなく，一行ずつ見ていく方が直観的にわかるからです．

```Processing
  for (int y = 0; y < img.height; y  += tileSize) {
    for (int x = 0; x < img.width; x += tileSize) {
    }
  }
```

ループの中では，まず現在のピクセルから色を抽出し，color型の変数 `c` に代入します．

```Processing
  for (int y = 0; y < img.height; y  += tileSize) {
    for (int x = 0; x < img.width; x += tileSize) {
      color c = img.get(x, y);
    }
  }
```

ここで， `c` の明るさを計算して `float b` に入れ， `0` から `255` までの値を `0` から `1` までの範囲にマッピングします．

```Processing
  for (int y = 0; y < img.height; y  += tileSize) {
    for (int x = 0; x < img.width; x += tileSize) {
      color c = img.get(x, y);
      float b = map(brightness(c), 0, 255, 1, 0);
    }
  }
```

そして最後に，新しい行列を作り，適切な大きさの矩形を描きます．

```Processing
      // Open a new matrix
      pushMatrix();
      // set the position
      translate(x, y);
      // Draw the tile
      rect(0, 0, b * tileSize, b * tileSize);
      // close matrix
      popMatrix();
```

後は，ネストした `for` を閉じて， `draw()` も閉じて終了です．

最終敵にできたプログラムです．

```Processing
color FG = #111111;
color BG = #f1f1f1;

PImage img;

void setup() {
  size(500, 700);
  background(BG);
  img = loadImage("woman.jpg");
  img.resize(500, 700);
}

void draw() {
  background(BG);
  fill(FG);
  noStroke();
  float ratio = float(height)/float(width);
  float tilesX = map(mouseX, 0, width, 10, 100);
  float tilesY = ratio * tilesX;
  float tileSize = width / tilesX;
  
  for (int y = 0; y < img.height; y  += tileSize) {
    for (int x = 0; x < img.width; x += tileSize) {
      color c = img.get(x, y);
      float b = map(brightness(c), 0, 255, 1, 0);
      
      // open a new matrix
      pushMatrix();
      // set the position
      translate(x, y);
      // Draw the tile
      rect(0, 0, b * tileSize, b * tileSize);
      // close matrix
      popMatrix();
    }
  } 
}
```

`tileX` の値を `10` , `20` , `30` , `50` , `100` と変化させた画像を順番に表示します．

![raster-10](../ImageRasterize/raster-10.png)

![raster-20](../ImageRasterize/raster-20.png)

![raster-30](../ImageRasterize/raster-30.png)

![raster-50](../ImageRasterize/raster-50.png)

![raster-100](../ImageRasterize/raster-100.png)


これでおしまいです．そんなに難しくはないでしょう．ここに，さらなる読み物とインスピレーションを得るための興味深いリンクがいくつかあります．

- http://generateme.tumblr.com/
- https://github.com/tsulej/GenerateMe
- https://timrodenbroeker.de/projects/redrawing-images

[timrodenbroeker/tutorials: All assets for my tutorials](https://github.com/timrodenbroeker/tutorials)

[^1]: Processingで画像を扱うには，https://yoppa.org/proga10/1353.html を参考にしてください．

[^2]: `resize()` 関数については，https://processing.org/reference/PImage_resize_.html を参考にしてください．

[^3]: `map()` 関数については，https://processing.org/reference/map_.html を参考にしてください．