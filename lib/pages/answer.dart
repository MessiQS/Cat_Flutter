import 'dart:async';
import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/db/db.dart';
import 'package:cat/models/image.dart';
import 'package:cat/widgets/congrats.dart';
import 'package:cat/common/services/services.dart';
import 'dart:core';

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
  Future<Question> _loadQuestions;
  Map<String, OptionsState> _optionsStates;

  /// 是否确定选择
  bool isSelectedDone = false;
  void initState() {
    super.initState();
    _loadQuestions =
        AnswerService.fetchData(widget.user.currentExamID, type: widget.type);
    _optionsStates = {
      "A": OptionsState.unselected,
      "B": OptionsState.unselected,
      "C": OptionsState.unselected,
      "D": OptionsState.unselected,
    };
  }

  /// 切换到下一题
  nextQuestion() {
    setState(() {
      _loadQuestions =
          AnswerService.fetchData(widget.user.currentExamID, type: widget.type);
      _optionsStates["A"] = OptionsState.unselected;
      _optionsStates["B"] = OptionsState.unselected;
      _optionsStates["C"] = OptionsState.unselected;
      _optionsStates["D"] = OptionsState.unselected;
      isSelectedDone = false;
    });
  }

  shareButtonOnPressed() {
    print("shareButtonOnPressed");
  }

  /// 确认选项
  doneSelect() {
    setState(() {
      isSelectedDone = true;
    });
  }

  showCongratsDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Congrats();
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: Text(widget.user.currentExamTitle),
          // actions: <Widget>[
          //   new IconButton(
          //     icon: const Icon(Icons.share),
          //     onPressed: () => shareButtonOnPressed(),
          //     tooltip: 'Share',
          //   ),
          // ]
        ),
        floatingActionButton: FloatingActionButton(
          child: Image.asset("images/arrow_right.png"),
          foregroundColor: CatColors.cellSplashColor,
          backgroundColor: CatColors.globalTintColor,
          onPressed: () => nextQuestion(),
        ),
        body: FutureBuilder<Question>(
            future: _loadQuestions,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                /// 非材料题
                if (snapshot.data.material.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      QuestionArea(question: snapshot.data),
                      BottomArea(
                        question: snapshot.data,
                        optionsStates: _optionsStates,
                        doneSelect: () => doneSelect(),
                        isSelectedDone: isSelectedDone,
                      )
                    ],
                  );
                }

                /// 材料题
                return ListView(
                  children: <Widget>[
                    AnswerSection("材料"),
                    ContentArea(
                      content: snapshot.data.material,
                    ),
                    AnswerSection("试题"),
                    ContentArea(
                      content: snapshot.data.content,
                    ),
                    QuestionSolveArea(
                      question: snapshot.data,
                      optionsStates: _optionsStates,
                      doneSelect: () => doneSelect(),
                      isSelectedDone: isSelectedDone,
                    )
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
Future<List<ContentParagraphs>> splitWidgets(String content) async {
  /// 清洗脏数据
  List<String> list = AnswerService.splitContent(content);

  List<ContentParagraphs> paragraphsList = List<ContentParagraphs>();
  for (String str in list) {
    ContentParagraphs paragraphs;
    RegExp regExp = new RegExp(
      r'src\s*=\s*"(.+?)"',
      caseSensitive: false,
      multiLine: false,
    );

    /// 不包含图片
    if (regExp.hasMatch(str) == false) {
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
    return Container();
  }
}

///
/// 下方区域，解题区域的容器
/// 为了解耦，让有材料分析的时候可以变成全局的ListView
///
class BottomArea extends StatelessWidget {
  final Question question;
  final Map<String, OptionsState> optionsStates;
  final bool isSelectedDone;
  final VoidCallback doneSelect;

  const BottomArea({
    this.question,
    this.optionsStates,
    this.isSelectedDone,
    this.doneSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
        fit: FlexFit.tight,
        child: ListView(children: <Widget>[
          QuestionSolveArea(
            question: this.question,
            optionsStates: this.optionsStates,
            doneSelect: this.doneSelect,
            isSelectedDone: this.isSelectedDone,
          )
        ]));
  }
}

///
/// 解题区
///
class QuestionSolveArea extends StatefulWidget {
  final Question question;
  final Map<String, OptionsState> optionsStates;
  final bool isSelectedDone;
  final VoidCallback doneSelect;

  const QuestionSolveArea({
    this.question,
    this.optionsStates,
    this.isSelectedDone,
    this.doneSelect,
  });

  @override
  _QuestionSolveAreaState createState() => _QuestionSolveAreaState();
}

class _QuestionSolveAreaState extends State<QuestionSolveArea> {
  List<String> selectedOptions = List<String>();

  ///
  /// 选择试题
  /// 区分 [多选] [单选] [模糊]
  ///
  selectOptionOnPressed(String option) {
    if (widget.isSelectedDone == true) {
      return;
    }

    /// 多选
    if (AnswerService.isHaveMutilpleAnswer(widget.question)) {
      /// 如果没有添加过
      if (selectedOptions.indexOf(option) == -1) {
        setState(() {
          widget.optionsStates[option] = OptionsState.selected;
        });
        selectedOptions.add(option);
      } else {
        setState(() {
          widget.optionsStates[option] = OptionsState.unselected;
        });
        selectedOptions.remove(option);
      }
      return;
    }

    /// 单选
    this.confirmSelection([option]);
  }

  ///
  /// 点击确认按钮
  ///
  doneButtonOnPressed() {
    this.confirmSelection(selectedOptions);
    selectedOptions.clear();
  }

  ///
  /// 确认选择
  ///
  confirmSelection(List<String> options) async {
    setState(() {
      for (String option in options) {
        if (widget.question.answer.indexOf(option) == -1) {
          widget.optionsStates[option] = OptionsState.wrong;
        }
      }
      List<String> list = widget.question.answer.split(",");
      for (String item in list) {
        widget.optionsStates[item] = OptionsState.right;
      }
      widget.doneSelect();
    });

    /// 保存到数据库
    await AnswerService.saveRecordToDB(widget.question, options);

    /// 同步到网络
    AnswerService.saveRecordToWeb(widget.question, options);
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
        state: widget.optionsStates["A"],
      ));
    }
    if (widget.question.optionB.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "B",
        content: widget.question.optionB,
        onPressed: () => selectOptionOnPressed("B"),
        state: widget.optionsStates["B"],
      ));
    }
    if (widget.question.optionC.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "C",
        content: widget.question.optionC,
        onPressed: () => selectOptionOnPressed("C"),
        state: widget.optionsStates["C"],
      ));
    }
    if (widget.question.optionD.isNotEmpty) {
      list.add(AnswerOptionItem(
        option: "D",
        content: widget.question.optionD,
        onPressed: () => selectOptionOnPressed("D"),
        state: widget.optionsStates["D"],
      ));
    }
    return list;
  }

  /// 获取选项
  @override
  Widget build(BuildContext context) {
    /// 是否有多选按钮
    bool hasButton = AnswerService.isHaveMutilpleAnswer(widget.question);
    if (widget.isSelectedDone == false) {
      return Column(
        children: <Widget>[
          /// 选项 Section
          AnswerSection(
            "选项",
            hasButton: hasButton,
            onPressed: this.doneButtonOnPressed,
          ),

          /// 选项
          Column(
            children: optionsList(),
          ),

          /// 底部占位图
          Container(
            color: Color(0xFFFAFAFA),
            height: 16.0,
          )
        ],
      );
    }
    return Column(
      children: <Widget>[
        /// 选项 Section
        AnswerSection(
          "选项",
          hasButton: hasButton,
        ),

        /// 选项
        Column(
          children: optionsList(),
        ),

        /// 答案分析 Section
        AnswerSection("答案分析"),

        /// 答案分析
        AnswerAnalysis(question: widget.question),

        /// 错题反馈 Section
        AnswerSection("错题反馈?"),

        /// 错题反馈
        FeedbackItem(question: widget.question),

        /// 底部占位图
        SizedBox(
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
  final VoidCallback onPressed;

  const AnswerSection(
    this.text, {
    this.hasButton = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
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
      ),
    ];

    /// 如果多选项
    if (hasButton == true) {
      list.add(Container(
          margin: EdgeInsets.fromLTRB(.0, 15.0, 16.0, .0),
          width: 58.0,
          height: 28.5,
          child: RaisedButton(
            padding: EdgeInsets.all(.0),
            color: Color(0xFF0082D5),
            onPressed: onPressed,
            child: Text(
              "确 定",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          )));
    }

    return new Container(
      child: Stack(
        children: <Widget>[
          Image.asset(
            'images/answer_section_background.png',
            fit: BoxFit.fill,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: list,
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
    String imageURL = AnswerService.getOptionIcon(widget.state);

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
    Color color = AnswerService.getOptionColor(widget.state);

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

enum DialogAction {
  cancel,
  discard,
  disagree,
  agree,
}

///
/// 反馈（Content Incorrect?）
///
class FeedbackItem extends StatefulWidget {
  final Question question;

  const FeedbackItem({this.question});

  @override
  createState() => new _FeedbackItemState();
}

class _FeedbackItemState extends State<FeedbackItem> {
  void showFeedbackDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      if (value != null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final TextStyle dialogTextStyle =
        theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);
    return Container(
      height: 48.0,
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () {
          showFeedbackDialog<DialogAction>(
              context: context,

              /// 请确认该题是否内容有误
              /// 确定 取消
              child: AlertDialog(
                  content: Text("确认反馈错题", style: dialogTextStyle),
                  actions: <Widget>[
                    FlatButton(
                        child: const Text('取消'),
                        onPressed: () {
                          Navigator.pop(context, DialogAction.cancel);
                        }),
                    FlatButton(
                        child: const Text('确认'),
                        onPressed: () {
                          FeedBackService.sendWrongFeedBack(
                              widget.question.title,
                              widget.question.id,
                              widget.question.number);
                          Navigator.pop(context, DialogAction.discard);
                        })
                  ]));
        },
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

///
/// 内容展示区
///
class ContentArea extends StatefulWidget {
  // 未处理的内容
  final String content;
  const ContentArea({this.content});
  @override
  _ContentAreaState createState() => _ContentAreaState();
}

class _ContentAreaState extends State<ContentArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
        child: FutureBuilder(
          future: splitWidgets(widget.content),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: snapshot.data);
            }
            return Container();
          },
        ));
  }
}
