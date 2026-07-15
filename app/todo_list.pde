class TodoItem {
  Company company;
  String task;
  String deadline;
  String memo;
  boolean done = false;

  TodoItem(Company c, String t, String d, String m) {
    company = c;
    task = t;
    deadline = d;
    memo = m;
  }
}

class TodoListScreen {
  CompanyRepository repository;
  ArrayList<TodoItem> todos = new ArrayList<TodoItem>();
  int filter = 0; // 0:すべて 1:未完了 2:完了

  // スクロール関連
  int scrollOffset = 0;        // 何件分スクロールしたか（先頭から何件目を表示開始にするか）
  final int maxVisibleRows = 5; // テーブル枠内に一度に表示できる行数（505pxの枠に収まる数）

  TodoListScreen(CompanyRepository r) {
    repository = r;
    loadTaskList();
  }

  // CompanyRepository の全企業データを参照してToDoを生成する
  // Company が持つ各種期限・日程（ES提出／SPI受験／インターンシップ／一次〜三次面接／顔写真提出）を参照する
  //
  // 企業の追加・編集後や、ToDoリスト画面に戻ってきたタイミングで再度呼び出すことを想定している。
  // 呼び出すたびに TodoItem を作り直すため、再構築前に完了状態（done）を退避し、
  // 再構築後に同じ企業・同じタスク内容のものへ復元することで、
  // 「更新すると完了チェックが消える」という問題が起きないようにしている。
  void loadTaskList() {
    // 企業オブジェクト（identityHashCode）とタスク内容の組をキーに、完了状態を退避する
    HashMap<String, Boolean> doneStates = new HashMap<String, Boolean>();
    for (TodoItem t : todos) {
      doneStates.put(doneStateKey(t.company, t.task), t.done);
    }

    todos.clear();
    for (Company c : repository.getAll()) {
      if (c.esDeadline.length() > 0) {
        todos.add(makeTodoItem(c, "ES提出", c.esDeadline, "提出期限を確認", doneStates));
      }
      if (c.spiDeadline.length() > 0) {
        todos.add(makeTodoItem(c, "SPI受験", c.spiDeadline, "受験期限を確認", doneStates));
      }
      if (c.internshipDate.length() > 0) {
        todos.add(makeTodoItem(c, "インターンシップ", c.internshipDate, "インターン当日", doneStates));
      }
      if (c.interview1Date.length() > 0) {
        todos.add(makeTodoItem(c, "一次面接", c.interview1Date, "面接予定", doneStates));
      }
      if (c.interview2Date.length() > 0) {
        todos.add(makeTodoItem(c, "二次面接", c.interview2Date, "面接予定", doneStates));
      }
      if (c.interview3Date.length() > 0) {
        todos.add(makeTodoItem(c, "三次面接", c.interview3Date, "面接予定", doneStates));
      }
      if (c.photoDeadline.length() > 0) {
        todos.add(makeTodoItem(c, "顔写真提出", c.photoDeadline, "提出期限を確認", doneStates));
      }
    }
    sortByDeadline();
  }

  TodoItem makeTodoItem(Company c, String task, String deadline, String memo, HashMap<String, Boolean> doneStates) {
    TodoItem item = new TodoItem(c, task, deadline, memo);
    String key = doneStateKey(c, task);
    if (doneStates.containsKey(key)) {
      item.done = doneStates.get(key);
    }
    return item;
  }

  // Company は同一性で区別する（identityHashCode）。企業名の重複があっても混同しないようにするため。
  String doneStateKey(Company c, String task) {
    return System.identityHashCode(c) + "_" + task;
  }

  // 期限（yyyy/MM/dd）を昇順に並べ替える
  void sortByDeadline() {
    for (int i = 0; i < todos.size() - 1; i++) {
      for (int j = i + 1; j < todos.size(); j++) {
        if (todos.get(i).deadline.compareTo(todos.get(j).deadline) > 0) {
          TodoItem temp = todos.get(i);
          todos.set(i, todos.get(j));
          todos.set(j, temp);
        }
      }
    }
  }

