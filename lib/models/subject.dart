///
/// 主标题
///
class SubjectModel {
  final String title;
  final List<SecondarySubjectModel> subModels;

  SubjectModel({this.title, this.subModels});

  factory SubjectModel.fromMap(Map jsonMap) {
    var title = jsonMap['type'] as String ?? "";
    var list = jsonMap['content'] as List;
    var subModels = list.map((i) => SecondarySubjectModel.fromMap(i)).toList();

    return new SubjectModel(title: title, subModels: subModels);
  }
}

///
/// 副标题
///
class SecondarySubjectModel {
  final String title;
  final List<String> list;

  SecondarySubjectModel({this.title, this.list});

  factory SecondarySubjectModel.fromMap(Map<String, dynamic> jsonMap) {
    var title = jsonMap['secondType'] as String;
    var subtitleFromJson = jsonMap['content'];
    List<String> list = new List<String>.from(subtitleFromJson);

    return SecondarySubjectModel(title: title, list: list);
  }
}

///
/// 试卷选项
///
class ExamPaperModel {
  final String title;
  final String paperId;

  ExamPaperModel({this.title, this.paperId});

  factory ExamPaperModel.fromMap(Map<String, dynamic> jsonMap) {
    var title = jsonMap['title'] as String;
    var paperId = jsonMap['paper_id'] as String;

    return ExamPaperModel(title: title, paperId: paperId);
  }
}
