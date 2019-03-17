import 'package:flutter/material.dart';
import 'package:cat/router/cat_route.dart';
import 'package:cat/widgets/phone/login_menu.dart';
import 'package:cat/common/services/login.dart';
import 'package:cat/common/dao/user.dart';
import 'package:cat/widgets/loading.dart';

///
/// 登录页面
///
class Login extends StatefulWidget {
  @override
  createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  String phone = "";
  String password = "";
  ScrollController _scroll;
  @override
  void initState() {
    super.initState();
    _scroll = new ScrollController();
  }

  loginButtonOnPress() async {
    LoginResponse response = await LoginService.login(phone, password);
    if (response.type == true) {
      showDialog(context: context, builder: (context) => LoaderWidget());

      String token = response.data["token"];
      String userID = response.data["user_id"];

      await UserDao.saveUserToDB(userID, token);
      await LoginService.synchronizeNetworkData(userID);

      /// 取消弹窗
      Navigator.of(context).pop();

      /// 返回至统计页面
      Navigator.of(context).pushNamedAndRemoveUntil(
          STATISTICS_ROUTE, (Route<dynamic> route) => false);
    } else {
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
    }
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
              title: Text("登录")),
          Container(
            constraints: BoxConstraints(minHeight: 162.0),
            margin: EdgeInsets.fromLTRB(24.0, 200.0, 24.0, .0),
            child: LoginMenuStatefulWidget(
              phoneCallback: (value) {
                this.phone = value;
              },
              passwordCallback: (value) {
                this.password = value;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 32.0),
            child: FlatButton(
              onPressed: () => loginButtonOnPress(),
              child: const Text(
                '登录',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ),
          ),
        ],
      )
    ]);
  }
}
