void drawTitle() {

  background(30, 30, 70);

  fill(255, 255, 0);
  textAlign(CENTER);
  textSize(40);
  text("記憶の迷宮", width/2, 80);

  fill(255);
  textSize(24);
  text("難易度を選択してください", width/2, 170);

  textSize(22);
  text("1 : 簡単（15秒）", width/2, 250);
  text("2 : 普通（10秒）", width/2, 300);
  text("3 : 難しい（5秒）", width/2, 350);

  textSize(18);
  text("数字キーを押して開始", width/2, 450);
}
