import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class UserDatabase {
  static Database? _db;

  static Future<void> init() async {
    if (_db != null) return;
    final String databasesPath = await getDatabasesPath();
    final String path = p.join(databasesPath, 'healthcare_app.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE users(
            id TEXT PRIMARY KEY,
            password TEXT NOT NULL
          );
        ''');
      },
    );
  }

  static Future<bool> login(String id, String password) async {
    final Database db = _ensureDb();
    final List<Map<String, Object?>> rows = await db.query(
      'users',
      columns: ['id'],
      where: 'id = ? AND password = ?',
      whereArgs: [id, password],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  static Future<bool> userExists(String id) async {
    final Database db = _ensureDb();
    final List<Map<String, Object?>> rows = await db.query(
      'users',
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  static Future<void> register(String id, String password) async {
    final Database db = _ensureDb();
    await db.insert(
      'users',
      {'id': id, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Database _ensureDb() {
    final Database? db = _db;
    if (db == null) {
      throw StateError('UserDatabase.init() must be called before use');
    }
    return db;
  }
}
