import 'dart:async';
import 'package:cat/common/db/base_provider.dart';
import 'package:sqflite/sqflite.dart';

///
/// RecordConstants
///
class RC {
  /// 表名字
  static const String tableName = "record";

  /// id
  static const String columnId = "_id";

  /// 创建时间
  static const String columnCreatedTime = "createdTime";

  /// 选择的选项
  static const String columnSelectedOption = "selectedOption";

  /// 试卷的id
  static const String columnExamId = "examID";

  /// 试题的id
  static const String columnQuestionId = "questionID";
}

class Record {
  int id;

  /// 时间戳
  double createdTime;

  String selectedOption;
  String examId;
  String questionId;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      RC.columnCreatedTime: createdTime,
      RC.columnSelectedOption: selectedOption,
      RC.columnExamId: examId,
      RC.columnQuestionId: questionId,
    };
    if (id != null) {
      map[RC.columnId] = id;
    }
    return map;
  }

  Record();

  Record.fromMap(Map<String, dynamic> map) {
    id = map[RC.columnId];
    createdTime = map[RC.columnCreatedTime];
    selectedOption = map[RC.columnSelectedOption];
    examId = map[RC.columnExamId];
    questionId = map[RC.columnQuestionId];
  }
}

class RecordProvider extends BaseDBProvider {
  @override
  tableSqlString() {
    return tableBaseString(RC.tableName, RC.columnId) +
        '''
        ${RC.columnCreatedTime} double,
        ${RC.columnSelectedOption} text,
        ${RC.columnExamId} text,
        ${RC.columnQuestionId} text,
      ''';
  }

  @override
  tableName() {
    return RC.tableName;
  }

  Future<Record> insert(Record record) async {
    Database db = await getDataBase();
    record.id = await db.insert(tableName(), record.toMap());
    return record;
  }

  Future<int> delete(int id) async {
    Database db = await getDataBase();

    return await db
        .delete(tableName(), where: "${RC.columnId} = ?", whereArgs: [id]);
  }

  Future<int> update(Record question) async {
    Database db = await getDataBase();

    return await db.update(tableName(), question.toMap(),
        where: "${RC.columnId} = ?", whereArgs: [question.id]);
  }

  Future<Record> get(int id) async {
    Database db = await getDataBase();

    List<Map> maps = await db.query(tableName(),
        columns: [
          RC.columnId,
          RC.columnCreatedTime,
          RC.columnSelectedOption,
          RC.columnExamId,
          RC.columnQuestionId,
        ],
        where: "${RC.columnId} = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return new Record.fromMap(maps.first);
    }
    return null;
  }
}
