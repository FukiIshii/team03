// 全画面で共通に使う下部ナビゲーション
class NavigationBar {
  float y = 740;
  String[] labels = {"To Do リスト", "カレンダー", "企業一覧", "追加・編集", "通知設定"};

  void display() {
    noStroke();
    fill(246, 247, 251);
    rect(0, y, width, 60);
    stroke(225);
    line(0, y, width, y);
    noStroke();

    float slotW = width / (float) labels.length;
    for (int i = 0; i < labels.length; i++) {
      drawItem(labels[i], i * slotW, slotW, i);
    }
  }

  void drawItem(String label, float x, float w, int screenId) {
    boolean active = currentScreen == screenId;
    fill(active ? color(80, 130, 210) : color(90));
    textSize(14);
    float tw = textWidth(label);
    text(label, x + (w - tw) / 2, y + 35);
    if (active) {
      fill(80, 130, 210);
      rect(x + w * 0.15, y + 55, w * 0.7, 3);
    }
  }

  // ナビゲーション領域をクリックしたら true を返す
  boolean handleInput() {
    if (mouseY < y || mouseY > y + 60) return false;

    float slotW = width / (float) labels.length;
    int index = int(mouseX / slotW);
    if (index < 0) index = 0;
    if (index >= labels.length) index = labels.length - 1;

    // 「追加・編集」タブに切り替えるときは常に新規入力状態にする
    if (index == 3) {
      screenAddEdit.startNewEntry();
    }
    currentScreen = index;

    return true;
  }
}
