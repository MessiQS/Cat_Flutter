import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/router/cat_route.dart';
import 'package:cat/common/db/db.dart';
import 'package:cat/pages/answer.dart';
import 'package:cat/common/services/statistics.dart';

enum ActionSheetType {
  notification,
  account,
  update,
  sendFeedback,
  logout,
}

enum ActionSheetStyle {
  defaultStyle,
  switchStyle,
}

typedef ActionSheetItemOnPressed = void Function(ActionSheetType type);
typedef ActionSheetItemValueChanged = void Function(
    ActionSheetType type, bool value);

class Statistics extends StatefulWidget {
  @override
  createState() => new _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
            title: Text("Statistics"),
            leading: Icon(Icons.menu),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return BottomActionSheet();
                      });
                },
                tooltip: '更多',
              ),
            ]),
        body: FutureBuilder<User>(
          future: StatisticsService.fetchUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.currentExamTitle.isNotEmpty) {
              return ChartTable(user: snapshot.data);
            }
            return BeginStudy();
          },
        ));
  }
}

///
/// You haven’t choose
///    anything yet
///  +--------------+
///  |  Begin Study |
///  +--------------+
///
class BeginStudy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "You haven’t choose\nanything yet",
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
        Container(
          margin: EdgeInsets.only(top: 23.0),
          width: 170.0,
          height: 36.0,
          child: CatBaseButton(
            "Begin Study",
            onPressed: () =>
                Navigator.of(context).pushNamed(SElECT_SUBJECT_ROUTE),
          ),
        ),
      ],
    ));
  }
}

///
/// 折线图 表单
///
class ChartTable extends StatefulWidget {
  const ChartTable({Key key, this.user}) : super(key: key);

  final User user;

  @override
  createState() => new _ChartTableState();
}

class _ChartTableState extends State<ChartTable> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        PlacehoderSizeBox(
          height: 8.0,
        ),
        Container(
          height: 45.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                margin: EdgeInsets.only(left: 24.0),
                child: Text(
                  widget.user.currentExamTitle,
                  style: TextStyle(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 16.0),
                width: 69.0,
                height: 25.0,
                child: CatBaseButton(
                  "SELECT",
                  onPressed: () =>
                      Navigator.of(context).pushNamed(SElECT_SUBJECT_ROUTE),
                ),
              ),
            ],
          ),
        ),
        PlacehoderSizeBox(
          height: 8.0,
        ),
        ChartItem(
          user: widget.user,
          desc: "今日练习",
          buttonText: "学习",
          type: WeekdayType.Before,
        ),
        ChartSection(
          user: widget.user,
          weekdayType: WeekdayType.Before,
        ),
        PlacehoderSizeBox(
          height: 8.0,
        ),
        ChartItem(
          user: widget.user,
          desc: "遗忘曲线",
          buttonText: "复习",
          type: WeekdayType.After,
        ),
        ChartSection(
          user: widget.user,
          weekdayType: WeekdayType.After,
        ),
      ],
    );
  }
}

///
/// 每一块区域
///
class ChartSection extends StatefulWidget {
  final List<Widget> list;
  final User user;
  final WeekdayType weekdayType;

  const ChartSection({
    Key key,
    this.user,
    this.list,
    this.weekdayType = WeekdayType.Before,
  }) : super(key: key);

  @override
  createState() => new _ChartSectionState();
}

class _ChartSectionState extends State<ChartSection> {
  /// 底部栏 "TUE" "WED" "THU" "FRI" "SAT" "SUN"
  Widget buildBottom(BuildContext context) {
    List<String> list = StatisticsService.getWeekday(widget.weekdayType);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: list.map((value) {
        /// 过去五天，最后一个亮
        if (widget.weekdayType == WeekdayType.Before && list.last == value) {
          return Text(
            value,
            style: TextStyle(
              color: CatColors.globalTintColor,
              fontSize: 12.0,
            ),
          );
        }

        /// 未来五天，第一个亮
        if (widget.weekdayType == WeekdayType.After && list.first == value) {
          return Text(
            value,
            style: TextStyle(
              color: CatColors.globalTintColor,
              fontSize: 12.0,
            ),
          );
        }

        return Text(
          value,
          style: TextStyle(
            color: Color(0xFFB9B9B9),
            fontSize: 12.0,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      height: 200.0,
      child: FutureBuilder(
        future: StatisticsService.fetchEChartElems(
            widget.user.currentExamID, widget.weekdayType),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
                alignment: const Alignment(1.0, 1.1),
                children: <Widget>[
                  AreaAndLineChart.withSampleData(snapshot.data),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      width: MediaQuery.of(context).size.width,
                      height: 25.0,
                      color: CatColors.defaultBackgroundColor,
                      child: buildBottom(context))
                ]);
          }
          return SizedBox();
        },
      ),
    );
  }
}

///
/// 单个选项
///
class ChartItem extends StatefulWidget {
  final User user;
  final String desc;
  final String buttonText;
  final WeekdayType type;

  const ChartItem({
    this.user,
    this.desc,
    this.buttonText,
    this.type,
  });

