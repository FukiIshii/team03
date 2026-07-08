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
    return companies; // 仮実装。後日Collections.sortで並べ替えを実装
  }
}
