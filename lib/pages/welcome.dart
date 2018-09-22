import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';

const String WELCOME_ROUTE = "cat://welcome";

///
/// 欢迎页
///
class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center(
            child: new Column(
      children: <Widget>[
        /// 顶部图片
        new Image.asset(
          'images/welcome_header.png',
          height: 305.0,
          fit: BoxFit.fitHeight,
        ),

        /// 中间文字
        new Container(
          margin: const EdgeInsets.fromLTRB(.0, 63.0, .0, .0),
          child: new Image.asset(
            'images/welcome_text.png',
            height: 96.0,
            fit: BoxFit.fitHeight,
          ),
        ),

        /// SIGNIN 按钮
        new Container(
          margin: const EdgeInsets.fromLTRB(.0, 63.0, .0, .0),
            child: new FlatButton(
          child: new Image.asset(
            'images/welcome_sign_in_button.png',
            width: 231.0,
            fit: BoxFit.cover,
          ),
          onPressed: () {
            // Perform some action
          },
        )),

        // new Container(
        //   margin: const EdgeInsets.fromLTRB(10.0, 63.0, 20.0, 20.0),
        //   child: 
        // )
        new CatBaseButton(onPressed: () => {}, text:"SIGNUP", height: 40.0, width: 230.0),
      ],
    )));
  }
}
