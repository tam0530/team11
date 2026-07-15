class Player {

  // プレイヤーのマス座標
  int x;
  int y;

  // 1マスの大きさ
  int tileSize;

  // キャラクター画像
  PImage img;


  //==========================
  // コンストラクタ
  //==========================
  Player(int startX, int startY, int tileSize) {

    this.x = startX;
    this.y = startY;
    this.tileSize = tileSize;

    // キャラクター画像読み込み
    img = loadImage("man.png");
    img.resize(tileSize, tileSize);
  }


  //==========================
  // プレイヤー描画
  //==========================
  void display(boolean reveal) {

  if (reveal) {
    image(img, x * tileSize, y * tileSize);
    return;
  }

  pushMatrix();

  float zoom = 2.5;

  translate(width/2, height/2);
  scale(zoom);

  translate(
    -(x * tileSize + tileSize/2),
    -(y * tileSize + tileSize/2)
  );

  image(img, x * tileSize, y * tileSize);

  popMatrix();
}


  //==========================
  // 移動処理
  //==========================
  void move(int dx, int dy, GameMap gameMap) {

    int nextX = x + dx;
    int nextY = y + dy;

    // 壁でなければ移動
    if (!gameMap.isWall(nextX, nextY)) {

      x = nextX;
      y = nextY;

      // 地雷判定
      if (gameMap.map[y][x] == gameMap.MINE) {

        if (shield) {
          shield = false;
          gameMap.map[y][x] = gameMap.ROAD;
        } else {
          // すぐにゲームオーバーにはせず、バツ印の演出を開始する
          // （実際のゲームオーバー処理は app.pde の draw() 側で演出後に行う）
          exploding = true;
          explodeStart = millis();
          explodeX = x;
          explodeY = y;
          explosion.play();
        }
      }

      // ゴール判定
      if (gameMap.map[y][x] == gameMap.GOAL) {

        gameClear = true;
        bgm.stop();
        clear.play();

      }
    }
  }


  //==========================
  // キー操作
  //==========================
  void keyMove(GameMap gameMap) {

    if (keyCode == UP) {

      move(0, -1, gameMap);

    } else if (keyCode == DOWN) {

      move(0, 1, gameMap);

    } else if (keyCode == LEFT) {

      move(-1, 0, gameMap);

    } else if (keyCode == RIGHT) {

      move(1, 0, gameMap);

    }
  }


  //==========================
  // 現在位置取得
  //==========================
  int getX() {

    return x;

  }


  int getY() {

    return y;

  }


  //==========================
  // 初期位置変更
  //==========================
  void setPosition(int x, int y) {

    this.x = x;
    this.y = y;

  }

}
