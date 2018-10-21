import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/widgets/subject_list_item.dart';
import 'package:cat/common/net/net.dart';
import 'package:cat/common//db/db.dart';
import 'package:cat/models/question.dart';

import 'package:cat/common/services/select_subject.dart';

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
        appBar: GradientAppBar(
          title: Text(widget.subtitle),
        ),
        body: FutureBuilder<ExamPaperResponse>(
          future: SelectSubjectService.fetchData(widget.title, widget.subtitle),
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