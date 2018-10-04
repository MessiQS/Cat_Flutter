import 'dart:async';
import 'dart:convert';
import 'package:cat/common/db/base_provider.dart';
import 'package:sqflite/sqflite.dart';

/// 表名字
final String tableQuestion = "question";

/// id
final String columnId = "_id";

/// 试题创建时间
final String columnCreatedTime = "createdTime";

/// 试题更新时间
final String columnUpdateTime = "updatedTime";

/// 当前题数
final String columnNumber = "number";

/// 选项 A
final String columnA = "A";

/// 选项 B
final String columnB = "B";

/// 选项 C
final String columnC = "C";

/// 选项 D
final String columnD = "D";

/// 答案
/// 单选 "A"、"B"、"C"、"D"、
/// 多选 “A,B,C";
final String columnAnswer = "answer";

/// 试题内容
final String columnContent = "content";

/// ”多选“、“不定项”、“单选”
final String columnType = "type";

/// 标题
final String columnTitle = "title";

/// 考点
final String columnPoint = "point";

/// 材料
final String columnMaterial = "material";

/// 是否忽略 正常 错误 选项提示
final String columnHideTag = "hideTag";

/// 题目类型: "资料分析"  "常识判断" "言语理解与表达"  "数量关系" "判断推理" etc.
final String columnCategory = "category";

class Question {
  int id;
  String createdTime;
  String updatedTime;
  String number;
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
  String hideTag;
  String category;
  Question();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnCreatedTime: createdTime,
      columnUpdateTime: updatedTime,
      columnNumber: number,
      columnA: optionA,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class QuestionProvider extends BaseDBProvider {
  @override
  tableSqlString() {}

  @override
  tableName() {
    return tableQuestion;
  }

  Future<Question> insert(Question question) async {
    Database db = await getDataBase();

    question.id = await db.insert(tableName(), question.toMap());
    return question;
  }

  Future<Question> getQuestion(int id) async {
    Database db = await getDataBase();

    List<Map> map = await db.query(tableName(),
        columns: [columnId, columnTitle],
        where: "$columnId = ?",
        whereArgs: [id]);
    return null;
  }
}
