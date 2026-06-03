import 'package:atv1/models/internship_model.dart';
import 'package:atv1/database/app_database.dart';

abstract class InternshipRepository {
  Future<int> insert_internship(internship internship);

  Future<List<internship>> get_internships();

  Future<int> update_internship(internship internship);

  Future<int> delete_internship(int id);
}

class internship_data_source implements InternshipRepository {
  final AppDatabase _database;
  static const String tableName = 'internships';

  internship_data_source({AppDatabase? database}) : _database = database ?? AppDatabase.instance;

  @override
  Future<int> insert_internship(internship internship) async {
    final db = await _database.database;
    return await db.insert(tableName, internship.toMap());
  }

  @override
  Future<List<internship>> get_internships() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> results = await db.query(tableName);
    return results.map((row) => internship.fromMap(row)).toList();
  }

  @override
  Future<int> update_internship(internship internship) async {
    final db = await _database.database;
    return await db.update(tableName, internship.toMap(), where: 'internship_id = ?', whereArgs: [internship.internship_id]);
  }

  @override
  Future<int> delete_internship(int id) async {
    final db = await _database.database;
    return await db.delete(tableName, where: 'internship_id = ?', whereArgs: [id]);
  }
}