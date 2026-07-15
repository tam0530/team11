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
 //==========================
// アイテム描画
//==========================
void display(Player player, boolean reveal) {

  if (collected) return;

  // 暗闇では近くしか表示しない
  if (!reveal) {

    int dx = abs(x - player.getX());
    int dy = abs(y - player.getY());

    if (dx > 1 || dy > 1) {
      return;
    }
  }

  if (reveal) {

    // 全体表示
    image(img, x * tileSize, y * tileSize);

  } else {

    // 暗闇（ズーム表示）
    pushMatrix();

    float zoom = 2.5;

    translate(width / 2, height / 2);
    scale(zoom);

    translate(
      -(player.getX() * tileSize + tileSize / 2),
      -(player.getY() * tileSize + tileSize / 2)
    );

    image(img, x * tileSize, y * tileSize);

    popMatrix();
  }
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
