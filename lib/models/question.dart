import 'package:cat/common/db/provider/question.dart';

///
/// 试题的中间模型
///
class QuestionModel {
  final int number;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String answer;
  final String content;

  /// ”多选“、“不定项”、“单选”
  final String type;
  final String title;
  final String point;
  final String material;
  final bool hideTag;
  final String category;
  final String year;
  final String province;
  final String questionID;
  final String createdTime;
  final String updatedTime;
  final String source;
  final String analysis;

  const QuestionModel(
      {this.number,
      this.optionA,
      this.optionB,
      this.optionC,
      this.optionD,
      this.answer,
      this.content,
      this.type,
      this.title,
      this.point,
      this.material,
      this.hideTag,
      this.category,
      this.year,
      this.province,
      this.questionID,
      this.createdTime,
      this.updatedTime,
      this.source,
      this.analysis});

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
      QC.columnAnalysis: analysis,
    };

    return map;
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    var number = map["question_number"] as int;
    var optionA = map["option_A"] as String;
    var optionB = map["option_B"] as String;
    var optionC = map["option_C"] as String;
    var optionD = map["option_D"] as String;
    var answer = map["answer"] as String;
    var content = map["question"] as String;
    var type = map["subject"] as String;
    var title = map['title'] as String;
    var point = map["question_point"] as String;
    var material = map["question_material"] as String;
    var hideTag = map["ignoreWarning"] as bool;
    var category = map["category"] as String;
    var year = map["year"] as String;
    var province = map["province"] as String;
    var questionID = map['id'] as String;
    var createdTime = map["created_at"] as String;
    var updatedTime = map["updated_at"] as String;
    var source = map["province"] as String;
    var analysis = map["analysis"] as String;

    return QuestionModel(
        number: number,
        optionA: optionA,
        optionB: optionB,
        optionC: optionC,
        optionD: optionD,
        answer: answer,
        content: content,
        type: type,
        title: title,
        point: point,
        material: material,
        hideTag: hideTag,
        category: category,
        year: year,
        province: province,
        questionID: questionID,
        createdTime: createdTime,
        updatedTime: updatedTime,
        source: source,
        analysis: analysis);
  }

  @override
  String toString() {
    return '''
    
        =======================  Question Model  =======================

        Title : ${this.title}
        CreatedTime : ${this.createdTime}
        UpdateTime : ${this.updatedTime}
        Number : ${this.number}
        A : ${this.optionA}
        B : ${this.optionB}
        C : ${this.optionC}
        D : ${this.optionD}
        Answer : ${this.answer}
        Content : ${this.content}
        Type : ${this.type}
        Point : ${this.point}
        Material : ${this.material}
        HideTag : ${this.hideTag}
        Category : ${this.category}
        Source : ${this.source}
        Year : ${this.year}
        Analysis: ${this.analysis}
      ''';
  }
}
