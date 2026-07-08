CompanyRepository repository;

void setup() {
  size(1200, 800);
  repository = new CompanyRepository();

  // サンプルデータ（みんなが自分の画面をテストするためのダミー）好きなように編集してください
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

  // 動作確認
  println("登録件数: " + repository.getAll().size()); // 3 と出ればOK
  println(repository.searchByName("商事").size());     // 1 と出ればOK
}

void draw() {
  background(255);
}
