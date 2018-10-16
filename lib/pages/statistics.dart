import 'dart:async';

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
        appBar: AppBar(
            backgroundColor: CatColors.globalTintColor,
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
        )
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
        Container(
          margin: EdgeInsets.only(left: 24.0),
          child: Text("123"),
        ),
        Container(
          margin: EdgeInsets.only(right: 16.0),
          width: 69.0,
          height: 25.0,
          child: CatBaseButton(
            "STUDY",
            onPressed: () =>
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return Answer(
                    user: widget.user,
                  );
                })),
          ),
        )
      ],
    ));
  }
}
