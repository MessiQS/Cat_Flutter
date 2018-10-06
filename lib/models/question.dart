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
      this.source});

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
        source: source);
  }
}
