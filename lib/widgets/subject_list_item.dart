import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';

///
/// 选项
///
class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    this.title,
    this.onPressed,
  });

  /// 标题
  final String title;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 72.0,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16.0),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                title,
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            Container(
                height: 25.0,
                width: 69.0,
                child: CatBaseButton("SELECT", onPressed: onPressed)),
          ],
        ));
  }
}
