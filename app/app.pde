CompanyRepository repository;
ScreenCompanyList screenList;
ScreenAddEdit screenAddEdit;
CalendarScreen calendarScreen;//小林追加
NavigationBar navigationBar;//小林追加
PFont jpFont;
int currentScreen = 2;
// 追加: ToDo一覧画面と通知設定画面
TodoListScreen todoListScreen;
NotificationScreen notificationScreen;
//サンプルコードです。好きなように編集してください！
void setup() {
  size(1200, 800);
  jpFont = createFont("Meiryo", 32, true);
  textFont(jpFont);
  repository = new CompanyRepository();

  Company c1 = new Company("〇〇株式会社");
  c1.esDeadline = "2026/07/15";
  c1.selectionStatus = "選考中";
  repository.add(c1);

  Company c2 = new Company("△△商事株式会社");
  c2.interview1Date = "2026/07/20";
  c2.selectionStatus = "合格";
  repository.add(c2);

  Company c3 = new Company("株式会社□□システムズ");
  c3.selectionStatus = "不合格";
  repository.add(c3);

  screenList = new ScreenCompanyList(repository);
  screenAddEdit = new ScreenAddEdit(repository);
  calendarScreen = new CalendarScreen(repository);//小林追加
  navigationBar = new NavigationBar();//小林追加

  // 追加: 企業データを使うToDo一覧と通知設定を初期化
  todoListScreen = new TodoListScreen(repository);
  notificationScreen = new NotificationScreen();
}

void keyPressed() {
  if (currentScreen == 2) {
    screenList.handleKeyInput(key);
  } else if (currentScreen == 3) {
    screenAddEdit.handleKeyInput(key);
  }
}

//小林追加
void mousePressed() {
  // 下部ナビゲーションがクリックされたときは、各画面には渡さない
  if (navigationBar.handleInput()) {
    return;
  }

  if (currentScreen == 1) {
    calendarScreen.mousePressed();//小林追加
  } else if (currentScreen == 2) {
    screenList.handleInput();
  } else if (currentScreen == 3) {
    screenAddEdit.handleInput();
  // 追加: ToDo一覧の操作
  } else if (currentScreen == 0) {
    todoListScreen.handleInput();
  // 追加: 通知設定の操作
  } else if (currentScreen == 4) {
    notificationScreen.handleInput();
  }
}

// 追加: ToDoリスト画面でのマウスホイールによるスクロール操作
void mouseWheel(MouseEvent event) {
  if (currentScreen == 0) {
    todoListScreen.handleScroll(event.getCount());
  }
}

void draw() {
  background(255);
  if (currentScreen == 1) {
    calendarScreen.display();//小林追加
  } else if (currentScreen == 2) {
    screenList.display();
  } else if (currentScreen == 3) {
    screenAddEdit.display();
  // 追加: ToDo一覧を表示
  } else if (currentScreen == 0) {
    todoListScreen.display();
  // 追加: 通知設定を表示
  } else if (currentScreen == 4) {
    notificationScreen.display();
  }

  navigationBar.display();
}
