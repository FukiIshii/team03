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

  TodoListScreen(CompanyRepository r) {
    repository = r;
    loadTaskList();
  }

  // CompanyRepository の全企業データを参照してToDoを生成する
  // Company に既にある companyName / esDeadline / interview1Date のみを参照する
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
      if (c.interview1Date.length() > 0) {
        todos.add(makeTodoItem(c, "一次面接", c.interview1Date, "面接予定", doneStates));
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
    drawTable();
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

    int shown = 0;
    for (TodoItem task : todos) {
      if (!filterTaskList(task)) continue;
      float rowY = y + 152 + shown * 70;
      if (rowY + 70 > y + 505) break;

      stroke(225, 232, 241);
      line(x, rowY + 70, x + w, rowY + 70);
      noStroke();

      fill(20, 30, 45);
      textSize(16);
      text(task.company.companyName, col[0], rowY + 42);

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

      shown++; // 表示した行だけカウントする（重なり表示バグの修正）
    }

    if (shown == 0) {
      fill(150);
      textSize(20);
      text("表示できるタスクがありません", x + 25, y + 190);
    }
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

  String statusLabelFor(TodoItem task) {
    if (task.done) return "完了";
    if (task.task.equals("ES提出")) return "未提出";
    return "予定";
  }

  color tagColor(String task) {
    if (task.equals("ES提出")) return color(255, 220, 220);
    return color(255, 224, 178);
  }

  color tagTextColor(String task) {
    if (task.equals("ES提出")) return color(200, 60, 60);
    return color(180, 120, 40);
  }

  color statusColor(String status) {
    if (status.equals("未提出")) return color(255, 220, 220);
    if (status.equals("完了")) return color(210, 240, 220);
    return color(210, 230, 255);
  }

  color statusTextColor(String status) {
    if (status.equals("未提出")) return color(200, 60, 60);
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
        return;
      }
    }

    int shown = 0;
    for (TodoItem task : todos) {
      if (!filterTaskList(task)) continue;
      float rowY = y + 152 + shown * 70;
      if (rowY + 70 > y + 505) break;

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

      shown++;
    }
  }
}
