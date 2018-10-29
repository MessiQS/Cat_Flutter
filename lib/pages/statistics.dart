import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/router/cat_route.dart';
import 'package:cat/common/db/db.dart';
import 'package:cat/pages/answer.dart';

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
            leading: IconButton(
              tooltip: '菜单栏',
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
                tooltip: '更多',
              ),
            ]),
        body: FutureBuilder<User>(
          future: fetchUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.currentExamTitle != "") {
              return ChartTable(user: snapshot.data);
            }
            return BeginStudy();
          },
        ));
  }
}

Future<User> fetchUser() async {
  UserProvider userProvider = new UserProvider();
  User user = await userProvider.getUser();

  if (user == null) {
    print("user is null");
  }
  return user;
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
        ChartTable(),
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          height: 45.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 24.0),
                child: Text(widget.user.currentExamTitle),
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
        ChartListItem(
          user: widget.user,
        ),
        Container(
          width: 200.0,
          height: 200.0,
          child: AreaAndLineChart.withSampleData(),
        )
      ],
    );
  }
}

///
/// 单个选项
///
class ChartListItem extends StatefulWidget {
  final User user;

  const ChartListItem({this.user});

  @override
  createState() => new _ChartListItemState();
}

class _ChartListItemState extends State<ChartListItem> {
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
              margin: EdgeInsets.only(left: 24.0),
              width: 200.0,
              child: Text(
                "123",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color(0xFF272727),
                  fontSize: 18.0,
                ),
              ),
            ),
            Container(
              width: 200.0,
              margin: EdgeInsets.only(left: 24.0),
              child: Text(
                "Today Practice",
                style: TextStyle(color: Color(0xFF7B7B7B), fontSize: 12.0),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(right: 16.0),
          width: 69.0,
          height: 25.0,
          child: CatBaseButton(
            "STUDY",
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
  factory AreaAndLineChart.withSampleData() {
    return AreaAndLineChart(
      _createSampleData(),
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
  static List<charts.Series<LinearQuestion, int>> _createSampleData() {
    final yourFakeDesktopData = [
      LinearQuestion(0, "Wed", 34),
      LinearQuestion(1, "Mon", 22),
      LinearQuestion(2, "Tus", 66),
      LinearQuestion(3, "Sun", 43),
      LinearQuestion(4, "Sun", 34),
      LinearQuestion(5, "Sun", 22),
    ];

    return [
      charts.Series<LinearQuestion, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (LinearQuestion question, _) => question.domain,
        measureFn: (LinearQuestion question, _) => question.questions,
        labelAccessorFn: (LinearQuestion question, _) => question.weekend,
        data: yourFakeDesktopData,
      )
        // Configure our custom bar target renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customArea'),
    ];
  }
}

/// 记忆统计
class LinearQuestion {
  final String weekend;
  final int domain;
  final int questions;

  LinearQuestion(this.domain, this.weekend, this.questions);
}
