import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('Users.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users(
        userName TEXT NOT NULL PRIMARY KEY,
        moves INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertUser(String userName) async {
    final db = await database;

    return await db.insert(
      'Users',
      {
        'userName': userName,
        'moves': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;

    return await db.query(
      'Users',
      orderBy: 'moves ASC',
    );
  }

  Future<Map<String, dynamic>?> getUser(String userName) async {
    final db = await database;

    final result = await db.query(
      'Users',
      where: 'userName = ?',
      whereArgs: [userName],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<int> updateUser(String userName, int moves) async {
    final db = await database;

    return await db.update(
      'Users',
      {'moves': moves},
      where: 'userName = ?',
      whereArgs: [userName],
    );
  }

  Future<int> deleteUser(String userName) async {
    final db = await database;

    return await db.delete(
      'Users',
      where: 'userName = ?',
      whereArgs: [userName],
    );
  }
}