  @override
  createState() => new _ChartItemState();
}

class _ChartItemState extends State<ChartItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(24.0, 24.0, .0, .0),
                width: 200.0,
                child: FutureBuilder(
                  future: StatisticsService.getPraticeCount(
                      widget.user.currentExamID, widget.type),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color(0xFF272727),
                        fontSize: 18.0,
                      ),
                    );
                  },
                )),
            Container(
              width: 200.0,
              margin: EdgeInsets.only(left: 24.0),
              child: Text(
                widget.desc,
                style: TextStyle(color: Color(0xFF7B7B7B), fontSize: 12.0),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.fromLTRB(.0, 24.0, 16.0, .0),
          width: 69.0,
          height: 25.0,
          child: CatBaseButton(
            widget.buttonText,
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return Answer(
                    user: widget.user,
                  );
                })),
          ),
        ),
      ],
    ));
  }
}

/// 图表
class AreaAndLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  AreaAndLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory AreaAndLineChart.withSampleData(List<ChartElem> list) {
    return AreaAndLineChart(
      _createSampleData(list),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(seriesList,
        animate: animate,
        customSeriesRenderers: [
          charts.LineRendererConfig(
            // ID used to link series to this renderer.
            customRendererId: 'customArea',
            includeArea: true,
            stacked: true,
          ),
        ]);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<ChartElem, int>> _createSampleData(
      List<ChartElem> list) {
    return [
      charts.Series<ChartElem, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (ChartElem question, _) => question.domain,
        measureFn: (ChartElem question, _) => question.count,
        data: list,
      )
        // Configure our custom bar target renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customArea'),
    ];
  }
}

///
/// 底部弹出框
///
class BottomActionSheet extends StatefulWidget {
  @override
  createState() => new _BottomActionSheetState();
}

class _BottomActionSheetState extends State<BottomActionSheet> {
  // bool enabledNotification;
  // bool enabledAccount;

  onPressed(ActionSheetType type) {
    print("type $type");
    if (type == ActionSheetType.sendFeedback) {
      Navigator.of(context).pushNamed(FEEDBACK_ROUTE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 292,
      child: (Column(
        children: <Widget>[
          SizedBox(height: 8.0),
          ActionSheetItem(
            url: "images/action_notification.png",
            text: "Notification",
            onPressed: onPressed,
            type: ActionSheetType.notification,
            style: ActionSheetStyle.switchStyle,
          ),
          ActionSheetItem(
            url: "images/action_account.png",
            text: "Account",
            onPressed: onPressed,
            type: ActionSheetType.account,
          ),
          ActionSheetItem(
            url: "images/action_update.png",
            text: "Update",
            onPressed: onPressed,
            type: ActionSheetType.update,
          ),
          ActionSheetItem(
            url: "images/action_send_feedback.png",
            text: "Send Feedback",
            onPressed: onPressed,
            type: ActionSheetType.sendFeedback,
          ),
          ActionSheetItem(
            url: "images/action_logout.png",
            text: "Logout",
            onPressed: onPressed,
            type: ActionSheetType.logout,
          ),
        ],
      )),
    );
  }
}

///
/// 弹框选项
///
class ActionSheetItem extends StatefulWidget {
  final String url;
  final String text;
  final ActionSheetType type;
  final ActionSheetItemOnPressed onPressed;
  final ActionSheetStyle style;

  const ActionSheetItem({
    this.url,
    this.text,
    this.onPressed,
    this.type,
    this.style = ActionSheetStyle.defaultStyle,
  });
  @override
  createState() => new _ActionSheetItemState();
}

class _ActionSheetItemState extends State<ActionSheetItem> {
  bool sValue;

  @override
  void initState() {
    super.initState();
    sValue = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.style == ActionSheetStyle.switchStyle) {
      return buildSwitch(context);
    }
    return buildDefault(context);
  }

  Widget buildDefault(BuildContext context) {
    return InkWell(
      onTap: () {
        /// 将类型回传回去
        widget.onPressed(widget.type);
      },
      splashColor: CatColors.cellSplashColor,
      child: Ink(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 24.0,
                height: 24.0,
                margin: EdgeInsets.fromLTRB(24.0, 16.0, 32.0, 16.0),
                child: Image.asset(widget.url),
              ),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget buildSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 24.0,
              height: 24.0,
              margin: EdgeInsets.fromLTRB(24.0, 16.0, 32.0, 16.0),
              child: Image.asset(widget.url),
            ),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(right: 20.0),
          child: Switch(
            value: this.sValue,
            onChanged: (bool value) {
              setState(() {
                this.sValue = value;
              });
            },
            activeColor: CatColors.globalTintColor,
            activeTrackColor: const Color(0xFFFCA88D),
          ),
        )
      ],
    );
  }
}

///
/// 占位
///
class PlacehoderSizeBox extends StatelessWidget {
  final double width;
  final double height;
  const PlacehoderSizeBox({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          this.width == null ? MediaQuery.of(context).size.width : this.width,
      height: this.height == null
          ? MediaQuery.of(context).size.height
          : this.height,
      child: const DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
      ),
    );
  }
}
