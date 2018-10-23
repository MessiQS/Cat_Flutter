import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/db/db.dart';
import 'package:cat/pages/feedback.dart';
import 'package:cat/common/services/answer.dart';
import 'package:cat/models/image.dart';

enum OptionsState {
  /// 未选择状态
  unselected,

  /// 选择后的状态（多选题）
  selected,

  /// 答案正确的状态
  right,

  /// 答案错误的状态
  wrong,
}

///
/// 答题页面
///
class Answer extends StatefulWidget {
  final User user;
  final AnswerType type;
  const Answer({Key key, this.user, this.type});

  @override
  createState() => new _AnswerState();
}

class _AnswerState extends State<Answer> {
  /// 切换到下一题
  nextQuestion() {
    print("nextQuestion");
  }

  shareButtonOnPressed() {
    print("shareButtonOnPressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
            title: Text(widget.user.currentExamTitle),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => shareButtonOnPressed(),
                tooltip: 'Share',
              ),
            ]),
        floatingActionButton: FloatingActionButton(
          child: Image.asset("images/arrow_right.png"),
          foregroundColor: CatColors.cellSplashColor,
          backgroundColor: CatColors.globalTintColor,
          onPressed: () => nextQuestion(),
        ),
        body: FutureBuilder<Question>(
            future: AnswerService.fetchData(widget.user.currentExamID,
                type: widget.type),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                /// 非材料题
                if (snapshot.data.material.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      QuestionArea(question: snapshot.data),
                      BottomArea(question: snapshot.data)
                    ],
                  );
                }

                /// 材料题

              }
              return Stack();
            }));
  }
}

///
/// 将文本分割成数据模块
///
Future<List<ContentParagraphs>> splitWidgets(String content) async {
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
            future: splitWidgets(widget.question.content),
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
/// 下方区域，解题区域的容器
/// 为了解耦，让有材料分析的时候可以变成全局的ListView
///
class BottomArea extends StatelessWidget {
  final Question question;

  const BottomArea({this.question});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        fit: FlexFit.tight,
        child: ListView(children: <Widget>[
          QuestionSolveArea(
            question: this.question,
          )
        ]));
  }
}

///
/// 解题区
///
class QuestionSolveArea extends StatefulWidget {
  final Question question;

  const QuestionSolveArea({this.question});

  @override
  _QuestionSolveAreaState createState() => _QuestionSolveAreaState();
}

class _QuestionSolveAreaState extends State<QuestionSolveArea> {
  List<String> selectedOptions = List<String>();

  List<OptionsState> optionsStates = [
    OptionsState.unselected,
    OptionsState.unselected,
    OptionsState.unselected,
    OptionsState.unselected,
  ];

  ///
  /// 选择试题
  /// 区分 [多选] [单选] [模糊]
  ///
  selectOptionOnPressed(String option) {
    print("selectOptionOnPressed " + option);

    /// 多选
    if (AnswerService.isHaveMutilpleAnswer(widget.question)) {
      /// 如果没有添加过
      if (selectedOptions.indexOf(option) == -1) {
        selectedOptions.add(option);
      } else {
        selectedOptions.remove(option);
      }
      return;
    }

    /// 单选
    this.confirmSelection();
  }

  ///
  /// 点击确认按钮
  ///
  doneButtonOnPressed() {
    this.confirmSelection();
  }

  ///
  /// 确认选择
  ///
  confirmSelection() {
    setState(() {
      optionsStates[0] = OptionsState.wrong;
    });
  }

  ///
  /// 有的是两个选项
  /// 有的是四个选项
  ///
  List<AnswerOptionItem> optionsList() {
    List<AnswerOptionItem> list = List<AnswerOptionItem>();
    if (widget.question.optionA.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "A",
        content: widget.question.optionA,
        onPressed: () => selectOptionOnPressed("A"),
        state: optionsStates[0],
      ));
    }
    if (widget.question.optionB.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "B",
        content: widget.question.optionB,
        onPressed: () => selectOptionOnPressed("B"),
        state: optionsStates[1],
      ));
    }
    if (widget.question.optionC.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "C",
        content: widget.question.optionC,
        onPressed: () => selectOptionOnPressed("C"),
        state: optionsStates[2],
      ));
    }
    if (widget.question.optionD.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "D",
        content: widget.question.optionD,
        onPressed: () => selectOptionOnPressed("D"),
        state: optionsStates[3],
      ));
    }
    return list;
  }

  /// 获取选项
  @override
  Widget build(BuildContext context) {
    return Column(
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
  final OptionsState state;

  const AnswerOptionItem(
      {@required this.option, this.content, this.onPressed, this.state});

  @override
  _AnswerOptionItemState createState() => _AnswerOptionItemState();
}

class _AnswerOptionItemState extends State<AnswerOptionItem> {
  ///
  /// 选项图标
  /// [A][B][C][D]
  ///
  Widget icon(BuildContext context) {
    String imageURL = "images/option_default_background.png";

    if (widget.state == OptionsState.right) {
      imageURL = "images/option_right_background.png";
    }
    if (widget.state == OptionsState.wrong) {
      imageURL = "images/option_wrong_background.png";
    }

    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 24.0),
          width: 24.0,
          height: 24.0,
          child: Image.asset(
            imageURL,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          width: 24.0,
          height: 24.0,
          margin: const EdgeInsets.only(left: 24.0),
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
        margin: EdgeInsets.fromLTRB(16.0, 10.0, 24.0, 10.0),
        child: FutureBuilder(
          future: splitWidgets(widget.content),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: snapshot.data);
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.transparent;

    if (widget.state == OptionsState.right) {
      color = Color(0xFFDAF6E7);
    }
    if (widget.state == OptionsState.wrong) {
      color = Color(0xFFF9E1E7);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      color: color,
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
          future: splitWidgets(widget.question.analysis),
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
