class Item {

  //==========================
  // アイテムの種類
  //==========================
  static final int MAP = 0;
  static final int SHIELD = 1;

  // アイテムのマス座標
  int x;
  int y;

  // 1マスの大きさ
  int tileSize;

  // アイテムの種類
  int type;

  // 取得済みか
  boolean collected;

  // アイテム画像
  PImage img;


  //==========================
  // コンストラクタ
  //==========================
  Item(int x, int y, int type, int tileSize) {

    this.x = x;
    this.y = y;
    this.type = type;
    this.tileSize = tileSize;

    collected = false;

    // アイテム画像読み込み
    if (type == MAP) {

      img = loadImage("mapItem.png");

    } else {

      img = loadImage("shieldItem.png");

    }

    // サイズ調整
    img.resize(tileSize, tileSize);

  }


  //==========================
  // アイテム描画
  //==========================
  void display(Player player, boolean reveal) {

    if (collected) return;

    // 覚える時間中・マップアイテム使用中でなければ
    // 自分の周り1マス以外は見せない
    if (!reveal) {

      int dx = abs(x - player.getX());
      int dy = abs(y - player.getY());

      if (dx > 1 || dy > 1) {
        return;
      }
    }

    image(
      img,
      x * tileSize,
      y * tileSize
    );

  }


  //==========================
  // アイテム取得判定
  //==========================
  boolean checkGet(Player player) {

    if (collected) {

      return false;

    }

    if (player.getX() == x && player.getY() == y) {

      collected = true;
      return true;

    }

    return false;

  }


  //==========================
  // アイテム種類取得
  //==========================
  int getType() {

    return type;

  }

}
