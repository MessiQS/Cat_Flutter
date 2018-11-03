import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/router/cat_route.dart';
import 'package:cat/common/db/db.dart';
import 'package:cat/pages/answer.dart';
import 'package:cat/common/services/statistics.dart';

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
        ChartItem(
          user: widget.user,
        ),
        Container(
          margin: EdgeInsets.all(16.0),
          width: 200.0,
          height: 200.0,
          // child: AreaAndLineChart.withSampleData(),
          child: FutureBuilder(
            future:
                StatisticsService.fetchTPChartElems(widget.user.currentExamID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AreaAndLineChart(snapshot.data);
              }
              return Placeholder();
            },
          ),
        ),
        RaisedButton(
          child: Text("data"),
          onPressed: () {
            StatisticsService.fetchTPChartElems(widget.user.currentExamID);
          },
        )
      ],
    );
  }
}

///
/// 单个选项
///
class ChartItem extends StatefulWidget {
  final User user;

  const ChartItem({this.user});

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
    // final yourFakeDesktopData = [
    //   ChartElem(0, 34),
    //   ChartElem(1, 22),
    //   ChartElem(2, 66),
    //   ChartElem(3, 43),
    //   ChartElem(4, 34),
    //   ChartElem(5, 22),
    // ];

    return [
      charts.Series<ChartElem, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (ChartElem question, _) => question.domain,
        measureFn: (ChartElem question, _) => question.questions,
        data: list,
      )
        // Configure our custom bar target renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customArea'),
    ];
  }
}

class BottomActionSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ActionSheetItem(
          url: "images/action_notification.png",
          text: "Notification",
        )
      ],
    );
  }
}

class ActionSheetItem extends StatelessWidget {
  final String url;
  final String text;
  const ActionSheetItem({this.url, this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 24.0,
          height: 24.0,
          margin: EdgeInsets.fromLTRB(24.0, 16.0, 32.0, 16.0),
          child: Image.asset(url),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
      ],
    );
  }
}
