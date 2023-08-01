import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE profil(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nama TEXT,
      alamat TEXT,
      createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> datab() async {
    return sql.openDatabase(
      'dbtest.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print("...creating a table...");
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String nama, String? alamat) async {
    final datab = await SQLHelper.datab();
    final data = {'nama': nama, 'alamat': alamat};
    final id = await datab.insert('profil', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final datab = await SQLHelper.datab();
    return datab.query('profil', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final datab = await SQLHelper.datab();
    return datab.query('profil', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String nama, String? alamat) async {
    final datab = await SQLHelper.datab();

    final data = {
      'nama': nama,
      'alamat': alamat,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await datab.update('profil', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final datab = await SQLHelper.datab();
    try {
      await datab.delete("profil", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
