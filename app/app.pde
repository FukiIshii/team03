CompanyRepository repository;
ScreenCompanyList screenList;
ScreenAddEdit screenAddEdit;
PFont jpFont;
int currentScreen = 2;
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
}

void keyPressed() {
  if (currentScreen == 2) {
    screenList.handleKeyInput(key);
  } else if (currentScreen == 3) {
    screenAddEdit.handleKeyInput(key);
  }
}

void mousePressed() {
  if (currentScreen == 2) {
    screenList.handleInput();
  }else if (currentScreen == 3) {
    screenAddEdit.handleInput();
  }
}

void draw() {
  if (currentScreen == 2) {
    screenList.display();
  } else if (currentScreen == 3) {
    screenAddEdit.display();
  }
}
