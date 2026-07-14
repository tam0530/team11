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

// 覚える時間が終わった後の「スタート」表示
boolean showStart = false;
int showStartBegin = 0;
int showStartDuration = 1000; // スタート表示を出す時間（1秒）

// プレイヤーが操作できるかどうか
boolean canMove = false;

// 実際にプレイヤーが動けるようになった時刻（制限時間はここから計測＝覚える時間を含まない）
int playStartTime = 0;

// ===== ゲーム状態 =====
boolean gameOver = false;
boolean gameClear = false;
String gameOverReason = "";   // ゲームオーバーの理由（地雷／時間切れ）

// ===== 地雷を踏んだ時の爆発演出 =====
boolean exploding = false;
int explodeStart = 0;
int explodeDuration = 700;   // バツ印演出の長さ（ミリ秒）
int explodeX = 0;
int explodeY = 0;

// ===== アイテム =====
boolean shield = false;
boolean mapItem = false;
int mapItemStart = 0;
int mapItemDuration = 5000;   // マップ全体表示の効果時間

// ===== サウンド =====
SoundFile bgm;
SoundFile gameover;
SoundFile clear;
SoundFile itemGet;     // アイテム取得音
SoundFile explosion;   // 地雷爆発音

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
void settings() {
  size(cols * cell, rows * cell);
}
void setup() {
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
  itemGet = new SoundFile(this, "item.mp3");
  explosion = new SoundFile(this, "explosion.mp3");

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

  // ===== 地雷を踏んだ時のバツ印演出 =====
  if (exploding) {

    boolean reveal = memorize || mapItem;

    gameMap.display(player, reveal);
    mapItemObj.display(player, reveal);
    shieldItemObj.display(player, reveal);
    player.display();

    // 経過割合（0→1）に合わせてバツ印を大きくする
    float progress = constrain((millis() - explodeStart) / (float) explodeDuration, 0, 1);
    float margin = lerp(cell * 0.45, 4, progress);

    float cx = explodeX * cell;
    float cy = explodeY * cell;

    stroke(255, 0, 0);
    strokeWeight(6);
    line(cx + margin, cy + margin, cx + cell - margin, cy + cell - margin);
    line(cx + cell - margin, cy + margin, cx + margin, cy + cell - margin);
    strokeWeight(1);

    // 演出が終わったらゲームオーバー画面へ
    if (millis() - explodeStart >= explodeDuration) {
      exploding = false;
      gameOverReason = "地雷を踏みました";
      gameOver = true;
      bgm.stop();
      gameover.play();
    }

    return;
  }

  // 覚える時間終了 → 「スタート」表示へ
  if (memorize && millis() - startTime >= memorizeTime) {
    memorize = false;
    showStart = true;
    showStartBegin = millis();
  }

  // スタート表示終了 → 操作可能に（ここから制限時間カウント開始）
  if (showStart && millis() - showStartBegin >= showStartDuration) {
    showStart = false;
    canMove = true;
    playStartTime = millis();
  }

  // マップ表示アイテム終了
  if (mapItem && millis() - mapItemStart >= mapItemDuration) {
    mapItem = false;
  }

  // 覚える時間中、またはマップアイテム使用中は全体を表示
  boolean reveal = memorize || mapItem;

  // 描画
  gameMap.display(player, reveal);

mapItemObj.display(player, reveal);
shieldItemObj.display(player, reveal);

player.display();

if (mapItemObj.checkGet(player)) {
  mapItem = true;
  mapItemStart = millis();
  itemGet.play();
}

if (shieldItemObj.checkGet(player)) {
  shield = true;
  itemGet.play();
}

  fill(255);
  textAlign(LEFT);
  textSize(20);

  if (memorize) {

    // 覚える時間の残り秒数
    int memRemain = (int)max(0, ceil((memorizeTime - (millis() - startTime)) / 1000.0));
    text("覚える時間 残り : " + memRemain + "秒", 10, 25);
    text("難易度：" + difficultyName, 10, 50);

  } else if (showStart) {

    text("難易度：" + difficultyName, 10, 50);

  } else {

    // 残り時間（覚える時間は含まない）
    int remain = max(0, (limitTime - (millis() - playStartTime)) / 1000);
    text("Time : " + remain, 10, 25);
    text("難易度：" + difficultyName, 10, 50);

    // マップアイテム効果中：全体表示できる残り秒数
    if (mapItem) {
      int mapRemain = (int)max(0, ceil((mapItemDuration - (millis() - mapItemStart)) / 1000.0));
      fill(255, 255, 0);
      text("全体図 残り : " + mapRemain + "秒", 10, 75);
      fill(255);
    }
  }

  // スタート表示
  if (showStart) {
    fill(255, 255, 0);
    textAlign(CENTER, CENTER);
    textSize(60);
    text("スタート", width/2, height/2);
  }

  // 時間切れ（操作可能になってから計測）
  if (!gameOver && !gameClear && canMove && millis() - playStartTime >= limitTime) {
    gameOverReason = "時間切れです";
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

    fill(255);
    textSize(24);
    text(gameOverReason, width/2, height/2 + 40);

    textSize(20);
    text("Press R to Restart", width/2, height/2 + 75);

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

  // 覚える時間中・スタート表示中・爆発演出中は操作不可
  if (!canMove || exploding) {
    return;
  }

  player.keyMove(gameMap);
}

//====================================

// ゲームを最初からやり直す
void restartGame() {

  gameOver = false;
  gameClear = false;
  gameOverReason = "";

  exploding = false;
  explodeStart = 0;

  shield = false;
  mapItem = false;

  memorize = true;
  showStart = false;
  canMove = false;
  playStartTime = 0;

 gameMap = new Map();
player = new Player(1, 1, cell);

mapItemObj = new Item(5, 3, Item.MAP, cell);
shieldItemObj = new Item(11, 9, Item.SHIELD, cell);

  startTime = millis();

  bgm.stop();
  bgm.loop();

  loop();
}
