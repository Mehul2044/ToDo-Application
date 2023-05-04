import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    final sqDB = await openDatabase(path.join(dbPath, "tasks.db"),
        onCreate: (db, version) {
      db.execute(
          "CREATE TABLE if not exists currentTasks(id TEXT PRIMARY KEY, heading TEXT, description TEXT, date TEXT, isFavourite INT);");
      db.execute(
          "CREATE TABLE if not exists completedTasks(id TEXT PRIMARY KEY, heading TEXT, description TEXT, date TEXT, isFavourite INT);");
    }, version: 1);
    return sqDB;
  }

  static Future<void> insert(String table, Map<String, Object?> data) async {
    Database sqDB = await database();
    await sqDB.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> delete(String table, String id) async {
    Database sqDB = await database();
    await sqDB.execute("delete from $table where id = ?", [id]);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final sqDB = await database();
    return sqDB.query(table);
  }

  static Future<void> updateFavouriteStatus(
      int parameter1, String parameter2) async {
    Database sqDB = await database();
    await sqDB.execute("update currentTasks set isFavourite = ? where id = ?",
        [parameter1, parameter2]);
  }
}
