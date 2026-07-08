class Item {

  // アイテムの種類
  static final int MAP = 0;
  static final int SHIELD = 1;

  // 座標
  int x;
  int y;

  // アイテムの種類
  int type;

  // 取得済みか
  boolean collected;

  // アイテム画像
  PImage img;

  //==========================
  // コンストラクタ
  //==========================
  Item(int x, int y, int type) {

    this.x = x;
    this.y = y;
    this.type = type;

    collected = false;

    if(type == MAP){
      img = loadImage("mapItem.png");
    }else{
      img = loadImage("shieldItem.png");
    }

    img.resize(16,16);

  }

  //==========================
  // アイテム描画
  //==========================
  void display(){

    if(collected) return;

    image(img,x*16,y*16);

  }

  //==========================
  // プレイヤーが取得したか
  //==========================
  boolean checkGet(Player player){

    if(collected){
      return false;
    }

    if(player.getX()==x && player.getY()==y){

      collected=true;
      return true;

    }

    return false;

  }

  //==========================
  // アイテム種類取得
  //==========================
  int getType(){

    return type;

  }

}