  boolean filterTaskList(TodoItem task) {
    return filter == 0 || (filter == 1 && !task.done) || (filter == 2 && task.done);
  }

  // 現在のフィルタ条件を満たすタスクだけを抽出する
  // drawTable() と handleInput() の両方で同じ並びを使うことで、表示とクリック判定のずれを防ぐ
  ArrayList<TodoItem> getFilteredTasks() {
    ArrayList<TodoItem> result = new ArrayList<TodoItem>();
    for (TodoItem task : todos) {
      if (filterTaskList(task)) result.add(task);
    }
    return result;
  }

  // タスクの締切状況を判定する（"overdue"：期限切れ／"near"：期限間近／"none"：問題なし）
  // 「期限間近」の基準は、通知設定画面（notificationScreen）で設定されているタイミングをそのまま使う。
  // アプリ内通知がOFFの場合、完了済みのタスク、選考が終わっている企業（合格／不合格）は警告不要のため対象外とする。
  String urgencyFor(TodoItem task) {
    if (!notificationScreen.notifyInApp) return "none";
    if (task.done) return "none";
    if (!task.company.selectionStatus.equals("選考中")) return "none";
    int diff = notificationScreen.daysUntil(task.deadline);
    if (diff < 0) return "overdue";
    int threshold = notificationScreen.timingDays[notificationScreen.timingIndex];
    if (diff <= threshold) return "near";
    return "none";
  }

  // scrollOffset が範囲外にならないように調整する
  void clampScrollOffset(int totalCount) {
    int maxOffset = max(0, totalCount - maxVisibleRows);
    if (scrollOffset > maxOffset) scrollOffset = maxOffset;
    if (scrollOffset < 0) scrollOffset = 0;
  }

  // マウスホイールでのスクロール操作を受け取る（app.pde の mouseWheel() から呼ばれる）
  void handleScroll(int amount) {
    scrollOffset += amount;
    clampScrollOffset(getFilteredTasks().size());
  }

  void display() {
    noStroke();
    fill(255);
    rect(0, 0, width, 740);
    fill(15, 22, 33);
    textSize(31);
    text("ToDo リスト", 45, 65);
    fill(60, 70, 84);
    textSize(16);
    text("期限が早い順に表示しています。", 45, 102);
    drawLegend();
    drawTable();
  }

  // 「期限切れ」「期限間近」の色の意味を示す簡単な凡例
  void drawLegend() {
    float lx = 780, ly = 92;
    noStroke();
    fill(215, 60, 60);
    rect(lx, ly, 12, 12, 2);
    fill(90, 90, 90);
    textSize(12);
    text("期限切れ", lx + 18, ly + 11);

    fill(230, 170, 30);
    rect(lx + 95, ly, 12, 12, 2);
    fill(90, 90, 90);
    text("期限間近", lx + 113, ly + 11);
  }

