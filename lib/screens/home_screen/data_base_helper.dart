import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'photo_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE photos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imagePath TEXT,
        title TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> insertPhoto(Map<String, dynamic> photo) async {
    Database db = await instance.database;
    return await db.insert('photos', photo);
  }

  Future<List<Map<String, dynamic>>> retrievePhotos() async {
    Database db = await instance.database;
    return await db.query('photos');
  }
}