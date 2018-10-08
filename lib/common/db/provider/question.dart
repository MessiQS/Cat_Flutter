import 'dart:async';
import 'package:cat/common/db/base_provider.dart';
import 'package:sqflite/sqflite.dart';

///
/// QuestionConstants
///
class QC {
  /// 表名字
  static const String tableName = "question";

  /// id
  static const String columnID = "_id";

  /// 试题创建时间
  /// 时间戳
  static const String columnCreatedTime = "createdTime";

  /// 试题更新时间
  /// 时间戳
  static const String columnUpdateTime = "updatedTime";

  /// 当前题数
  static const String columnNumber = "number";

  /// 选项 A
  static const String columnA = "A";

  /// 选项 B
  static const String columnB = "B";

  /// 选项 C
  static const String columnC = "C";

  /// 选项 D
  static const String columnD = "D";

  /// 答案
  /// 单选 "A"、"B"、"C"、"D"、
  /// 多选 “A,B,C";
  static const String columnAnswer = "answer";

  /// 试题内容
  static const String columnContent = "content";

  /// ”多选“、“不定项”、“单选”
  static const String columnType = "type";

  /// 标题
  static const String columnTitle = "title";

  /// 考点
  static const String columnPoint = "point";

  /// 材料
  static const String columnMaterial = "material";

  /// 是否忽略 正常 错误 选项提示
  static const String columnHideTag = "hideTag";

  /// 题目类型
  /// "资料分析"  "常识判断" "言语理解与表达"  "数量关系" "判断推理" etc.
  static const String columnCategory = "category";

  /// 来源 "省份" "经济法" etc.
  static const String columnSource = "source";

  /// 试题的年份
  static const String columnYear = "year";

  /// 试卷ID
  static const String columnExamID = "examID";
}

class Question {
  int id;

  /// 时间戳
  String createdTime;
  String updatedTime;

  int number;
  String optionA;
  String optionB;
  String optionC;
  String optionD;
  String answer;
  String content;
  String type;
  String title;
  String point;
  String material;
  bool hideTag;
  String category;
  String source;
  String year;
  String examID;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      QC.columnTitle: title,
      QC.columnCreatedTime: createdTime,
      QC.columnUpdateTime: updatedTime,
      QC.columnNumber: number,
      QC.columnA: optionA,
      QC.columnB: optionB,
      QC.columnC: optionC,
      QC.columnD: optionD,
      QC.columnAnswer: answer,
      QC.columnContent: content,
      QC.columnType: type,
      QC.columnPoint: point,
      QC.columnMaterial: material,
      QC.columnHideTag: hideTag,
      QC.columnCategory: category,
      QC.columnSource: source,
      QC.columnYear: year,
      QC.columnExamID: examID,
    };
    if (id != null) {
      map[QC.columnID] = id;
    }
    return map;
  }

  Question();

  Question.fromMap(Map<String, dynamic> map) {
    id = map[QC.columnID];
    title = map[QC.columnTitle];
    createdTime = map[QC.columnCreatedTime];
    updatedTime = map[QC.columnUpdateTime];
    number = map[QC.columnNumber];
    optionA = map[QC.columnA];
    optionB = map[QC.columnB];
    optionC = map[QC.columnC];
    optionD = map[QC.columnD];
    answer = map[QC.columnAnswer];
    content = map[QC.columnContent];
    type = map[QC.columnType];
    point = map[QC.columnPoint];
    material = map[QC.columnMaterial];
    hideTag = map[QC.columnHideTag];
    category = map[QC.columnCategory];
    source = map[QC.columnSource];
    year = map[QC.columnYear];
    examID = map[QC.columnExamID];
  }
}

class QuestionProvider extends BaseDBProvider {
  @override
  tableSqlString() {
    return tableBaseString(QC.tableName, QC.columnID) +
        '''
        ${QC.columnTitle} text,
        ${QC.columnCreatedTime} text,
        ${QC.columnUpdateTime} text,
        ${QC.columnNumber} int,
        ${QC.columnA} text,
        ${QC.columnB} text,
        ${QC.columnC} text,
        ${QC.columnD} text,
        ${QC.columnAnswer} text,
        ${QC.columnContent} text,
        ${QC.columnType} text,
        ${QC.columnPoint} text,
        ${QC.columnMaterial} text,
        ${QC.columnHideTag} bool,
        ${QC.columnCategory} text,
        ${QC.columnSource} text, 
        ${QC.columnYear} text, 
        ${QC.columnExamID} text)
      ''';
  }

  @override
  tableName() {
    return QC.tableName;
  }

  Future<Question> insert(Question question) async {
    Database db = await getDataBase();
    question.id = await db.insert(tableName(), question.toMap());
    return question;
  }

  ///
  /// 批量插入数据
  /// [list] 试题数组
  Future<List<Question>> insertList(List<Question> list) async {
    Database db = await getDataBase();
    for (Question question in list) {
      question.id = await db.insert(tableName(), question.toMap());
    }
    return list;
  }

  Future<int> delete(int id) async {
    Database db = await getDataBase();

    return await db
        .delete(tableName(), where: "${QC.columnID} = ?", whereArgs: [id]);
  }

  Future<int> update(Question question) async {
    Database db = await getDataBase();

    return await db.update(tableName(), question.toMap(),
        where: "${QC.columnID} = ?", whereArgs: [question.id]);
  }

  Future<List<Question>> getQuestions(String examID) async {
    Database db = await getDataBase();

    List<Map> maps = await db.query(tableName(),
        columns: [
          QC.columnID,
          QC.columnTitle,
          QC.columnCreatedTime,
          QC.columnUpdateTime,
          QC.columnNumber,
          QC.columnA,
          QC.columnB,
          QC.columnC,
          QC.columnD,
          QC.columnAnswer,
          QC.columnContent,
          QC.columnType,
          QC.columnTitle,
          QC.columnPoint,
          QC.columnMaterial,
          QC.columnHideTag,
          QC.columnCategory,
          QC.columnSource,
          QC.columnYear,
          QC.columnExamID,
        ],
        where: "${QC.columnExamID} = ?",
        whereArgs: [examID]);

    List<Question> list = List<Question>();
    for (Map<String, dynamic> map in maps) {
      Question question = Question.fromMap(map);
      list.add(question);
    }

    return list;
  }
}
