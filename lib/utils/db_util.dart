import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DbUtil {
  static Future<sql.Database> createDatabase() {
    return sql.getDatabasesPath().then((dbPath) {
      final String path = join(dbPath, 'orders.db');
      return sql.openDatabase(path, onCreate: (db, version) {
        db.execute(
          'CREATE TABLE orders ('
          'id TEXT PRIMARY KEY, '
          'title TEXT,'
          'firebaseID TEXT,'
          'problem TEXT,'
          'clientID TEXT,'
          'technicalID TEXT,'
          'creationDate TEXT,'
          'deadline TEXT)',
        );
      }, version: 1);
    });
  }

  static Future<sql.Database> newDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'orders.db'),
      onCreate: (db, version) async {
        return await db.execute(
          'CREATE TABLE orders ('
          'id TEXT PRIMARY KEY, '
          'title TEXT,'
          'firebaseID TEXT,'
          'problem TEXT,'
          'clientID TEXT,'
          'technicalID TEXT,'
          'creationDate TEXT,'
          'deadline TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.createDatabase();
    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> delete(String table, String id) async {
    final db = await DbUtil.createDatabase();
    return await db.delete(
      '$table WHERE id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.createDatabase();
    return db.query(table);
  }
}
