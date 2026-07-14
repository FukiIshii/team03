// 通知設定画面 + ToDo一覧上部に表示する締切間近の警告バナー
class NotificationScreen {
  boolean notifyInApp = true;

  String[] timingOptions = {"当日", "1日前", "3日前", "1週間前"};
  int[] timingDays = {0, 1, 3, 7};
  int timingIndex = 1; // デフォルトは「1日前」
  boolean dropdownOpen = false;

  float cardX = 60, cardW = 1080;
  float card1Y = 110, card1HeaderH = 46, card1BodyH = 100;
  float card2Y, card2HeaderH = 46, card2BodyH = 110;
  float toggleX, toggleW = 52, toggleH = 26;
  float dropdownX, dropdownY, dropdownW = 220, dropdownH = 40;

  NotificationScreen() {
    card2Y = card1Y + card1HeaderH + card1BodyH + 25;
    toggleX = cardX + cardW - 110;
    dropdownX = cardX + cardW - 320;
    dropdownY = card2Y + card2HeaderH + 34;
  }

  void display() {
    background(255);
    fill(30);
    textSize(26);
    text("通知設定", 40, 55);
    fill(130);
    textSize(13);
    text("通知の受け取り方法やタイミングを設定できます。", 40, 82);

    drawCard1();
    drawCard2();

    // ドロップダウンの選択肢は一番最後に描画して他の要素より手前に出す
    if (dropdownOpen) drawDropdownOptions();
  }

  void drawCard1() {
    noStroke();
    fill(255);
    rect(cardX, card1Y, cardW, card1HeaderH + card1BodyH, 10);
    fill(231, 244, 255);
    rect(cardX, card1Y, cardW, card1HeaderH, 10, 10, 0, 0);
    fill(60, 140, 220);
    textSize(15);
    text("通知の受け取り方法", cardX + 24, card1Y + 30);

    // アプリ内通知の行
    float rowY = card1Y + card1HeaderH + 18;
    fill(225, 240, 255);
    ellipse(cardX + 46, rowY + 22, 46, 46);
    drawBellIcon(cardX + 46, rowY + 22, color(70, 140, 220));

    fill(30);
    textSize(15);
    text("アプリ内通知", cardX + 86, rowY + 16);
    fill(150);
    textSize(12);
    text("アプリ内でお知らせを表示します。", cardX + 86, rowY + 37);

    fill(120);
    textSize(12);
    text(notifyInApp ? "ON" : "OFF", toggleX - 42, rowY + 26);
    drawToggle(toggleX, rowY + 8, notifyInApp);
  }

  void drawBellIcon(float cx, float cy, color c) {
    noStroke();
    fill(c);
    arc(cx, cy - 2, 20, 18, PI, TWO_PI);
    rect(cx - 10, cy - 2, 20, 9);
    triangle(cx - 12, cy + 7, cx + 12, cy + 7, cx, cy + 15);
    ellipse(cx, cy + 15, 6, 6);
    rect(cx - 2, cy - 14, 4, 6, 2);
  }

  void drawToggle(float x, float y, boolean on) {
    noStroke();
    fill(on ? color(45, 130, 235) : color(210, 216, 226));
    rect(x, y, toggleW, toggleH, toggleH / 2);
    fill(255);
    float knobX = on ? x + toggleW - toggleH + 2 : x + 2;
    ellipse(knobX + (toggleH - 4) / 2.0, y + toggleH / 2.0, toggleH - 4, toggleH - 4);
  }

  void drawCard2() {
    noStroke();
    fill(255);
    rect(cardX, card2Y, cardW, card2HeaderH + card2BodyH, 10);
    fill(231, 244, 255);
    rect(cardX, card2Y, cardW, card2HeaderH, 10, 10, 0, 0);
    fill(60, 140, 220);
    textSize(15);
    text("通知のタイミング", cardX + 24, card2Y + 30);

    float rowY = card2Y + card2HeaderH + 20;
    fill(30);
    textSize(15);
    text("通知のタイミング", cardX + 24, rowY + 14);
    fill(150);
    textSize(12);
    text("設定したタイミングで通知を受け取ります。", cardX + 24, rowY + 35);

    stroke(dropdownOpen ? color(80, 150, 230) : color(200, 208, 220));
    fill(255);
    rect(dropdownX, dropdownY, dropdownW, dropdownH, 8);
    noStroke();
    fill(40);
    textSize(14);
    text(timingOptions[timingIndex], dropdownX + 16, dropdownY + 26);
    fill(120);
    text("▾", dropdownX + dropdownW - 26, dropdownY + 26);
  }

