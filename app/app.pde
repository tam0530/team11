import processing.sound.*;
PFont font;
// ===== マップ設定 =====
int cols = 15;
int rows = 15;
int cell = 40;


// ===== プレイヤー =====


// ===== 時間 =====
boolean memorize = true;
int memorizeTime = 10000;   // 普通：10秒
int startTime;

int limitTime = 60000;      // 制限時間60秒

// ===== ゲーム状態 =====
boolean gameOver = false;
boolean gameClear = false;

// ===== アイテム =====
boolean shield = false;
boolean mapItem = false;
int mapItemStart = 0;

// ===== サウンド =====
SoundFile bgm;
SoundFile gameover;
SoundFile clear;

// ===== タイトル画面 =====
boolean title = true;

// ===== 難易度 =====
int difficulty = 2;   // 1:簡単 2:普通 3:難しい
String difficultyName = "普通";
Map gameMap;
Player player;
Item mapItemObj;
Item shieldItemObj;

//====================================

void setup() {

  size(cols * cell, rows * cell);
   font = createFont("Yu Gothic", 32);
  textFont(font);
  
gameMap = new Map();
player = new Player(1, 1, cell);

mapItemObj = new Item(5, 3, Item.MAP, cell);
shieldItemObj = new Item(11, 9, Item.SHIELD, cell);

  // サウンド
  bgm = new SoundFile(this, "bgm.mp3");
  gameover = new SoundFile(this, "gameover.mp3");
  clear = new SoundFile(this, "clear.mp3");

  bgm.loop();



  // プレイヤー位置

  startTime = millis();
}

//====================================

void draw() {
  
   // タイトル画面
  if (title) {
    drawTitle();
    return;
  }

  background(0);

  // 覚える時間終了
  if (memorize && millis() - startTime >= memorizeTime) {
    memorize = false;
  }

  // マップ表示アイテム終了
  if (mapItem && millis() - mapItemStart >= 5000) {
    mapItem = false;
  }

  // 描画
  gameMap.display();

mapItemObj.display();
shieldItemObj.display();

player.display();

if (mapItemObj.checkGet(player)) {
  mapItem = true;
  mapItemStart = millis();
}

if (shieldItemObj.checkGet(player)) {
  shield = true;
}
  // 残り時間
  int remain = max(0, (limitTime - (millis() - startTime)) / 1000);

  fill(255);
  textSize(20);
  textAlign(LEFT);
  text("Time : " + remain, 10, 25);
  text("難易度：" + difficultyName, 10, 50);

  // 時間切れ
  if (!gameOver && !gameClear && millis() - startTime >= limitTime) {
    gameOver = true;
    bgm.stop();
    gameover.play();
  }

  // ゲームオーバー
  if (gameOver) {

    background(0);

    fill(255, 0, 0);
    textAlign(CENTER);
    textSize(50);
    text("GAME OVER", width/2, height/2);

    textSize(20);
    text("Press R to Restart", width/2, height/2 + 50);

    noLoop();
  }

  // ゲームクリア
  if (gameClear) {

    background(0);

    fill(0, 255, 0);
    textAlign(CENTER);
    textSize(50);
    text("GAME CLEAR", width/2, height/2);

    textSize(20);
    text("Press R to Restart", width/2, height/2 + 50);

    noLoop();
  }

}

//====================================

// キーボード操作
void keyPressed() {
  

  // タイトル画面
  if (title) {

    if (key == '1') {
      difficulty = 1;
      difficultyName = "簡単";
      memorizeTime = 15000;

    } else if (key == '2') {
      difficulty = 2;
      difficultyName = "普通";
      memorizeTime = 10000;
      
    } else if (key == '3') {
      difficulty = 3;
      difficultyName = "難しい";
      memorizeTime = 5000;

    } else {
      return;
    }

    title = false;
    startTime = millis();
    return;
  }

  if (gameOver || gameClear) {

    if (key == 'r' || key == 'R') {
      restartGame();
    }

    return;
  }

  player.keyMove();
}

//====================================

// ゲームを最初からやり直す
void restartGame() {

  gameOver = false;
  gameClear = false;

  shield = false;
  mapItem = false;

  memorize = true;

 gameMap = new Map();
player = new Player(1, 1, cell);

mapItemObj = new Item(5, 3, Item.MAP, cell);
shieldItemObj = new Item(11, 9, Item.SHIELD, cell);

  startTime = millis();

  bgm.stop();
  bgm.loop();

  loop();
}
