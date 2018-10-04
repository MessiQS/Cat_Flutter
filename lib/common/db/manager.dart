import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

class DBManager {
  /// 数据库版本，迭代用
  static const _VERSION = 1;

  /// 数据库名称
  static const _NAME = "samso_cat_app_flutter.db";

  /// 数据库
  static Database _database;

  /// 初始化
  static init() async {
    var databasesPath = await getDatabasesPath();
    String dbName = _NAME;

    /// 配置数据库路径
    String path = databasesPath + dbName;
    if (Platform.isIOS) {
      path = databasesPath + "/" + dbName;
    }

    _database = await openDatabase(path, version: _VERSION,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      //await db.execute("CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");
    });
  }

  /// 表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "SELECT * FROM Sqlite_master WHERE type = 'table' AND name = '$tableName'");
    return res != null && res.length > 0;
  }

  /// 获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  /// 关闭数据库
  static close() {
    _database?.close();
    _database = null;
  }
}
