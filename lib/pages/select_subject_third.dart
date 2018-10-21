import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/widgets/subject_list_item.dart';
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
    QuestionResponse questionResponse =
        await SelectSubjectService.dwonloadExam(examID);
    List<Question> list = new List<Question>();
    for (QuestionModel model in questionResponse.models) {
      Question question = Question.fromMap(model.toMap());
      question.examID = examID;
      list.add(question);
    }
    provider.insertList(list);

    /// 下载选题记录
    await SelectSubjectService.downloadExamRecord(examID);

    User user = new User();
    user.currentExamID = examID;
    user.currentExamTitle = title;

    UserProvider userProvider = new UserProvider();
    userProvider.insert(user);
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
