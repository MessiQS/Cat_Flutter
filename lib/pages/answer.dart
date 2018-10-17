import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/db/db.dart';

/// 试题类型
enum AnswerType {
  /// 学习过的题
  studied,

  /// 没有学习过的题
  neverStudied
}

/// 段落类型
enum ParagraphsType {
  /// 图片
  image,

  /// 文字
  text,

  /// HTML格式富文本
  html,
}

class Answer extends StatefulWidget {
  final User user;
  final AnswerType type;
  const Answer({Key key, this.user, this.type});

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
            title: Text(widget.user.currentExamTitle),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
                tooltip: '更多',
              ),
            ]),
        body: FutureBuilder<Question>(
            future: fetchData(widget.user.currentExamID, type: widget.type),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    QuestionArea(question: snapshot.data),
                    OptionsArea(
                      question: snapshot.data,
                    )
                  ],
                );
              }
              return Stack();
            }));
  }
}

Future<Question> fetchData(examID, {AnswerType type}) async {
  QuestionProvider questionProvider = new QuestionProvider();
  RecordProvider recordProvider = new RecordProvider();

  /// 获取对应试卷的所有试题
  List<Question> list = await questionProvider.getQuestions(examID);
  List<Record> recordList = await recordProvider.getRecords(examID);
  List<String> recordExamIds = List<String>();
  if (recordList.isEmpty == false) {
    recordExamIds = recordList.map((value) => value.examId);
  }

  /// 获取所有做过
  List<String> unique = List<String>();
  recordExamIds.forEach((str) {
    if (unique.contains(str) == false) {
      unique.add(str);
    }
  });
  if (list.isEmpty == false) {
    Random random = new Random();
    int number = random.nextInt(list.length - 1);
    return list[number];
  }
  return null;
}

///
/// 试题区域
///
class QuestionArea extends StatefulWidget {
  final Question question;

  const QuestionArea({this.question});

  @override
  _QuestionAreaState createState() => _QuestionAreaState();
}

class _QuestionAreaState extends State<QuestionArea> {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<List<ContentParagraphs>> splitQuestion(Question question) async {
    print(question.toString());
    question.content.replaceAll("<br>", "\n\n");
    question.content.replaceAll("<br/>", "\n\n");
    question.content.replaceAll("</br>", "\n\n");

    List<String> list = question.content.split("<img");
    List<ContentParagraphs> paragraphsList = List<ContentParagraphs>();
    for (String str in list) {
      ContentParagraphs paragraphs;

      /// 不包含图片
      if (str.indexOf("/>") == -1) {
        paragraphs =
            new ContentParagraphs(type: ParagraphsType.text, paragraphs: str);
      } else {
        paragraphs =
            new ContentParagraphs(type: ParagraphsType.image, paragraphs: str);
      }
      paragraphsList.add(paragraphs);
    }

    return paragraphsList;
  }

  @override
  Widget build(BuildContext context) {
    double height =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) /
            2;
    return Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        child: FutureBuilder(
            future: splitQuestion(widget.question),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: 202.0,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, int index) {
                        /// 内部存储的段落
                        return snapshot.data[index];
                      }),
                );
              }
              return Container();
            }));
  }
}

///
/// 内容段落
///
class ContentParagraphs extends StatelessWidget {
  /// 段落类型
  final ParagraphsType type;

  /// 段落内容
  final String paragraphs;

  const ContentParagraphs({this.type, this.paragraphs});

  @override
  Widget build(BuildContext context) {
    /// 文本
    if (this.type == ParagraphsType.text) {
      return Container(
          margin: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, .0),
          child: Text(this.paragraphs,
              style: TextStyle(
                  fontSize: 14.0, color: CatColors.textDefaultColor)));
    }

    /// 图片
    if (this.type == ParagraphsType.image) {
      return Image.network(paragraphs);
    }

    /// HTML 富文本，待定
    if (this.type == ParagraphsType.html) {}
    return null;
  }
}

///
/// 选项区
///
class OptionsArea extends StatefulWidget {
  final Question question;

  const OptionsArea({this.question});

  @override
  _OptionsAreaState createState() => _OptionsAreaState();
}

class _OptionsAreaState extends State<OptionsArea> {
  selectOptionOnPressed() {
    print("selectOptionOnPressed");
  }

  List<AnswerOptionItem> optionsList() {
    List<AnswerOptionItem> list = List<AnswerOptionItem>();
    if (widget.question.optionA.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "A",
        content: widget.question.optionA,
        onPressed: () => selectOptionOnPressed,
      ));
    }
    if (widget.question.optionB.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "B",
        content: widget.question.optionB,
        onPressed: () => selectOptionOnPressed,
      ));
    }
    if (widget.question.optionC.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "C",
        content: widget.question.optionC,
        onPressed: () => selectOptionOnPressed(),
      ));
    }
    if (widget.question.optionD.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "D",
        content: widget.question.optionD,
        onPressed: () => selectOptionOnPressed(),
      ));
    }
    return list;
  }

  /// 获取选项
  @override
  Widget build(BuildContext context) {
    double height =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) /
            2;

    return Container(
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: <Widget>[
          AnswerSection("Options"),
          Column(
            children: optionsList(),
          ),
          AnswerSection("Answer Analysis"),
        ],
      ),
    );
  }
}

///
/// 页面之间的Section
///
class AnswerSection extends StatelessWidget {
  final String text;
  final bool hasButton;

  const AnswerSection(
    this.text, {
    this.hasButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Stack(
        children: <Widget>[
          Image.asset(
            'images/answer_section_background.png',
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, .0),
            child: Text(
              text,
              style: new TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: CatColors.textDefaultColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

///
/// 选项
///
class AnswerOptionItem extends StatefulWidget {
  final String option;
  final String content;
  final GestureTapCallback onPressed;

  const AnswerOptionItem({@required this.option, this.content, this.onPressed});

  @override
  _AnswerOptionItemState createState() => _AnswerOptionItemState();
}

class _AnswerOptionItemState extends State<AnswerOptionItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget optionBuild(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Text(
        widget.content,
      ),
    );
  }

  Widget icon(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 5.0),
          width: 24.0,
          height: 24.0,
          child: Image.asset(
            "images/answer_default_background.png",
            fit: BoxFit.fill,
          ),
        ),
        Container(
          width: 24.0,
          height: 24.0,
          margin: const EdgeInsets.only(left: 5.0),
          child: Text(
            widget.option,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: widget.onPressed,
        splashColor: Colors.blueGrey,
        child: Ink(
          child: Row(
            children: <Widget>[
              icon(context),
              optionBuild(context),
            ],
          ),
        ),
      ),
    );
  }
}
