class ScreenAddEdit {
  CompanyRepository repository;
  Company targetCompany;      // 編集対象。新規追加時はnull
  boolean isEditMode = false;
  String selectedStatus = "選考中";
  String errorMessage = "";

  ScreenAddEdit(CompanyRepository r) {
    repository = r;
  }

  // 新規追加モードで開始
  void startNewEntry() {
    targetCompany = null;
    isEditMode = false;
    selectedStatus = "選考中";
    errorMessage = "";
  }

  // 編集モードで開始（onClickEditから呼ばれる想定）
  void startEdit(Company c) {
    targetCompany = c;
    isEditMode = true;
    selectedStatus = c.selectionStatus;
    errorMessage = "";
  }

  void display() {
    background(255);

    fill(60);
    textSize(22);
    text(isEditMode ? "企業情報の編集" : "企業情報の追加", 40, 50);

    // 項目ラベルだけ先に並べる（入力欄そのものは次のステップで作る）
    String[] labels = {
      "企業名", "マイページURL", "マイページID",
      "ES締切日", "SPI締切日", "インターンシップ日",
      "一次面接日", "二次面接日", "三次面接日", "顔写真提出日"
    };

    float y = 100;
    fill(139, 135, 160);
    textSize(11);
    for (String label : labels) {
      text(label, 40, y);
      noFill();
      stroke(230, 225, 245);
      rect(40, y + 8, 300, 32, 8);
      noStroke();
      fill(139, 135, 160);
      y += 55;
    }

    // ステータスピル（見た目だけ）
    text("選考結果ステータス", 400, 100);
    drawStatusPill("選考中", 400, 120);
    drawStatusPill("合格", 500, 120);
    drawStatusPill("不合格", 580, 120);

    // 保存ボタン
    fill(120, 190, 150);
    rect(700, 600, 160, 40, 20);
    fill(255);
    textSize(13);
    text("保存する", 745, 625);
  }

  void drawStatusPill(String label, float x, float y) {
    if (selectedStatus.equals(label)) {
      fill(159, 174, 234);
    } else {
      noFill();
      stroke(200);
    }
    rect(x, y, 70, 28, 14);
    noStroke();
    fill(selectedStatus.equals(label) ? 255 : 100);
    textSize(10);
    text(label, x + 12, y + 18);
  }
}
