import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DatabaseHelper {
  static final DatabaseHelper instance =
  DatabaseHelper._init();
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
  Future<void> _createDB(
      Database db,
      int version,
      ) async {
    await db.execute('''
CREATE TABLE inventory(
id INTEGER PRIMARY KEY AUTOINCREMENT,
itemName TEXT NOT NULL,
quantity INTEGER NOT NULL
)
''');
  }
  Future<int> insertItem(
      String itemName,
      int quantity,
      ) async {
    final db = await database;
    return await db.insert(
      'inventory',
      {
        'itemName': itemName,
        'quantity': quantity,
      },
    );
  }
  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query(
      'inventory',
      orderBy: 'itemName',
    );
  }
  Future<int> updateItem(
      int id,
      int quantity,
      ) async {
    final db = await database;
    return await db.update(
      'inventory',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> deleteItem(
      int id,
      ) async {
    final db = await database;
    return await db.delete(
      'inventory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}