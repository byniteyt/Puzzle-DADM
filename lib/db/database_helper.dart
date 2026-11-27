import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('inventory.db');
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
      CREATE TABLE inventory(
        userName TEXT NOT NULL PRIMARY KEY,
        moves INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertUser(String userName) async {
    final db = await database;

    return await db.insert(
      'inventory',
      {
        'userName': userName,
        'moves': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;

    return await db.query(
      'inventory',
      orderBy: 'moves ASC',
    );
  }

  Future<int> updateItem(String userName, int moves) async {
    final db = await database;

    return await db.update(
      'inventory',
      {'moves': moves},
      where: 'userName = ?',
      whereArgs: [userName],
    );
  }

  Future<int> deleteItem(String userName) async {
    final db = await database;

    return await db.delete(
      'inventory',
      where: 'userName = ?',
      whereArgs: [userName],
    );
  }
}