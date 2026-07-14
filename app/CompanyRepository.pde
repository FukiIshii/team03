class CompanyRepository {
  ArrayList<Company> companies;

  CompanyRepository() {
    companies = new ArrayList<Company>();
  }

  void add(Company c) {
    companies.add(c);
  }

  void update(Company c) {
  }
  
  void remove(Company c) {
    companies.remove(c);
  }

  ArrayList<Company> getAll() {
    return companies;
  }

  ArrayList<Company> searchByName(String keyword) {
    ArrayList<Company> result = new ArrayList<Company>();
    for (Company c : companies) {
      if (c.companyName.contains(keyword)) {
        result.add(c);
      }
    }
    return result;
  }

  ArrayList<Company> sortByNearestDeadline() {
  ArrayList<Company> sorted = new ArrayList<Company>(companies);
  int n = sorted.size();

  for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - 1 - i; j++) {
      String da = sorted.get(j).getNearestDeadline();
      String db = sorted.get(j + 1).getNearestDeadline();

      boolean shouldSwap;
      if (da.equals("ー") && db.equals("ー")) {
        shouldSwap = false;
      } else if (da.equals("ー")) {
        shouldSwap = true;  // 締切なしは後ろへ
      } else if (db.equals("ー")) {
        shouldSwap = false;
      } else {
        shouldSwap = da.compareTo(db) > 0; // 日付が遅い方が前にあれば入れ替え
      }

      if (shouldSwap) {
        Company temp = sorted.get(j);
        sorted.set(j, sorted.get(j + 1));
        sorted.set(j + 1, temp);
      }
    }
  }
  return sorted;
}
}
