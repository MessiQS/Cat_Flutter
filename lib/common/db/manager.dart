import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

class DBManager {
  /// 数据库版本，迭代用
  final _VERSION = 1;

  /// 数据库名称
  final _NAME = "samso.cat_app_flutter.db";

  /// 数据库
  Database _database;

  /// 单例
  static final DBManager _singleton = new DBManager._internal();

  factory DBManager() {
    return _singleton;
  }

  DBManager._internal();

  /// 初始化
  init() async {
    var databasesPath = await getDatabasesPath();
    String dbName = _NAME;
  }

  ///
  /// 表是否存在
  ///
  isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "SELECT * FROM Sqlite_master WHERE type = 'table' AND name = '$tableName'");
    return res != null && res.length > 0;
  }

  /// 获取当前数据库对象
  Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  /// 关闭数据库
  close() {
    _database?.close();
    _database = null;
  }
}
