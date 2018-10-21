import 'dart:math';
import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/db/db.dart';
import 'package:cat/common/config/config.dart';
import 'package:cat/pages/feedback.dart';
import 'package:cat/common/services/answer.dart';
import 'package:cat/models/image.dart';

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
            future: AnswerService.fetchData(widget.user.currentExamID,
                type: widget.type),
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

///
/// 将文本分割成数据模块
///
Future<List<ContentParagraphs>> splitContent(String content) async {
  /// 清洗脏数据
  List<String> list = AnswerService.splitContent(content);

  List<ContentParagraphs> paragraphsList = List<ContentParagraphs>();
  for (String str in list) {
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
                      padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, .0),
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
          child: Text(this.paragraphs,
              style: TextStyle(
                  fontSize: 14.0, color: CatColors.textDefaultColor)));
    }

    /// 图片
    if (this.type == ParagraphsType.image) {
      ImageModel imageModel =
          AnswerService.getImageModelFromParagraphs(paragraphs, context);
      return Container(
          width: imageModel.width,
          height: imageModel.height,
          child: Image.network(
            imageModel.src,
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
  List<String> selectedOptions = List<String>();

  ///
  /// 选择试题
  /// 区分 [多选] [单选] [模糊]
  ///
  selectOptionOnPressed(String option) {
    print("selectOptionOnPressed " + option);
    selectedOptions.add(option);

    /// 单选
    // if (widget.question.)s

    /// 多选

    /// 模糊 认识
  }

  List<AnswerOptionItem> optionsList() {
    List<AnswerOptionItem> list = List<AnswerOptionItem>();
    if (widget.question.optionA.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "A",
        content: widget.question.optionA,
        onPressed: () => selectOptionOnPressed("A"),
      ));
    }
    if (widget.question.optionB.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "B",
        content: widget.question.optionB,
        onPressed: () => selectOptionOnPressed("B"),
      ));
    }
    if (widget.question.optionC.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "C",
        content: widget.question.optionC,
        onPressed: () => selectOptionOnPressed("C"),
      ));
    }
    if (widget.question.optionD.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "D",
        content: widget.question.optionD,
        onPressed: () => selectOptionOnPressed("D"),
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
          /// 选项 Section
          AnswerSection("Options"),

          /// 选项
          Column(
            children: optionsList(),
          ),

          /// 答案分析 Section
          AnswerSection("Answer Analysis"),

          /// 答案分析
          AnswerAnalysis(question: widget.question),

          /// 错题反馈 Section
          AnswerSection("Content Incorrect?"),

          /// 错题反馈
          FeedbackItem(question: widget.question),

          /// 底部占位图
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
        child: FutureBuilder(
          future: splitContent(widget.question.analysis),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: snapshot.data);
            }
            return Container();
          },
        ));
  }
}

///
/// 反馈（Content Incorrect?）
///
class FeedbackItem extends StatelessWidget {
  final Question question;
  const FeedbackItem({this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () =>
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return FeedbackPage(
                question: this.question,
              );
            })),
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
