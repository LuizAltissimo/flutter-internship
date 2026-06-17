import 'package:atv1/database/app_database.dart';
import 'package:atv1/models/company_model.dart';

abstract class CompanyRepository {
  Future<int> insertCompany(Company company);

  Future<List<Company>> getCompanies();

  Future<int> updateCompany(Company company);

  Future<int> deleteCompany(int id);
}

class CompanyDataSource implements CompanyRepository {
  final AppDatabase _database;
  static const String tableName = 'companies';

  CompanyDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  @override
  Future<int> insertCompany(Company company) async {
    final db = await _database.database;
    return await db.insert(tableName, company.toMap());
  }

  @override
  Future<List<Company>> getCompanies() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> results = await db.query(tableName);
    return results.map((row) => Company.fromMap(row)).toList();
  }

  @override
  Future<int> updateCompany(Company company) async {
    final db = await _database.database;
    return await db.update(
      tableName,
      company.toMap(),
      where: 'company_id = ?',
      whereArgs: [company.companyId],
    );
  }

  @override
  Future<int> deleteCompany(int id) async {
    final db = await _database.database;
    return await db.delete(
      tableName,
      where: 'company_id = ?',
      whereArgs: [id],
    );
  }
}
