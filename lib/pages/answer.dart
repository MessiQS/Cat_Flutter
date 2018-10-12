import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/db/db.dart';

class Answer extends StatefulWidget {
  final String examID;

  const Answer({Key key, this.examID});

  @override
  createState() => new _AnswerState();
}

class _AnswerState extends State<Answer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: CatColors.globalTintColor,
            title: Text("Statistics"),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
                tooltip: '更多',
              ),
            ]),
        body: FutureBuilder<Question>(
            future: fetchData(widget.examID), builder: (context, snapshot) {
                          if (snapshot.hasData) {

                          }
            }));
  }
}

Future<Question> fetchData(examID) async {
  QuestionProvider questionProvider = new QuestionProvider();

  /// 获取对应试卷的所有试题
  List<Question> list = await questionProvider.getQuestions(examID);

  RecordProvider recordProvider = new RecordProvider();

  List<Record> recordList = await recordProvider.getRecords(examID);

  List<String> recordExamIds = recordList.map((value) => value.examId);

  /// 获取所有做过
  List<String> unique = List<String>();
  recordExamIds.forEach((str) {
    if (unique.contains(str) == false) {
      unique.add(str);
    }
  });

  if (unique.isEmpty == false) {
    print("records unique" + unique.toString());
  }

  if (list.isEmpty == false) {
    return list.first;
  }
  return null;
}
