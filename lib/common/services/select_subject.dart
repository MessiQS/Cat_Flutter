import 'dart:async';
import 'package:cat/common/net/net.dart';
import 'package:cat/models/subject.dart';
import 'package:cat/models/question.dart';

class ExamPaperResponse {
  final bool type;
  final List<ExamPaperModel> models;

  ExamPaperResponse({this.type, this.models});

  factory ExamPaperResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'];
    var newModels = new List<ExamPaperModel>();

    for (Map<String, dynamic> map in list) {
      ExamPaperModel model = ExamPaperModel.fromMap(map);
      newModels.add(model);
    }
    newModels
        .sort((a, b) => b.title.toUpperCase().compareTo(a.title.toUpperCase()));
    return ExamPaperResponse(
      type: json['type'],
      models: newModels,
    );
  }
}

class QuestionResponse {
  final bool type;
  final List<QuestionModel> models;

  QuestionResponse({this.type, this.models});

  factory QuestionResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'];
    var type = json['type'];

    var newModels = new List<QuestionModel>();
    for (Map<String, dynamic> map in list) {
      QuestionModel model = QuestionModel.fromMap(map);
      newModels.add(model);
    }
    return QuestionResponse(type: type, models: newModels);
  }
}

class SelectSubjectGet {
  final bool type;
  final List<SubjectModel> models;

  SelectSubjectGet({this.type, this.models});

  factory SelectSubjectGet.fromJson(Map<String, dynamic> json) {
    var type = json['type'];
    if (type == false) return null;
    var list = json['data'];
    var newModels = new List<SubjectModel>();

    for (Map<String, dynamic> map in list) {
      SubjectModel model = SubjectModel.fromMap(map);
      newModels.add(model);
    }
    return SelectSubjectGet(
      type: type,
      models: newModels,
    );
  }
}

class SelectSubjectService {
  ///
  /// 网络请求
  /// 批量获取试卷
  ///
  static Future<ExamPaperResponse> fetchData(title, subtitle) async {
    String url = Address.getTitleByProvince();
    Map<String, String> params = {"sendType": title, "province": subtitle};

    final response = await HttpManager.request(Method.Get, url, params: params);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ExamPaperResponse.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  ///
  /// 网络请求
  ///
  static Future<SelectSubjectGet> fetchMainData() async {
    String url = Address.getSecondType();
    final response = await HttpManager.request(Method.Get, url);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return SelectSubjectGet.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  static dwonloadExam(String examID) async {
    String url = Address.getpaper();
    Map<String, String> params = {"paperId": examID};
    final response = await HttpManager.request(Method.Get, url, params: params);
    if (response.statusCode == 200) {
      return QuestionResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  static downloadExamRecord(String examID) async {
    String url = Address.getQuestionInfoByPaperid();
    Map<String, String> params = {"paper_id": examID};

    final response = await HttpManager.request(Method.Get, url, params: params);
    if (response.statusCode == 200) {
      print(url + " response.body  + ${response.body}");
    } else {
      throw Exception('Failed to load post');
    }
  }
}
