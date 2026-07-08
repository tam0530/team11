class Player {

  // プレイヤーのマス座標
  int x;
  int y;

  // 1マスの大きさ
  int tileSize;

  // キャラクター画像
  PImage img;


  // コンストラクタ
  Player(int startX, int startY, int tileSize) {

    this.x = startX;
    this.y = startY;
    this.tileSize = tileSize;

    // man.png読み込み
    img = loadImage("man.png");
    
    // 28×28に調整
    img.resize(tileSize, tileSize);
  }



  //==========================
  // プレイヤー描画
  //==========================
  void display() {

    image(
      img,
      x * tileSize,
      y * tileSize
    );

  }



  //==========================
  // 移動処理
  //==========================
  void move(int dx, int dy, Maze maze) {


    int nextX = x + dx;
    int nextY = y + dy;


    // 迷路外、壁チェック
    if(!maze.isWall(nextX,nextY)){

      x = nextX;
      y = nextY;

    }

  }



  //==========================
  // キー操作
  //==========================
  void keyMove(Maze maze){


    if(keyCode == UP){

      move(0,-1,maze);

    }
    else if(keyCode == DOWN){

      move(0,1,maze);

    }
    else if(keyCode == LEFT){

      move(-1,0,maze);

    }
    else if(keyCode == RIGHT){

      move(1,0,maze);

    }

  }



  //==========================
  // 現在位置取得
  //==========================
  int getX(){

    return x;

  }


  int getY(){

    return y;

  }



  //==========================
  // 初期位置変更
  //==========================
  void setPosition(int x,int y){

    this.x=x;
    this.y=y;

  }


}
