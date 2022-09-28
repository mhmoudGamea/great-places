import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static Future<sql.Database> accessDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'places.db'), version: 2,
        onCreate: (db, version) async{
      return await db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, latitude REAL, longitude REAL, address TEXT)');
    });
  }

  static Future<void> putData(String table, Map<String, dynamic> data) async {
    final database = await DBHelper.accessDatabase();
    try {
      database.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }on sql.DatabaseException catch(error) {
      print('error = $error');
    }
    //await database.close();
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final database = await DBHelper.accessDatabase();
    return database.query(table);
  }

  static Future<int> deleteData(String table, String id) async {
    final database = await DBHelper.accessDatabase();
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
