// 全画面で共通に使う下部ナビゲーション
class NavigationBar {
  float y = 740;

  void display() {
    noStroke();
    fill(246, 247, 251);
    rect(0, y, width, 60);
    stroke(225);
    line(0, y, width, y);
    noStroke();

    drawItem("一覧確認", 30, 120, 0);
    drawItem("カレンダー", 180, 120, 1);
    drawItem("企業一覧", 330, 150, 2);
    drawItem("追加・編集", 510, 150, 3);
    drawItem("通知設定", 690, 150, 4);
  }

  void drawItem(String label, float x, float w, int screenId) {
    boolean active = currentScreen == screenId;
    fill(active ? color(80, 130, 210) : color(90));
    textSize(14);
    text(label, x + 18, y + 35);
    if (active) {
      fill(80, 130, 210);
      rect(x, y + 55, w, 3);
    }
  }

  // ナビゲーション領域をクリックしたら true を返す
  boolean handleInput() {
    if (mouseY < y || mouseY > y + 60) return false;

    if (mouseX >= 180 && mouseX <= 300) {
      currentScreen = 1;
    } else if (mouseX >= 330 && mouseX <= 480) {
      currentScreen = 2;
    } else if (mouseX >= 510 && mouseX <= 660) {
      screenAddEdit.startNewEntry();
      currentScreen = 3;
    }
    // 一覧確認・通知設定は担当画面が統合されてから遷移を追加する
    return true;
  }
}
