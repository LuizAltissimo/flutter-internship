import 'package:atv1/models/internship_model.dart';
import 'package:atv1/database/app_database.dart';

abstract class InternshipRepository {
  Future<int> insertInternship(Internship internship);

  Future<List<Internship>> getInternships();

  Future<int> updateInternship(Internship internship);

  Future<int> deleteInternship(int id);
}

class InternshipDataSource implements InternshipRepository {
  final AppDatabase _database;
  static const String tableName = 'internships';

  InternshipDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  @override
  Future<int> insertInternship(Internship internship) async {
    final db = await _database.database;
    return await db.insert(tableName, internship.toMap());
  }

  @override
  Future<List<Internship>> getInternships() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> results = await db.query(tableName);
    return results.map((row) => Internship.fromMap(row)).toList();
  }

  @override
  Future<int> updateInternship(Internship internship) async {
    final db = await _database.database;
    return await db.update(
      tableName,
      internship.toMap(),
      where: 'internship_id = ?',
      whereArgs: [internship.internshipId],
    );
  }

  @override
  Future<int> deleteInternship(int id) async {
    final db = await _database.database;
    return await db.delete(
      tableName,
      where: 'internship_id = ?',
      whereArgs: [id],
    );
  }
}
