class Map {

  final int ROW = 15;
  final int COL = 15;
  final int SIZE = 40;

  final int ROAD = 0;
  final int WALL = 1;
  final int MINE = 2;
  final int START = 3;
  final int GOAL = 4;

  int[][] map;

  Map() {
    map = new int[ROW][COL];
    generateMap();
  }

  void generateMap() {

    // 最初は全部壁
    for (int y=0; y<ROW; y++) {
      for (int x=0; x<COL; x++) {
        map[y][x]=WALL;
      }
    }

    // スタート
    int x=0;
    int y=0;
    map[y][x]=START;

    // 必ず通れる道を作る
    while (x<COL-1 || y<ROW-1) {

      if (x==COL-1) {
        y++;
      } else if (y==ROW-1) {
        x++;
      } else {

        if (random(1)<0.5) {
          x++;
        } else {
          y++;
        }
      }

      map[y][x]=ROAD;
    }

    // ゴール
    map[ROW-1][COL-1]=GOAL;

    // 周囲をランダムに通路へ変更
    for (int i=0;i<60;i++) {

      int rx=(int)random(COL);
      int ry=(int)random(ROW);

      if(map[ry][rx]==WALL){
        map[ry][rx]=ROAD;
      }
    }

    // 地雷を設置（通路のみ）
    int mine=0;

    while(mine<12){

      int rx=(int)random(COL);
      int ry=(int)random(ROW);

      if(map[ry][rx]==ROAD){

        // スタート付近は除く
        if(!(rx==0&&ry==0) &&
           !(rx==COL-1&&ry==ROW-1)){

          map[ry][rx]=MINE;
          mine++;
        }
      }
    }
  }

  void display(){

    stroke(0);

    for(int y=0;y<ROW;y++){

      for(int x=0;x<COL;x++){

        if(map[y][x]==WALL){
          fill(80);

        }else{
          fill(255);
        }

        rect(x*SIZE,y*SIZE,SIZE,SIZE);

        fill(0);
        textAlign(CENTER,CENTER);
        textSize(22);

        switch(map[y][x]){

        case START:
          text("S",x*SIZE+SIZE/2,y*SIZE+SIZE/2);
          break;

        case GOAL:
          text("G",x*SIZE+SIZE/2,y*SIZE+SIZE/2);
          break;

        case MINE:
          text("×",x*SIZE+SIZE/2,y*SIZE+SIZE/2);
          break;
        }
      }
    }
  }
}
