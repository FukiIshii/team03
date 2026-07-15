import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.io.File;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.DataFlavor;

CompanyRepository repository;
ScreenCompanyList screenList;
ScreenAddEdit screenAddEdit;
CalendarScreen calendarScreen;//小林追加
NavigationBar navigationBar;//小林追加
PFont jpFont;
int currentScreen = 0;
boolean ctrlDown = false;
// 追加: ToDo一覧画面と通知設定画面
TodoListScreen todoListScreen;
NotificationScreen notificationScreen;
//サンプルコードです。好きなように編集してください！
void setup() {
  size(1200, 800);
  jpFont = createFont("Meiryo", 32, true);
  textFont(jpFont);
  repository = new CompanyRepository();
  repository.loadFromFile();

  if (repository.getAll().size() == 0){
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
 }

  screenList = new ScreenCompanyList(repository);
  screenAddEdit = new ScreenAddEdit(repository);
  calendarScreen = new CalendarScreen(repository);//小林追加
  navigationBar = new NavigationBar();//小林追加

  // 追加: 企業データを使うToDo一覧と通知設定を初期化
  todoListScreen = new TodoListScreen(repository);
  notificationScreen = new NotificationScreen();
}

void keyPressed() {
  if (keyCode == CONTROL) {
    ctrlDown = true;
    return;
  }

  if (ctrlDown && keyCode == 86) { // Ctrl+V（Vのキーコード）
    String pasted = getClipboardText();
    if (currentScreen == 2) {
      screenList.pasteToActiveField(pasted);
    } else if (currentScreen == 3) {
      screenAddEdit.pasteToActiveField(pasted);
    }
    return;
  }

  if (currentScreen == 2) {
    screenList.handleKeyInput(key);
  } else if (currentScreen == 3) {
    screenAddEdit.handleKeyInput(key);
  }
}

void keyReleased() {
  if (keyCode == CONTROL) ctrlDown = false;
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

String getClipboardText() {
  try {
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    if (clipboard.isDataFlavorAvailable(DataFlavor.stringFlavor)) {
      return (String) clipboard.getData(DataFlavor.stringFlavor);
    }
  } catch (Exception e) {
    println("クリップボード取得エラー: " + e.getMessage());
  }
  return "";
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
    notificationScreen.displayWarning(repository);
  // 追加: 通知設定を表示
  } else if (currentScreen == 4) {
    notificationScreen.display();
  }

  navigationBar.display();
}
