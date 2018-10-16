import 'package:flutter/material.dart';
import 'package:cat/widgets/account_menu.dart';
import 'package:cat/router/cat_route.dart';

///
/// 登录页面
///
class Login extends StatefulWidget {
  @override
  createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _scroll = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      /// 背景图片
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          'images/sign_up_background.png',
          fit: BoxFit.fill,
        ),
      ),
      ListView(
        controller: _scroll,
        children: <Widget>[
          AppBar(
              backgroundColor: Colors.transparent,
              elevation: .0,
              title: Text("LOGIN")),
          Container(
            constraints: BoxConstraints(minHeight: 162.0),
            margin: EdgeInsets.fromLTRB(24.0, 200.0, 24.0, .0),
            child: AccountMenuStatefulWidget(),
          ),
          Container(
            margin: EdgeInsets.only(top: 32.0),
            child: FlatButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(STATISTICS_ROUTE),
              child: const Text(
                'LOGIN',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ),
          ),
        ],
      )
    ]);
  }
}
