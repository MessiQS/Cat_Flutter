import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/widgets/phone/account_menu.dart';
import 'package:cat/router/cat_route.dart';
import 'package:cat/common/services/sign_up.dart';
import 'package:cat/common/dao/user.dart';
import 'package:cat/common/services/login.dart';

///
/// 注册页面
///
class SignUp extends StatelessWidget {
  signUp(BuildContext context) async {
    /// 注册
    SignUpResponse response = await SignUpService.signUp();
    if (response.type == false) {
      /// 取消弹窗
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('注册失败'),
            content: Text(response.data),
          );
        },
      );
      return;
    }

    /// 登录
    LoginResponse loginResponse =
        await LoginService.login(SignUpService.phone, SignUpService.password);

    if (loginResponse.type == false) {
      /// 取消弹窗
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('登录失败'),
            content: Text(response.data),
          );
        },
      );
      return;
    }

    String token = loginResponse.data["token"];
    String userID = loginResponse.data["user_id"];

    await UserDao.saveUserToDB(userID, token);

    /// 返回至统计页面
    Navigator.of(context).pushNamedAndRemoveUntil(
        STATISTICS_ROUTE, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final double bgHeight = MediaQuery.of(context).size.height * (11.0 / 26.8);
    AppBar appBar = AppBar(
        backgroundColor: Colors.transparent, elevation: .0, title: Text("注册"));

    final double menuWidth = MediaQuery.of(context).size.width - 48.0;
    final double menuHeight = 250.0;

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
                  child: CatBaseButton("注册", onPressed: () => signUp(context))),
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
          ),
        ],
      ),
    );
  }
}