  void drawTable() {
    float x = 35, y = 140, w = 1130;
    stroke(215, 226, 240);
    fill(255);
    rect(x, y, w, 505, 8);
    noStroke();

    String[] tabs = {"すべて", "未完了", "完了"};
    for (int i = 0; i < 3; i++) {
      float tx = x + 20 + i * 115;
      if (i == filter) {
        noStroke();
        fill(0, 112, 235);
        rect(tx - 8, y + 17, 78, 48, 6);
        fill(255);
      } else {
        fill(0, 100, 220);
      }
      textSize(18);
      text(tabs[i], tx + 8, y + 48);
    }

    noStroke();
    fill(239, 247, 255);
    rect(x + 1, y + 82, w - 2, 70);
    String[] heads = {"企業名", "タスク内容", "期限", "状況", "備考"};
    float[] col = {x + 25, x + 250, x + 480, x + 690, x + 860};
    fill(20, 30, 45);
    textSize(17);
    for (int i = 0; i < heads.length; i++) text(heads[i], col[i], y + 125);

    ArrayList<TodoItem> filtered = getFilteredTasks();
    clampScrollOffset(filtered.size());

    int endIndex = min(filtered.size(), scrollOffset + maxVisibleRows);
    for (int i = scrollOffset; i < endIndex; i++) {
      TodoItem task = filtered.get(i);
      int shown = i - scrollOffset;
      float rowY = y + 152 + shown * 70;

      // 締切状況に応じた警告帯（期限切れ＝赤、期限間近＝黄）を先に描画してから、その上に内容を重ねる
      String urgency = urgencyFor(task);
      drawWarningBand(x, rowY, w, urgency);

      stroke(225, 232, 241);
      line(x, rowY + 70, x + w, rowY + 70);
      noStroke();

      fill(20, 30, 45);
      textSize(16);
      text(task.company.companyName, col[0], rowY + 30);

      // 選考ステータスタグ：企業一覧画面（screenList）と同じ色分けロジックを再利用し、表示を対応させる
      String status = task.company.selectionStatus;
      drawSmallTag(status, col[0], rowY + 40, screenList.statusColor(status), color(255));

      drawTag(task.task, col[1], rowY + 18, tagColor(task.task), tagTextColor(task.task));

      fill(80);
      textSize(14);
      text(task.deadline, col[2], rowY + 42);

      String statusLabel = statusLabelFor(task);
      drawTag(statusLabel, col[3], rowY + 18, statusColor(statusLabel), statusTextColor(statusLabel));

      fill(110);
      textSize(12);
      text(task.memo, col[4], rowY + 42);

      fill(180);
      textSize(14);
      text(">", x + w - 25, rowY + 42);
    }

    if (filtered.size() == 0) {
      fill(180);
      textSize(20);
      text("表示できるタスクがありません", x + 25, y + 180);
    } else if (filtered.size() > maxVisibleRows) {
      drawScrollbar(x, y, w, filtered.size());
    }
  }

  // 締切状況に応じて行に警告帯を描画する
  // overdue（期限切れ）＝赤、near（期限間近）＝黄。それぞれ行全体をうっすら着色し、左端に濃い色のバーを添える。
  void drawWarningBand(float x, float rowY, float w, String urgency) {
    if (urgency.equals("none")) return;

    color rowTint, barColor;
    if (urgency.equals("overdue")) {
      rowTint = color(255, 232, 232);
      barColor = color(215, 60, 60);
    } else {
      rowTint = color(255, 247, 214);
      barColor = color(230, 170, 30);
    }

    noStroke();
    fill(rowTint);
    rect(x + 1, rowY, w - 2, 70);
    fill(barColor);
    rect(x + 1, rowY, 5, 70);
  }

  // 表示しきれないタスクがある場合に、枠の右端にスクロールバーを描画する
  void drawScrollbar(float x, float y, float w, int totalCount) {
    float trackX = x + w - 14;
    float trackY = y + 152;
    float trackH = maxVisibleRows * 70; // 行が並ぶ領域の高さ

    noStroke();
    fill(235, 240, 248);
    rect(trackX, trackY, 5, trackH, 3);

    float thumbH = max(24, trackH * maxVisibleRows / (float) totalCount);
    int maxOffset = max(1, totalCount - maxVisibleRows);
    float thumbY = trackY + (trackH - thumbH) * (scrollOffset / (float) maxOffset);
    fill(170, 185, 205);
    rect(trackX, thumbY, 5, thumbH, 3);
  }

  void drawTag(String label, float x, float y, color bg, color fg) {
    noStroke();
    fill(bg);
    float w = textWidth(label) + 24;
    rect(x, y, w, 26, 13);
    fill(fg);
    textSize(12);
    text(label, x + 12, y + 18);
  }

  // 企業名の下に表示する小さめのタグ（選考ステータス表示用）
  void drawSmallTag(String label, float x, float y, color bg, color fg) {
    textSize(10);
    noStroke();
    fill(bg);
    float w = textWidth(label) + 16;
    rect(x, y, w, 17, 8);
    fill(fg);
    text(label, x + 8, y + 12);
  }

