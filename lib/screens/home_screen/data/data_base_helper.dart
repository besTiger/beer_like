import 'package:flutter/foundation.dart';
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
        description TEXT,
        timestamp TEXT
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

  Future<int> deletePhoto(int id) async {
    Database db = await instance.database;

    try {
      int result = await db.delete('photos', where: 'id = ?', whereArgs: [id]);
      if (kDebugMode) {
        print('Deleted $result rows for photo with ID: $id');
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting photo with ID: $id - $e');
      }
      return -1; // Return -1 to indicate an error
    }
  }

  Future<int> updatePhoto(int id, Map<String, dynamic> updatedPhoto) async {
    Database db = await instance.database;

    try {
      int result = await db.update('photos', updatedPhoto, where: 'id = ?', whereArgs: [id]);
      if (kDebugMode) {
        print('Updated $result rows for photo with ID: $id');
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating photo with ID: $id - $e');
      }
      return -1; // Return -1 to indicate an error
    }
  }
}
