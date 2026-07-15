class CompanyRepository {
  ArrayList<Company> companies;
  String dataFile = "companies.json";

  CompanyRepository() {
    companies = new ArrayList<Company>();
  }

  void add(Company c) {
    companies.add(c);
    saveToFile();
  }

  void update(Company c) {
    saveToFile();
  }

  void remove(Company c) {
    companies.remove(c);
    saveToFile();
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
          shouldSwap = true;
        } else if (db.equals("ー")) {
          shouldSwap = false;
        } else {
          shouldSwap = da.compareTo(db) > 0;
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

  void saveToFile() {
    JSONArray arr = new JSONArray();
    for (int i = 0; i < companies.size(); i++) {
      arr.setJSONObject(i, companies.get(i).toJSON());
    }
    saveJSONArray(arr, dataFile);
  }

  void loadFromFile() {
    File f = new File(sketchPath(dataFile));
    if (!f.exists()) return;
    JSONArray arr = loadJSONArray(dataFile);
    companies.clear();
    for (int i = 0; i < arr.size(); i++) {
      Company c = new Company("");
      c.loadFromJSON(arr.getJSONObject(i));
      companies.add(c);
    }
  }
}
