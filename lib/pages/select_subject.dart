import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';

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
          const ListTile(title: Text('精致生活'))
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
    return Row(children: <Widget>[
      
    ],);
  }
}
