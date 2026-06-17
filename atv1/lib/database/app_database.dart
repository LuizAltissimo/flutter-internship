import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;
  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb('internships.db');
    return _database!;
  }

  Future<Database> _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 4,
      // IA: versao do banco incrementada para suportar o cadastro de empresas
      onConfigure: _onConfigure,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDb(Database db, int version) async {
    await _createAdvisorProfessorsTable(db);
    await _createCompaniesTable(db);
    await _createInternshipsTable(db);
  }

  Future _createInternshipsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS internships (
        internship_id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_name TEXT NOT NULL,
        company_name TEXT NOT NULL,
        company_id INTEGER,
        location TEXT NOT NULL,
        duration TEXT NOT NULL,
        advisor_professor_id INTEGER,
        advisor_professor_name TEXT,
        FOREIGN KEY(company_id) REFERENCES companies(company_id),
        FOREIGN KEY(advisor_professor_id) REFERENCES advisor_professors(professor_id)
      )
    ''');
  }

  Future _createAdvisorProfessorsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS advisor_professors (
        professor_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        department TEXT NOT NULL,
        phone TEXT NOT NULL
      )
    ''');
  }

  Future _createCompaniesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS companies (
        company_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cnpj TEXT NOT NULL,
        location TEXT NOT NULL,
        contact_name TEXT NOT NULL,
        contact_email TEXT NOT NULL,
        contact_phone TEXT NOT NULL
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createAdvisorProfessorsTable(db);
    }

    if (oldVersion < 3) {
      // IA: migracao para adicionar colunas de orientador a tabelas existentes
      await db.execute('ALTER TABLE internships ADD COLUMN advisor_professor_id INTEGER');
      await db.execute('ALTER TABLE internships ADD COLUMN advisor_professor_name TEXT');
    }

    if (oldVersion < 4) {
      await _createCompaniesTable(db);
      await db.execute('ALTER TABLE internships ADD COLUMN company_id INTEGER');
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
