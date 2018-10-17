import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/widgets/subject_list_item.dart';
import 'package:cat/common/net/net.dart';
import 'package:cat/models/subject.dart';
import 'package:cat/common//db/db.dart';
import 'package:cat/models/question.dart';

class SelectSubjectThird extends StatefulWidget {
  final String title;
  final String subtitle;
  const SelectSubjectThird({Key key, this.title, this.subtitle})
      : super(key: key);

  @override
  createState() => new _SelectSubjectThirdState();
}

class _SelectSubjectThirdState extends State<SelectSubjectThird> {
  @override
  void initState() {
    super.initState();
  }

  selectExamClick(String examID, String title) async {
    QuestionProvider provider = new QuestionProvider();

    /// 下载试题
    QuestionResponse questionResponse = await dwonloadExam(examID);
    List<Question> list = new List<Question>();
    for (QuestionModel model in questionResponse.models) {
      Question question = Question.fromMap(model.toMap());
      question.examID = examID;
      list.add(question);
    }
    provider.insertList(list);

    /// 下载选题记录
    await downloadExamRecord(examID);

    User user = new User();
    user.currentExamID = examID;
    user.currentExamTitle = title;

    UserProvider userProvider = new UserProvider();
    userProvider.insert(user);
  }

  dwonloadExam(String examID) async {
    String url = Address.getpaper();
    Map<String, String> params = {"paperId": examID};
    final response = await HttpManager.request(Method.Get, url, params: params);
    if (response.statusCode == 200) {
      return QuestionResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  downloadExamRecord(String examID) async {
    String url = Address.getQuestionInfoByPaperid();
    Map<String, String> params = {"paper_id": examID};

    final response = await HttpManager.request(Method.Get, url, params: params);
    if (response.statusCode == 200) {
      print(url + " response.body  + ${response.body}");
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.subtitle),
          backgroundColor: CatColors.globalTintColor,
        ),
        body: FutureBuilder<ExamPaperResponse>(
          future: fetchData(widget.title, widget.subtitle),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.type) {
              var models = snapshot.data.models;
              return ListView.builder(
                  itemCount: models.length,
                  itemBuilder: (context, int index) {
                    return ListItem(
                        title: models[index].title,
                        onPressed: () => selectExamClick(
                            models[index].paperId, models[index].title));
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        CatColors.globalTintColor)));
          },
        ));
  }
}

///
/// 网络请求
/// 批量获取试卷
///
Future<ExamPaperResponse> fetchData(title, subtitle) async {
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
