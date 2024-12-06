import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static const String _dbName = 'todo.db';
  static const String _tableName = 'todos';
  static const int _dbVersion = 1;

  static final DbHelper instance = DbHelper._privateConstructor();
  DbHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL
      )
    ''');
  }

  Future<int> addTask(String title) async {
    final db = await database;
    return await db.insert(_tableName, {'title': title});
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query(_tableName);
  }

  Future<int> updateTask(int id, String title) async {
    final db = await database;
    return await db.update(_tableName, {'title': title},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
