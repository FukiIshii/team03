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
    ArrayList<String> dates = new ArrayList<String>();
  if (!esDeadline.equals(""))       dates.add(esDeadline);
  if (!spiDeadline.equals(""))      dates.add(spiDeadline);
  if (!internshipDate.equals(""))   dates.add(internshipDate);
  if (!interview1Date.equals(""))   dates.add(interview1Date);
  if (!interview2Date.equals(""))   dates.add(interview2Date);
  if (!interview3Date.equals(""))   dates.add(interview3Date);
  if (!photoDeadline.equals(""))    dates.add(photoDeadline);

  if (dates.size() == 0) return "ー";

  String nearest = dates.get(0);
  for (String d : dates) {
    if (d.compareTo(nearest) < 0) { // "YYYY/MM/DD"形式なら文字列比較で日付順になる
      nearest = d;
    }
  }
  return nearest;
  }

  String toString() {
    return companyName + " / " + selectionStatus;
  }
}
