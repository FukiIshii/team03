class ScreenAddEdit {
  CompanyRepository repository;
  Company targetCompany;
  boolean isEditMode = false;
  String selectedStatus = "選考中";
  String errorMessage = "";

  InputField companyNameField, urlField, idField;
  InputField esDeadlineField, spiDeadlineField, internshipField;
  InputField interview1Field, interview2Field, interview3Field, photoField;
  ArrayList<InputField> allFields;

  float pillY = 290, pillH = 28, pillW = 80;
  float pill1X = 40, pill2X = 130, pill3X = 220;

  float saveBtnX = 700, saveBtnY = 600, saveBtnW = 160, saveBtnH = 40;
  float backBtnX = 40, backBtnY = 600, backBtnW = 140, backBtnH = 40;

  ScreenAddEdit(CompanyRepository r) {
    repository = r;

    companyNameField = new InputField("企業名", 40, 108, 300, 32);
    urlField         = new InputField("マイページURL", 40, 163, 300, 32);
    idField          = new InputField("マイページID", 40, 218, 300, 32);

    esDeadlineField  = new InputField("ES締切日", 400, 108, 300, 32);
    spiDeadlineField = new InputField("SPI締切日", 400, 163, 300, 32);
    internshipField  = new InputField("インターンシップ日", 400, 218, 300, 32);
    interview1Field  = new InputField("一次面接日", 400, 273, 300, 32);
    interview2Field  = new InputField("二次面接日", 400, 328, 300, 32);
    interview3Field  = new InputField("三次面接日", 400, 383, 300, 32);
    photoField       = new InputField("顔写真提出日", 400, 438, 300, 32);

    allFields = new ArrayList<InputField>();
    allFields.add(companyNameField);
    allFields.add(urlField);
    allFields.add(idField);
    allFields.add(esDeadlineField);
    allFields.add(spiDeadlineField);
    allFields.add(internshipField);
    allFields.add(interview1Field);
    allFields.add(interview2Field);
    allFields.add(interview3Field);
    allFields.add(photoField);
  }

  void startNewEntry() {
    targetCompany = null;
    isEditMode = false;
    selectedStatus = "選考中";
    errorMessage = "";
    for (InputField f : allFields) { f.value = ""; f.isActive = false; }
  }

  void startEdit(Company c) {
    targetCompany = c;
    isEditMode = true;
    selectedStatus = c.selectionStatus;
    errorMessage = "";

    companyNameField.value = c.companyName;
    urlField.value = c.myPageUrl;
    idField.value = c.loginId;
    esDeadlineField.value = c.esDeadline;
    spiDeadlineField.value = c.spiDeadline;
    internshipField.value = c.internshipDate;
    interview1Field.value = c.interview1Date;
    interview2Field.value = c.interview2Date;
    interview3Field.value = c.interview3Date;
    photoField.value = c.photoDeadline;
  }

  void display() {
    background(255);
    fill(60);
    textSize(22);
    text(isEditMode ? "企業情報の編集" : "企業情報の追加", 40, 50);

    for (InputField f : allFields) f.display();

    fill(139, 135, 160);
    textSize(11);
    text("選考結果ステータス", 40, 275);
    drawStatusPill("選考中", pill1X, pillY);
    drawStatusPill("合格", pill2X, pillY);
    drawStatusPill("不合格", pill3X, pillY);

    if (!errorMessage.equals("")) {
      fill(220, 90, 90);
      textSize(11);
      text(errorMessage, 40, 560);
    }

    noFill();
    stroke(180);
    rect(backBtnX, backBtnY, backBtnW, backBtnH, 20);
    noStroke();
    fill(100);
    textSize(12);
    text("← 一覧に戻る", backBtnX + 20, backBtnY + 25);

    fill(120, 190, 150);
    rect(saveBtnX, saveBtnY, saveBtnW, saveBtnH, 20);
    fill(255);
    textSize(13);
    text("保存する", saveBtnX + 45, saveBtnY + 25);
  }

  void drawStatusPill(String label, float x, float y) {
    if (selectedStatus.equals(label)) {
      fill(159, 174, 234);
      noStroke();
    } else {
      noFill();
      stroke(200);
    }
    rect(x, y, pillW, pillH, 14);
    noStroke();
    fill(selectedStatus.equals(label) ? 255 : 100);
    textSize(10);
    text(label, x + 14, y + 18);
  }

  void handleInput() {
    for (InputField f : allFields) f.handleClick(mouseX, mouseY);

    if (isInside(mouseX, mouseY, pill1X, pillY, pillW, pillH)) selectedStatus = "選考中";
    if (isInside(mouseX, mouseY, pill2X, pillY, pillW, pillH)) selectedStatus = "合格";
    if (isInside(mouseX, mouseY, pill3X, pillY, pillW, pillH)) selectedStatus = "不合格";

    if (isInside(mouseX, mouseY, saveBtnX, saveBtnY, saveBtnW, saveBtnH)) save();
    if (isInside(mouseX, mouseY, backBtnX, backBtnY, backBtnW, backBtnH)) currentScreen = 2;
  }

  boolean isInside(float px, float py, float x, float y, float w, float h) {
    return px > x && px < x + w && py > y && py < y + h;
  }

  void handleKeyInput(char k) {
    for (InputField f : allFields) f.handleKey(k);
  }

  boolean validateInput() {
    if (companyNameField.value.equals("")) {
      errorMessage = "企業名を入力してください";
      return false;
    }
    errorMessage = "";
    return true;
  }

  void pasteToActiveField(String text) {
  for (InputField f : allFields) f.pasteText(text);
  }

  void save() {
    if (!validateInput()) return;

    if (isEditMode) {
      targetCompany.companyName = companyNameField.value;
      targetCompany.myPageUrl = urlField.value;
      targetCompany.loginId = idField.value;
      targetCompany.esDeadline = esDeadlineField.value;
      targetCompany.spiDeadline = spiDeadlineField.value;
      targetCompany.internshipDate = internshipField.value;
      targetCompany.interview1Date = interview1Field.value;
      targetCompany.interview2Date = interview2Field.value;
      targetCompany.interview3Date = interview3Field.value;
      targetCompany.photoDeadline = photoField.value;
      targetCompany.selectionStatus = selectedStatus;
      repository.update(targetCompany);
    } else {
      Company newCompany = new Company(companyNameField.value);
      newCompany.myPageUrl = urlField.value;
      newCompany.loginId = idField.value;
      newCompany.esDeadline = esDeadlineField.value;
      newCompany.spiDeadline = spiDeadlineField.value;
      newCompany.internshipDate = internshipField.value;
      newCompany.interview1Date = interview1Field.value;
      newCompany.interview2Date = interview2Field.value;
      newCompany.interview3Date = interview3Field.value;
      newCompany.photoDeadline = photoField.value;
      newCompany.selectionStatus = selectedStatus;
      repository.add(newCompany);
    }

    screenList.displayedCompanies = repository.getAll();

    // 企業情報の追加・編集を保存したタイミングで、ToDoリストの内容も更新する
    // （ToDoリストは起動時に一度しか読み込まれないため、ここで呼ばないと反映されない）
    todoListScreen.loadTaskList();

    currentScreen = 2;
  }
}
