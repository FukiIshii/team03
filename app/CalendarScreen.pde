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

    drawMonthSelector();
    drawCalendar();
    drawDetail();
  }

  void drawMonthSelector() {
    //7月は前月ボタンを無効化
    if(displayMonth==7){
      fill(210);
    }else{
    fill(80, 130, 210);
    }
    rect(170, 45, 45, 30, 6);
    
    //12月では翌月ボタンを無効化
    if(displayMonth==12){
      fill(210);
    }else{
      fill(80,130,210);
    }
    rect(330,45,45,30,6);

    fill(255);
    textSize(18);
    text("＜", 181, 67);
    text("＞", 341, 67);

    fill(60);
    textSize(18);
    text(displayYear + "年" + displayMonth + "月", 230, 67);
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

    int firstWeekday = getFirstWeekday(displayYear, displayMonth);
    int daysInMonth = getDaysInMonth(displayMonth);

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

  int drawEventIfMatches(Company c, String eventDate, String label,
                         String date, float x, int y, color eventColor) {
    if (!eventDate.equals(date)) return y;

    fill(eventColor);
    textSize(10);
    text(label + " " + c.companyName, x + 8, y);
    return y + 12;
  }

  void mousePressed() {
    // 前月：7月より前には移動しない
    if (mouseX >= 170 && mouseX <= 215 && mouseY >= 45 && mouseY <= 75) {
      if (displayMonth > 7) {
        displayMonth--;
        selectedDay = -1;
      }
      return;
    }

    // 次月：12月より後には移動しない
    if (mouseX >= 330 && mouseX <= 375 && mouseY >= 45 && mouseY <= 75) {
      if (displayMonth < 12) {
        displayMonth++;
        selectedDay = -1;
      }
      return;
    }

    int startX = 40;
    int startY = 145;
    int cellW = 115;
    int cellH = 82;
    int firstWeekday = getFirstWeekday(displayYear, displayMonth);
    int daysInMonth = getDaysInMonth(displayMonth);

    for (int day = 1; day <= daysInMonth; day++) {
      int index = firstWeekday + day - 1;
      int row = index / 7;
      int col = index % 7;
      float x = startX + col * cellW;
      float y = startY + row * cellH;

      if (mouseX >= x && mouseX <= x + 105 &&
          mouseY >= y && mouseY <= y + 72) {
        selectedDay = day;
        return;
      }
    }
  }

  int getDaysInMonth(int month) {
    int[] days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    return days[month - 1];
  }

  // 日曜=0、月曜=1 … 土曜=6
  int getFirstWeekday(int year, int month) {
    int[] table = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};

    if (month < 3) year--;

    return (year + year / 4 - year / 100 + year / 400
      + table[month - 1] + 1) % 7;
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
    fill(80);
    textSize(13);
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

  int drawDetailIfMatches(Company c, String eventDate, String label,
                          String date, float x, int y) {
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
