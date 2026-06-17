import 'package:atv1/models/company_model.dart';
import 'package:atv1/repositories/company_repository.dart';

class SqlCompanyController implements CompanyRepository {
  final CompanyDataSource _repository;

  SqlCompanyController({CompanyDataSource? repository})
    : _repository = repository ?? CompanyDataSource();

  @override
  Future<int> insertCompany(Company company) async {
    return await _repository.insertCompany(company);
  }

  @override
  Future<List<Company>> getCompanies() async {
    return await _repository.getCompanies();
  }

  @override
  Future<int> updateCompany(Company company) async {
    return await _repository.updateCompany(company);
  }

  @override
  Future<int> deleteCompany(int id) async {
    return await _repository.deleteCompany(id);
  }
}
