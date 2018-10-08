import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/router/cat_route.dart';
import 'package:cat/common/db/db.dart';

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
              return ChartTable(
                title: snapshot.data.currentExamTitle,
                examID: snapshot.data.currentExamID,
              );
            }
            return BeginStudy();
          },
        ));
  }
}

Future<User> fetchUser() async {
  UserProvider userProvider = new UserProvider();
  User user = await userProvider.getUser(1);

  print(user);

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

class ChartTable extends StatefulWidget {
  const ChartTable({Key key, this.title = "", this.examID = ""})
      : super(key: key);

  final String title;
  final String examID;

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
                  child: Text(widget.title),
                ),
                Container(
                  margin: EdgeInsets.only(right: 16.0),
                  width: 69.0,
                  height: 25.0,
                  child: CatBaseButton(
                    "SELECT",
                    onPressed: () {},
                  ),
                )
              ],
            ))
      ],
    );
  }
}
