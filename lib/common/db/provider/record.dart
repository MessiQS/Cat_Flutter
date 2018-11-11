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
  static const String columnID = "_id";

  /// 创建时间
  static const String columnCreatedTime = "createdTime";

  /// 选择的选项
  static const String columnSelectedOption = "selectedOption";

  /// 试卷的id
  static const String columnExamID = "examID";

  /// 试题的id
  static const String columnQuestionId = "questionID";

  /// 是否正确
  static const String columnIsCorrect = "isCorrect";
}

class Record {
  int id;

  /// 时间戳
  int createdTime;
  int questionId;

  String selectedOption;
  String examId;

  bool isCorrect;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      RC.columnCreatedTime: createdTime,
      RC.columnSelectedOption: selectedOption,
      RC.columnExamID: examId,
      RC.columnQuestionId: questionId,
      RC.columnIsCorrect: isCorrect,
    };
    if (id != null) {
      map[RC.columnID] = id;
    }
    return map;
  }

  Record();

  Record.fromMap(Map<String, dynamic> map) {
    id = map[RC.columnID];
    createdTime = map[RC.columnCreatedTime] ?? 0;
    selectedOption = map[RC.columnSelectedOption] ?? "";
    examId = map[RC.columnExamID] ?? "";
    questionId = map[RC.columnQuestionId] ?? "";
    isCorrect = map[RC.columnIsCorrect] == 0 ? false : true;
  }

  @override
  String toString() {
    return '''
        =======================  ${this.runtimeType}  =======================

        ID : ${this.id}
        CreatedTime : ${this.createdTime}
        SelectedOption : ${this.selectedOption}
        ExamId : ${this.examId}
        QuestionId : ${this.questionId}
        IsCorrect : ${this.isCorrect}
      ''';
  }
}

class RecordProvider extends BaseDBProvider {
  @override
  tableSqlString() {
    return tableBaseString(RC.tableName, RC.columnID) +
        '''
        ${RC.columnCreatedTime} integer,
        ${RC.columnSelectedOption} text,
        ${RC.columnExamID} text,
        ${RC.columnQuestionId} integer,
        ${RC.columnIsCorrect} bool)
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
        .delete(tableName(), where: "${RC.columnID} = ?", whereArgs: [id]);
  }

  Future<int> update(Record question) async {
    Database db = await getDataBase();

    return await db.update(tableName(), question.toMap(),
        where: "${RC.columnID} = ?", whereArgs: [question.id]);
  }

  Future<List<Record>> getRecords(String examID) async {
    Database db = await getDataBase();
    List<Map> maps = await db.query(tableName(),
        columns: [
          RC.columnID,
          RC.columnCreatedTime,
          RC.columnSelectedOption,
          RC.columnExamID,
          RC.columnQuestionId,
          RC.columnIsCorrect,
        ],
        where: "${RC.columnExamID} = ?",
        whereArgs: [examID]);

    /// 取出所有记录
    List<Record> list = maps.map((Map map) => Record.fromMap(map)).toList();

    return list;
  }

  ///
  /// 获取每道题的最新记录
  ///
  Future<List<Record>> getUniqueRecords(String examID) async {
    Database db = await getDataBase();

    ///
    /// 获取指定试题下的全部记录
    /// 并且按照创建时间升序排列
    List<Map> maps = await db.query(tableName(),
        columns: [
          RC.columnID,
          RC.columnCreatedTime,
          RC.columnSelectedOption,
          RC.columnExamID,
          RC.columnQuestionId,
          RC.columnIsCorrect,
        ],
        where: "${RC.columnExamID} = ?",
        whereArgs: [examID],
        orderBy: "${RC.columnCreatedTime} asc");

    List<Record> list = maps.map((Map map) => Record.fromMap(map)).toList();

    ///
    /// 过滤, 因为按照创建时间排序
    /// 所以相同questionID过滤
    ///
    List<int> fliterList = List<int>();
    for (Record record in list) {
      /// 如果`fliterList`中有就从`list`删除
      if (fliterList.indexOf(record.questionId) == -1) {
        fliterList.add(record.questionId);
      } else {
        list.remove(record);
      }
    }
    return list;
  }

  Future<List<Record>> getRecordsByQuestionId(String questionId) async {
    Database db = await getDataBase();
    List<Map> maps = await db.query(tableName(),
        columns: [
          RC.columnID,
          RC.columnCreatedTime,
          RC.columnSelectedOption,
          RC.columnExamID,
          RC.columnQuestionId,
          RC.columnIsCorrect,
        ],
        where: "${RC.columnQuestionId} = ?",
        whereArgs: [questionId]);

    List<Record> list = List<Record>();
    for (Map<String, dynamic> map in maps) {
      Record record = Record.fromMap(map);
      list.add(record);
    }

    return list;
  }
}
