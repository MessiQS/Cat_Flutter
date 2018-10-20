import 'dart:math';
import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/db/db.dart';
import 'package:cat/common/config/config.dart';

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    QuestionArea(question: snapshot.data),
                    OptionsArea(question: snapshot.data)
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
    print("number: $number");
    // return list[number];
    return list[17];
  }
  return null;
}

///
/// 清洗脏数据
/// 将文本分割成数据模块
///
Future<List<ContentParagraphs>> splitContent(String content) async {
  // print(content.toString());
  content = content
      .replaceAll("<br>", "\n\n")
      .replaceAll("<br/>", "\n\n")
      .replaceAll("</br>", "\n\n");

  List<String> newList = List<String>();
  List<String> list = content.split("<img");
  for (String str in list) {
    /// 不包含图片
    if (str.indexOf("/>") == -1) {
      newList.add(str);
    } else {
      List<String> splitList = str.split("/>");
      splitList.forEach((s) => newList.add(s));
    }
  }

  List<ContentParagraphs> paragraphsList = List<ContentParagraphs>();
  for (String str in newList) {
    ContentParagraphs paragraphs;

    /// 不包含图片
    if (str.indexOf("src=") == -1) {
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
  @override
  Widget build(BuildContext context) {
    return Flexible(
        fit: FlexFit.tight,
        child: FutureBuilder(
            future: splitContent(widget.question.content),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Color(0xAADBDBDB)),
                    ),
                  ),
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
      ///
      /// 到这步获得的字符串样子
      /// [paragraphs]
      /// alt="" class=""
      /// src="./images/56db380cf50180a7/normal_557x558_30fe67d42d27835b8fdc6b883417feff.png"
      /// width="329" height="330"
      ///
      RegExp regExp = new RegExp(
        r'src\s*=\s*"(.+?)"',
        caseSensitive: false,
        multiLine: false,
      );

      String str = regExp.firstMatch(paragraphs).group(0);

      ///
      /// 提取完成后的src
      /// https://shuatiapp.cn/images/56db380cf50180a7/normal_583x673_a768f839ffb619572cc196a2478daff7.png
      ///
      String src = str.replaceAll('src="./', Config.host).replaceAll('"', "");

      print("paragraphs" + paragraphs);

      double maxWidth = MediaQuery.of(context).size.width - 48;
      // double maxHeight = 300.0;
      double width = 200.0;
      double height = 200.0;

      ///
      /// `公务员考试题`
      RegExp sizeRegExp = new RegExp(
        r'/(normal|formula)_(.*)x(.*)_',
        caseSensitive: false,
        multiLine: false,
      );

      /// 如果能匹配到相应的格式
      if (sizeRegExp.hasMatch(src)) {
        ///
        /// 截取的字符串
        /// normal_595x154_ formula_595x154_
        ///
        Match match = sizeRegExp.firstMatch(src);
        String finder = match.group(0);

        ///
        /// [type]
        /// `normal` or `formula`
        String type = finder.split("_").first.replaceAll("/", "");

        /// 595x154
        String size = finder.split("_")[1];
        String strWidth = size.split("x").first;
        String strHeight = size.split("x").last;

        /// 缩放到指定倍数
        width = double.parse('$strWidth');
        height = double.parse('$strHeight');

        /// 设置最大尺寸上限
        width = min(maxWidth, width);
        // height = min(maxHeight, height);
      }
      print('''    
        width: $width 
        height: $height
        maxWidht: $maxWidth
        ''');
      return Container(
          width: width,
          height: height,
          child: Image.network(
            src,
            fit: BoxFit.contain,
          ));
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
        onPressed: () => {},
      ));
    }
    if (widget.question.optionB.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "B",
        content: widget.question.optionB,
        onPressed: () => {},
      ));
    }
    if (widget.question.optionC.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "C",
        content: widget.question.optionC,
        onPressed: () => {},
      ));
    }
    if (widget.question.optionD.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "D",
        content: widget.question.optionD,
        onPressed: () => {},
      ));
    }
    return list;
  }

  /// 获取选项
  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: ListView(
        children: <Widget>[
          AnswerSection("Options"),
          Column(
            children: optionsList(),
          ),
          AnswerSection("Answer Analysis"),
          AnswerAnalysis(question: widget.question),
          AnswerSection("Content Incorrect?"),
          Feedback(),
          Container(
            color: Color(0xFFFAFAFA),
            height: 16.0,
          )
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
  ///
  /// 选项图标
  /// [A][B][C][D]
  ///
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

  ///
  /// 选项文字图片部分
  ///
  Widget optionBuild(BuildContext context) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Text(
          widget.content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: widget.onPressed,
        splashColor: CatColors.cellSplashColor,
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

///
/// 分析 （Answer Analysis)
///
class AnswerAnalysis extends StatefulWidget {
  final Question question;

  const AnswerAnalysis({this.question});
  @override
  _AnswerAnalysisState createState() => _AnswerAnalysisState();
}

class _AnswerAnalysisState extends State<AnswerAnalysis> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
      child: Text(widget.question.analysis),
    );
  }
}

///
/// 反馈（Content Incorrect?）
///
class Feedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () => {},
        splashColor: CatColors.cellSplashColor,
        child: Ink(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Color(0xAADBDBDB)),
              bottom: BorderSide(width: 1.0, color: Color(0xAADBDBDB)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Image.asset("images/feedback_icon.png"),
              ),
              Container(
                margin: EdgeInsets.only(left: 32.0),
                child: Text("Send Feedback"),
              ),

              /// 占位辅图
              Expanded(
                child: Container(),
              ),
              Container(
                margin: EdgeInsets.only(right: 16.0),
                child: Image.asset("images/feedback_send_icon.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
