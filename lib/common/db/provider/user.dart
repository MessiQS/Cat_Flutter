import 'dart:async';
import 'package:cat/common/db/base_provider.dart';
import 'package:sqflite/sqflite.dart';

///
/// UserConstants
///
class UC {
  /// 表名称
  static const String tableName = "user";

  /// id
  static const String columnID = "_id";

  /// 用户ID 服务端返回
  static const String columnUserId = "userID";

  /// token 标识
  static const String columnToken = "token";

  /// 当前试卷Id
  static const String columnCurrentExamID = "currentExamID";

  /// 当前试卷title
  static const String columnCurrentExamTitle = "currentExamTitle";
}

class User {
  int id;
  String userID;
  String token;
  String currentExamID;
  String currentExamTitle;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      UC.columnUserId: userID,
      UC.columnToken: token,
      UC.columnCurrentExamID: currentExamID,
      UC.columnCurrentExamTitle: currentExamTitle,
    };
    if (id != null) {
      map[UC.columnID] = id;
    }
    return map;
  }

  User(
      {this.userID = "",
      this.token = "",
      this.currentExamTitle = "",
      this.currentExamID = ""});

  User.fromMap(Map<String, dynamic> map) {
    id = map[UC.columnID];
    userID = map[UC.columnUserId];
    token = map[UC.columnToken];
    currentExamID = map[UC.columnCurrentExamID];
    currentExamTitle = map[UC.columnCurrentExamTitle];
  }

  @override
  String toString() {
    return '''
        user:
        id: ${this.id}
        userID: ${this.userID} 
        token: ${this.token} 
        currentExamID: ${this.currentExamID} 
        urrentExamTitle: ${this.currentExamTitle}
      ''';
  }
}

class UserProvider extends BaseDBProvider {
  @override
  tableSqlString() {
    return tableBaseString(UC.tableName, UC.columnID) +
        '''
        ${UC.columnUserId} text NULL,
        ${UC.columnToken} text NULL,
        ${UC.columnCurrentExamID} text NULL,
        ${UC.columnCurrentExamTitle} text NULL)
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
        .delete(tableName(), where: "${UC.columnID} = ?", whereArgs: [id]);
  }

  Future<int> update(User user) async {
    Database db = await getDataBase();

    return await db.update(tableName(), user.toMap(),
        where: "${UC.columnID} = ?", whereArgs: [user.id]);
  }

  Future<User> getUser() async {
    Database db = await getDataBase();

    List<Map> maps = await db.query(
      tableName(),
      columns: [
        UC.columnUserId,
        UC.columnToken,
        UC.columnCurrentExamID,
        UC.columnCurrentExamTitle,
      ],
    );

    if (maps.length > 0) {
      return new User.fromMap(maps.first);
    }
    return null;
  }
}