  void drawDropdownOptions() {
    float optH = 36;
    float listY = dropdownY + dropdownH + 4;
    stroke(200, 208, 220);
    fill(255);
    rect(dropdownX, listY, dropdownW, optH * timingOptions.length, 8);
    noStroke();
    for (int i = 0; i < timingOptions.length; i++) {
      float oy = listY + i * optH;
      if (i == timingIndex) {
        fill(231, 244, 255);
        rect(dropdownX, oy, dropdownW, optH);
      }
      fill(40);
      textSize(13);
      text(timingOptions[i], dropdownX + 16, oy + 23);
    }
  }

  void handleInput() {
    // ドロップダウンが開いていれば選択肢のクリックを優先して処理する
    if (dropdownOpen) {
      float optH = 36;
      float listY = dropdownY + dropdownH + 4;
      for (int i = 0; i < timingOptions.length; i++) {
        float oy = listY + i * optH;
        if (mouseX >= dropdownX && mouseX <= dropdownX + dropdownW && mouseY >= oy && mouseY <= oy + optH) {
          timingIndex = i;
          dropdownOpen = false;
          return;
        }
      }
      dropdownOpen = false; // リスト外をクリックしたら閉じるだけ
      return;
    }

    // アプリ内通知トグル
    float rowY = card1Y + card1HeaderH + 18;
    if (mouseX >= toggleX && mouseX <= toggleX + toggleW && mouseY >= rowY + 8 && mouseY <= rowY + 8 + toggleH) {
      notifyInApp = !notifyInApp;
      return;
    }

    // 通知タイミングのドロップダウンを開く
    if (mouseX >= dropdownX && mouseX <= dropdownX + dropdownW && mouseY >= dropdownY && mouseY <= dropdownY + dropdownH) {
      dropdownOpen = true;
      return;
    }
  }

  // ToDo一覧画面の上部に、締切が近い項目があれば警告バナーを表示する
  void displayWarning(CompanyRepository repository) {
    if (!notifyInApp) return;
    int threshold = timingDays[timingIndex];

    ArrayList<String> warnings = new ArrayList<String>();
    for (Company c : repository.getAll()) {
      checkNear(c.companyName, "ES提出", c.esDeadline, threshold, warnings);
      checkNear(c.companyName, "SPI受験", c.spiDeadline, threshold, warnings);
      checkNear(c.companyName, "面接", c.interview1Date, threshold, warnings);
    }
    if (warnings.size() == 0) return;

    noStroke();
    fill(255, 235, 235);
    stroke(230, 120, 120);
    rect(35, 108, 1130, 26, 6);
    noStroke();
    fill(190, 60, 60);
    textSize(12);
    String msg = "⚠ " + warnings.size() + "件の締切が近づいています： " + warnings.get(0);
    if (warnings.size() > 1) msg += " ほか";
    text(msg, 50, 125);
  }

  void checkNear(String name, String label, String dateStr, int threshold, ArrayList<String> warnings) {
    if (dateStr == null || dateStr.length() == 0) return;
    int diff = daysUntil(dateStr);
    if (diff >= 0 && diff <= threshold) {
      warnings.add(name + "（" + label + "）");
    }
  }

  // "YYYY/MM/DD" 形式の日付が「今日」から何日後かを返す
  // 今日の日付は固定値ではなく、実行時に year()/month()/day() で毎回取得する
  int daysUntil(String dateStr) {
    String[] parts = dateStr.split("/");
    if (parts.length != 3) return 9999;
    int y = int(parts[0]);
    int m = int(parts[1]);
    int d = int(parts[2]);

    int[] cum = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
    int targetDay = y * 365 + cum[m - 1] + d;

    int todayYear = year();
    int todayMonth = month();
    int todayDay = day();
    int todayNum = todayYear * 365 + cum[todayMonth - 1] + todayDay;

    return targetDay - todayNum;
  }
}
