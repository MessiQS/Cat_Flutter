import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

class DBManager {
  /// 数据库版本，迭代用
  static const _VERSION = 1;

  /// 数据库名称
  static const _NAME = "samso.cat_app_flutter.db";

  /// 数据库
  static Database _database;

  /// 初始化
  static init() async {
    var databasesPath = await getDatabasesPath();
  }
}
