import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/widgets/subject_list_item.dart';
import 'package:cat/common/net/net.dart';
import 'package:cat/models/subject.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.subtitle),
          backgroundColor: CatColors.globalTintColor,
        ),
        body: FutureBuilder<ExamPaperGet>(
          future: fetchData(widget.title, widget.subtitle),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var models = snapshot.data.models;
              return ListView.builder(
                  itemCount: models.length,
                  itemBuilder: (context, int index) {
                    return ListItem(
                        title: models[index].title,
                        onPressed: () =>
                            selectExamClick(models[index].paperId));
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

  selectExamClick(String examId) async {
    print("selectExamClick:" + examId);
    await dwonloadExam(examId);
  }

  dwonloadExam(String examId) async {
    String url = Address.getQuestionInfoByPaperid();
    Map<String, String> params = {"paper_id": examId};

    final response = await HttpManager.request(Method.Get, url, params: params);
    if (response.statusCode == 200) {
      print(url + " response.body " + response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
}

///
/// 网络请求
///
Future<ExamPaperGet> fetchData(title, subtitle) async {
  String url = Address.getTitleByProvince();
  Map<String, String> params = {"sendType": title, "province": subtitle};

  final response = await HttpManager.request(Method.Get, url, params: params);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return ExamPaperGet.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class ExamPaperGet {
  final bool type;
  final List<ExamPaperModel> models;

  ExamPaperGet({this.type, this.models});

  factory ExamPaperGet.fromJson(Map<String, dynamic> json) {
    var list = json['data'];
    var newModels = new List<ExamPaperModel>();

    for (Map<String, dynamic> map in list) {
      ExamPaperModel model = ExamPaperModel.fromMap(map);
      newModels.add(model);
    }
    return ExamPaperGet(
      type: json['type'],
      models: newModels,
    );
  }
}
