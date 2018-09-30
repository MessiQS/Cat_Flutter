import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/net/net.dart';

class SelectSubject extends StatefulWidget {
  @override
  createState() => new _SelectSubjectState();
}

class _SelectSubjectState extends State<SelectSubject> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Subject"),
          backgroundColor: CatColors.globalTintColor,
        ),
        body: new ListView(children: <Widget>[
          const ListTile(title: Text('Top')),
          new ExpansionTile(
              title: const Text('梅西语录'),
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
              children: const <Widget>[
                ListTile(title: Text('生命的意义')),
                ListTile(title: Text('历史赋予我们的责任')),
                // https://en.wikipedia.org/wiki/Free_Four
                ListTile(title: Text('活在当下')),
                ListTile(title: Text('创业维艰')),
              ]),
          const ListTile(title: Text('精致生活')),
          Center(
              child: FutureBuilder<SelectSubjectGet>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    return CircularProgressIndicator();
                  }))
        ]));
  }
}

///
/// 选项
///
class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    this.title,
  });

  /// 标题
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[],
    );
  }
}

///
/// 网络请求
///
Future<SelectSubjectGet> fetchData() async {
  String url = Address.getSecondType();
  Map<String, dynamic> params = {'one': "1", 'two': "2", 'twelve': 2};
  final response = await HttpManager.request(Method.Get, url);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return SelectSubjectGet.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class SelectSubjectGet {

  final bool success;
  final List<Map> data;

  SelectSubjectGet({this.success, this.data});

  factory SelectSubjectGet.fromJson(Map<String, dynamic> json) {
    return SelectSubjectGet(
      success: json['type'],
      data: json['data'],
    );
  }
}
