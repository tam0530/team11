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

    // 全部壁にする
    for (int y = 0; y < ROW; y++) {
      for (int x = 0; x < COL; x++) {
        map[y][x] = WALL;
      }
    }

    // 穴掘り開始
    dig(1, 1);

    // 少し壁を壊して複数ルートを作る
    for (int i = 0; i < 20; i++) {

      int rx = (int)random(1, COL - 1);
      int ry = (int)random(1, ROW - 1);

      if (map[ry][rx] == WALL) {
        map[ry][rx] = ROAD;
      }
    }

    // スタート・ゴール
    map[1][1] = START;
    map[ROW-2][COL-2] = GOAL;

    // 地雷設置
    int mine = 0;

    while (mine < 12) {

      int rx = (int)random(COL);
      int ry = (int)random(ROW);

      if (map[ry][rx] == ROAD) {

        if (!(rx == 1 && ry == 1) &&
          !(rx == COL-2 && ry == ROW-2)) {

          map[ry][rx] = MINE;
          mine++;
        }
      }
    }
  }

  //=========================
  // 穴掘り法
  //=========================
  void dig(int x, int y) {

    map[y][x] = ROAD;

    int[] dir = {0, 1, 2, 3};

    // シャッフル
    for (int i = 0; i < 4; i++) {
      int r = (int)random(4);

      int t = dir[i];
      dir[i] = dir[r];
      dir[r] = t;
    }

    for (int i = 0; i < 4; i++) {

      int dx = 0;
      int dy = 0;

      switch(dir[i]) {

      case 0:
        dx = 2;
        break;

      case 1:
        dx = -2;
        break;

      case 2:
        dy = 2;
        break;

      case 3:
        dy = -2;
        break;
      }

      int nx = x + dx;
      int ny = y + dy;

      if (nx > 0 && nx < COL-1 &&
        ny > 0 && ny < ROW-1) {

        if (map[ny][nx] == WALL) {

          map[y + dy/2][x + dx/2] = ROAD;
          dig(nx, ny);
        }
      }
    }
  }

  void display() {

    stroke(0);

    for (int y = 0; y < ROW; y++) {

      for (int x = 0; x < COL; x++) {

        if (map[y][x] == WALL) {
          fill(80);
        } else {
          fill(255);
        }

        rect(x * SIZE, y * SIZE, SIZE, SIZE);

        fill(0);
        textAlign(CENTER, CENTER);
        textSize(22);

        switch(map[y][x]) {

        case START:
          text("S", x * SIZE + SIZE/2, y * SIZE + SIZE/2);
          break;

        case GOAL:
          text("G", x * SIZE + SIZE/2, y * SIZE + SIZE/2);
          break;

        case MINE:
          text("×", x * SIZE + SIZE/2, y * SIZE + SIZE/2);
          break;
        }
      }
    }
  }
}
