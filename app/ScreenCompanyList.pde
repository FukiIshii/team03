class ScreenCompanyList {
  CompanyRepository repository;
  String searchKeyword = "";
  ArrayList<Company> displayedCompanies;
  Company selectedCompany;

  float addBtnX = 860, addBtnY = 40, addBtnW = 200, addBtnH = 40;
  float tableStartY = 210, rowHeight = 50;
  float editBtnX = 780, deleteBtnX = 860, actionBtnW = 70, actionBtnH = 26;
  
  ScreenCompanyList(CompanyRepository r) {
    repository = r;
    displayedCompanies = repository.getAll();
  }

 void display() {
    background(255);
    fill(60);
    textSize(22);
    text("企業一覧", 40, 50);

    fill(90, 160, 130);
    rect(addBtnX, addBtnY, addBtnW, addBtnH, 18);
    fill(255);
    textSize(13);
    text("＋ 新規企業を追加", addBtnX + 20, addBtnY + 25);

    fill(80, 100, 200);
    textSize(12);
    text("企業名", 40, 160);
    text("選考ステータス", 320, 160);
    text("直近の締切", 520, 160);
    text("操作", 780, 160);
    stroke(230);
    line(40, 172, 1060, 172);
    noStroke();

    float y = tableStartY;
    for (Company c : displayedCompanies) {
      fill(60);
      textSize(13);
      text(c.companyName, 40, y);

      fill(statusColor(c.selectionStatus));
      rect(320, y - 18, 80, 26, 13);
      fill(255);
      textSize(11);
      text(c.selectionStatus, 335, y);

      fill(120);
      textSize(12);
      text(c.getNearestDeadline(), 520, y);

      noFill();
      stroke(150);
      rect(editBtnX, y - 18, actionBtnW, actionBtnH, 13);
      rect(deleteBtnX, y - 18, actionBtnW, actionBtnH, 13);
      noStroke();
      fill(80);
      textSize(11);
      text("編集", editBtnX + 20, y);
      fill(200, 90, 70);
      text("削除", deleteBtnX + 20, y);

      y += rowHeight;
    }
  }

  void handleInput() {
    if (isInside(mouseX, mouseY, addBtnX, addBtnY, addBtnW, addBtnH)) {
      onClickAddNew();
      return; 
    }

    float y = tableStartY;
    for (Company c : displayedCompanies) {
      float btnY = y - 18; 

      if (isInside(mouseX, mouseY, editBtnX, btnY, actionBtnW, actionBtnH)) {
        onClickEdit(c);
        return;
      }
      if (isInside(mouseX, mouseY, deleteBtnX, btnY, actionBtnW, actionBtnH)) {
        onClickDelete(c);
        return;
      }
      y += rowHeight;
    }
  }

  boolean isInside(float px, float py, float x, float y, float w, float h) {
    return px > x && px < x + w && py > y && py < y + h;
  }

  void onClickAddNew() {
    screenAddEdit.startNewEntry();
    currentScreen = 3; // TODO: 
  }

  void onClickEdit(Company c) {
    screenAddEdit.startEdit(c);
    selectedCompany = c;
    currentScreen = 3; 
  }

  void onClickDelete(Company c) {
    println("削除: " + c.companyName);
    repository.remove(c);
    displayedCompanies = repository.getAll(); 
  }

  color statusColor(String status) {
    if (status.equals("合格")) return color(120, 190, 150);
    if (status.equals("不合格")) return color(230, 140, 120);
    return color(140, 160, 230);
  }
}
