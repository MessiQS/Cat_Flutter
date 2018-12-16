import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/widgets/phone/account_menu.dart';
import 'package:cat/router/cat_route.dart';
import 'package:cat/common/services/sign_up.dart';

///
/// 登录页面
///
class SignUp extends StatelessWidget {
  signUp() async {
    SignUpResponse signUpResponse = await SignUpService.signUp();
    if (signUpResponse.type == true) {
      print("sign up " + signUpResponse.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bgHeight = MediaQuery.of(context).size.height * (11.0 / 26.8);
    AppBar appBar = AppBar(
        backgroundColor: Colors.transparent,
        elevation: .0,
        title: Text("SIGNUP"));

    final double menuWidth = MediaQuery.of(context).size.width - 48.0;
    final double menuHeight = 220.0;

    /// 菜单栏位置 = 顶部视图背景高度 - AppBar高度 - 菜单栏高度的二分之一 - StatusBar高度
    final double menuMarginTop =
        bgHeight - appBar.preferredSize.height - (menuHeight / 2.0) - 20;

    EdgeInsets edge = EdgeInsets.fromLTRB(24.0, menuMarginTop, 24.0, .0);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          /// 背景图片
          Container(
            width: MediaQuery.of(context).size.width,
            height: bgHeight,
            child: Image.asset(
              'images/sign_up_background.png',
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            children: <Widget>[
              appBar,
              // 输入框菜单栏
              Container(
                  margin: edge,
                  width: menuWidth,
                  height: menuHeight,
                  child: AccountMenuStatefulWidget()),
              // "SIGNUP" 按钮
              Container(
                  margin: EdgeInsets.all(24.0),
                  height: 50.0,
                  child: CatBaseButton("注册", onPressed: this.signUp)),
              // "Allready have an account? Login"
              Container(
                  child: new RichText(
                textAlign: TextAlign.center,
                text: new TextSpan(
                  text: '已经注册过账号?',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFFB9B9B9),
                  ),
                  children: <TextSpan>[
                    new TextSpan(
                        text: ' 点击登录',
                        style: TextStyle(color: CatColors.globalTintColor),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushNamed(LOGIN_ROUTE);
                          }),
                  ],
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
