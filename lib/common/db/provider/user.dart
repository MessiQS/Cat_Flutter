import 'dart:async';
import 'package:cat/common/db/base_provider.dart';
import 'package:sqflite/sqflite.dart';

///
/// UC
///
class UC {
  /// 表名称
  static const String tableName = "user";

  /// id
  static const String columnId = "_id";

  /// 用户ID 服务端返回
  static const String columnUserId = "userId";

  /// token
  static const String columnToken = "token";

  /// 当前试卷Id
  static const String columnCurrentExamId = "currentExamId";

  /// 当前试卷title
  static const String columnCurrentExamTitle = "currentExamTitle";
}

class User {
  int id;
  String userId;
  String token;
  String currentExamId;
  String currentExamTitle;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UC.columnUserId: userId,
      UC.columnToken: token,
      UC.columnCurrentExamId: currentExamId,
      UC.columnCurrentExamTitle: currentExamTitle,
    };
    if (id != null) {
      map[UC.columnId] = id;
    }
    return map;
  }

  User();

  User.fromMap(Map<String, dynamic> map) {
    id = map[UC.columnId];
    userId = map[UC.columnUserId];
    token = map[UC.columnToken];
    currentExamId = map[UC.columnCurrentExamId];
    currentExamTitle = map[UC.columnCurrentExamTitle];
  }
}

class UserProvider extends BaseDBProvider {
  @override
  tableSqlString() {
    return tableBaseString(UC.tableName, UC.columnId) +
        '''
        ${UC.columnUserId} text,
        ${UC.columnToken} text,
        ${UC.columnCurrentExamId} text,
        ${UC.columnCurrentExamTitle} text,
      ''';
  }

  @override
  tableName() {
    return UC.tableName;
  }

  Future<User> insert(User user) async {
    Database db = await getDataBase();
    user.id = await db.insert(tableName(), user.toMap());
    return user;
  }

  Future<int> delete(int id) async {
    Database db = await getDataBase();

    return await db
        .delete(tableName(), where: "${UC.columnId} = ?", whereArgs: [id]);
  }

  Future<int> update(User user) async {
    Database db = await getDataBase();

    return await db.update(tableName(), user.toMap(),
        where: "${UC.columnId} = ?", whereArgs: [user.id]);
  }

  Future<User> get(int id) async {
    Database db = await getDataBase();

    List<Map> maps = await db.query(tableName(),
        columns: [
          UC.columnUserId,
          UC.columnToken,
          UC.columnCurrentExamId,
          UC.columnCurrentExamTitle,
        ],
        where: "${UC.columnId} = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return new User.fromMap(maps.first);
    }
    return null;
  }
}
