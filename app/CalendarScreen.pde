class CalendarScreen {
  CompanyRepository repository;
  int selectedDay = -1;
  int displayYear = 2026;
  int displayMonth = 7;

  CalendarScreen(CompanyRepository repository) {
    this.repository = repository;
  }

  void display() {
    background(255);
    fill(60);
    textSize(22);
    text("カレンダー", 40, 50);
    textSize(14);
    fill(120);
    text(displayYear + "年" + displayMonth + "月", 40, 82);

    drawCalendar();
    drawDetail();
  }

  void drawCalendar() {
    int startX = 40;
    int startY = 145;
    int cellW = 115;
    int cellH = 82;
    String[] week = {"日", "月", "火", "水", "木", "金", "土"};

    textSize(14);
    for (int i = 0; i < 7; i++) {
      fill(i == 0 ? color(220, 90, 90) : (i == 6 ? color(70, 110, 210) : color(80)));
      text(week[i], startX + i * cellW + 48, startY - 12);
    }

    int firstWeekday = 3; // 2026年7月1日は水曜日
    int daysInMonth = 31;
    for (int day = 1; day <= daysInMonth; day++) {
      int index = firstWeekday + day - 1;
      int row = index / 7;
      int col = index % 7;
      float x = startX + col * cellW;
      float y = startY + row * cellH;

      fill(day == selectedDay ? color(230, 240, 255) : color(250));
      stroke(220);
      rect(x, y, 105, 72, 6);
      noStroke();
      fill(60);
      textSize(14);
      text(day, x + 8, y + 20);

      String date = dateFor(day);
      int eventY = int(y + 38);
      for (Company c : repository.getAll()) {
        eventY = drawEventIfMatches(c, c.esDeadline, "ES提出", date, x, eventY, color(220, 80, 80));
        eventY = drawEventIfMatches(c, c.spiDeadline, "SPI", date, x, eventY, color(230, 150, 60));
        eventY = drawEventIfMatches(c, c.internshipDate, "インターン", date, x, eventY, color(80, 160, 130));
        eventY = drawEventIfMatches(c, c.interview1Date, "一次面接", date, x, eventY, color(80, 120, 210));
        eventY = drawEventIfMatches(c, c.interview2Date, "二次面接", date, x, eventY, color(100, 100, 210));
        eventY = drawEventIfMatches(c, c.interview3Date, "三次面接", date, x, eventY, color(130, 90, 190));
      }
    }
  }

  int drawEventIfMatches(Company c, String eventDate, String label, String date, float x, int y, color eventColor) {
    if (!eventDate.equals(date)) return y;
    fill(eventColor);
    textSize(10);
    text(label + " " + c.companyName, x + 8, y);
    return y + 12;
  }

  void mousePressed() {
    int startX = 40;
    int startY = 145;
    int cellW = 115;
    int cellH = 82;
    int firstWeekday = 3;
    for (int day = 1; day <= 31; day++) {
      int index = firstWeekday + day - 1;
      int row = index / 7;
      int col = index % 7;
      float x = startX + col * cellW;
      float y = startY + row * cellH;
      if (mouseX >= x && mouseX <= x + 105 && mouseY >= y && mouseY <= y + 72) {
        selectedDay = day;
        return;
      }
    }
  }

  void drawDetail() {
    float x = 875;
    float y = 115;
    fill(246, 247, 251);
    rect(x, y, 280, 560, 8);
    fill(60);
    textSize(18);
    text("予定詳細", x + 18, y + 35);

    if (selectedDay == -1) {
      textSize(13);
      fill(120);
      text("日付を選択してください", x + 18, y + 70);
      return;
    }

    String date = dateFor(selectedDay);
    textSize(13);
    fill(80);
    text(date, x + 18, y + 65);
    int detailY = int(y + 100);
    for (Company c : repository.getAll()) {
      detailY = drawDetailIfMatches(c, c.esDeadline, "ES提出", date, x, detailY);
      detailY = drawDetailIfMatches(c, c.spiDeadline, "SPI受験", date, x, detailY);
      detailY = drawDetailIfMatches(c, c.internshipDate, "インターンシップ", date, x, detailY);
      detailY = drawDetailIfMatches(c, c.interview1Date, "一次面接", date, x, detailY);
      detailY = drawDetailIfMatches(c, c.interview2Date, "二次面接", date, x, detailY);
      detailY = drawDetailIfMatches(c, c.interview3Date, "三次面接", date, x, detailY);
    }
    if (detailY == int(y + 100)) {
      fill(120);
      text("予定はありません", x + 18, detailY);
    }
  }

  int drawDetailIfMatches(Company c, String eventDate, String label, String date, float x, int y) {
    if (!eventDate.equals(date) || y > 625) return y;
    fill(60);
    textSize(13);
    text(c.companyName, x + 18, y);
    fill(90, 120, 200);
    textSize(12);
    text(label + "  " + c.selectionStatus, x + 18, y + 20);
    return y + 50;
  }

  String dateFor(int day) {
    return displayYear + "/" + nf(displayMonth, 2) + "/" + nf(day, 2);
  }
}
