import 'package:sqflite/sqflite.dart';

/// 基类
abstract class BaseDbProvider {
  bool isTableExist = false;
  Database db;

  /// 表名称
  tableName();
}
