import 'package:atv1/database/app_database.dart';
import 'package:atv1/models/advisor_professor_model.dart';

abstract class AdvisorProfessorRepository {
  Future<int> insertProfessor(AdvisorProfessor professor);

  Future<List<AdvisorProfessor>> getProfessors();

  Future<int> updateProfessor(AdvisorProfessor professor);

  Future<int> deleteProfessor(int id);
}

class AdvisorProfessorDataSource implements AdvisorProfessorRepository {
  final AppDatabase _database;
  static const String tableName = 'advisor_professors';

  AdvisorProfessorDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  @override
  Future<int> insertProfessor(AdvisorProfessor professor) async {
    final db = await _database.database;
    return await db.insert(tableName, professor.toMap());
  }

  @override
  Future<List<AdvisorProfessor>> getProfessors() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> results = await db.query(tableName);
    return results.map((row) => AdvisorProfessor.fromMap(row)).toList();
  }

  @override
  Future<int> updateProfessor(AdvisorProfessor professor) async {
    final db = await _database.database;
    return await db.update(
      tableName,
      professor.toMap(),
      where: 'professor_id = ?',
      whereArgs: [professor.professorId],
    );
  }

  @override
  Future<int> deleteProfessor(int id) async {
    final db = await _database.database;
    return await db.delete(
      tableName,
      where: 'professor_id = ?',
      whereArgs: [id],
    );
  }
}
