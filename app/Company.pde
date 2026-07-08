class Company{
  String companyName;
  String loginId;
  String password;
  String myPageUrl;
  String email;
  String esDeadline;
  boolean esStatus;
  String spiDeadline;
  String photoDeadline;
  String internshipDate;
  String interview1Date;
  String interview2Date;
  String interview3Date;
  String selectionStatus;
  String memo;
  
  Company(String name) {
    companyName = name;
    esStatus = false;
    selectionStatus = "選考中";
    
    loginId = "";
    password = "";
    myPageUrl = "";
    email = "";
    esDeadline = "";
    spiDeadline = "";
    photoDeadline = "";
    internshipDate = "";
    interview1Date = "";
    interview2Date = "";
    interview3Date = "";
    memo = "";
  }
  
  boolean isDeadlineNear(int days) {
    return false; // 仮実装。日付比較ロジックは後日調整
  }

  String getNearestDeadline() {
    return esDeadline; // 仮実装。後で複数締切から最も近いものを選ぶ処理に変更
  }

  String toString() {
    return companyName + " / " + selectionStatus;
  }
}
