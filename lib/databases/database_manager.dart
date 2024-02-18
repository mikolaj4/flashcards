import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/word.dart';

class DatabaseManager {
  //prywatny konstruktor - singleton pattern aby była tylko jedna instancja bazy danych
  DatabaseManager._internal();

  static final _instance = DatabaseManager._internal();

  factory DatabaseManager() => _instance;

  //kod bazy danych
  final String _database = 'flashcards2.db';
  final String _table = 'words';
  final String _column1 = 'topic';
  final String _column2 = 'polish ';
  final String _column3 = 'german';

  Future<Database> initDatabase() async {
    final devicesPath = await getDatabasesPath();
    final path = join(devicesPath, _database);

    return await openDatabase(path, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE $_table($_column1 TEXT, $_column2 TEXT PRIMARY KEY, $_column3 TEXT)');
    }, version: 1);
  }

  Future<void> insertWord({required Word word}) async {
    final db = await initDatabase();
    await db.insert(_table, word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Word>> selectWords({int? limit}) async {
    final db = await initDatabase();
    List<Map<String, dynamic>> maps =
        await db.query(_table, limit: limit, orderBy: 'RANDOM()');
    return List.generate(
        maps.length, (index) => Word.fromMap(map: maps[index]));
  }

  Future<void> removeWord({required Word word}) async {
    final db = await initDatabase();
    await db.delete(_table, where: 'polish = ?', whereArgs: [word.polish]);
  }

  Future<void> removeAllWords() async {
    final db = await initDatabase();
    await db.delete(_table);
  }

  Future<void> removeDatabase() async {
    final devicesPath = await getDatabasesPath();
    final path = join(devicesPath, _database);
    await deleteDatabase(path);
  }
}