  String statusLabelFor(TodoItem task) {
    if (task.done) return "完了";
    if (task.task.equals("ES提出")) return "未提出";
    if (task.task.equals("SPI受験")) return "未受験";
    if (task.task.equals("顔写真提出")) return "未提出";
    return "予定";
  }

  color tagColor(String task) {
    if (task.equals("ES提出")) return color(255, 220, 220);
    if (task.equals("SPI受験")) return color(225, 210, 250);
    if (task.equals("インターンシップ")) return color(205, 235, 210);
    if (task.equals("一次面接")) return color(255, 224, 178);
    if (task.equals("二次面接")) return color(255, 236, 153);
    if (task.equals("三次面接")) return color(240, 200, 160);
    if (task.equals("顔写真提出")) return color(220, 226, 236);
    return color(230, 230, 230);
  }

  color tagTextColor(String task) {
    if (task.equals("ES提出")) return color(200, 60, 60);
    if (task.equals("SPI受験")) return color(120, 70, 190);
    if (task.equals("インターンシップ")) return color(50, 140, 80);
    if (task.equals("一次面接")) return color(180, 120, 40);
    if (task.equals("二次面接")) return color(150, 110, 20);
    if (task.equals("三次面接")) return color(130, 80, 30);
    if (task.equals("顔写真提出")) return color(90, 100, 120);
    return color(100, 100, 100);
  }

  color statusColor(String status) {
    if (status.equals("未提出") || status.equals("未受験")) return color(255, 220, 220);
    if (status.equals("完了")) return color(210, 240, 220);
    return color(210, 230, 255);
  }

  color statusTextColor(String status) {
    if (status.equals("未提出") || status.equals("未受験")) return color(200, 60, 60);
    if (status.equals("完了")) return color(60, 150, 90);
    return color(60, 100, 190);
  }

  // タブのクリック、状況バッジのクリック（完了/未完了の切り替え）、
  // 行のそれ以外の部分のクリック（企業の編集画面へ移動）を処理する
  void handleInput() {
    float x = 35, y = 140, w = 1130;
    float[] col = {x + 25, x + 250, x + 480, x + 690, x + 860};

    // タブ切り替え
    for (int i = 0; i < 3; i++) {
      float tx = x + 20 + i * 115;
      if (mouseX >= tx - 8 && mouseX <= tx - 8 + 78 && mouseY >= y + 17 && mouseY <= y + 17 + 48) {
        filter = i;
        scrollOffset = 0; // タブを切り替えたら表示位置を先頭に戻す
        return;
      }
    }

    // 表示中の内容（drawTable と同じフィルタ・スクロール位置）に対してクリック判定を行う
    ArrayList<TodoItem> filtered = getFilteredTasks();
    clampScrollOffset(filtered.size());
    int endIndex = min(filtered.size(), scrollOffset + maxVisibleRows);

    for (int i = scrollOffset; i < endIndex; i++) {
      TodoItem task = filtered.get(i);
      int shown = i - scrollOffset;
      float rowY = y + 152 + shown * 70;

      // 状況バッジをクリックしたら完了/未完了を切り替える（それ以外の判定より先にチェック）
      String statusLabel = statusLabelFor(task);
      float tagX = col[3];
      float tagY = rowY + 18;
      float tagW = textWidth(statusLabel) + 24;
      float tagH = 26;
      if (mouseX >= tagX && mouseX <= tagX + tagW && mouseY >= tagY && mouseY <= tagY + tagH) {
        task.done = !task.done;
        return;
      }

      // 行のそれ以外の場所をクリックしたら、その企業の編集画面へ移動する
      if (mouseX >= x && mouseX <= x + w && mouseY >= rowY - 20 && mouseY <= rowY + 50) {
        screenAddEdit.startEdit(task.company);
        currentScreen = 3;
        return;
      }
    }
  }
}
