import 'package:flutter/material.dart';

class Account {
  Account({
    this.email,
    this.password,
  });
  // 邮箱
  String email;
  // 密码
  String password;
}

const String SIGN_IN_ROUTE = "cat://sign_in";

///
/// 登录页面
///
class SignIn extends StatelessWidget {
  // 账号
  // final Account account = Account();

  final Account account = (Account()
    ..email = ''
    ..password = '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("SignIn"),
        elevation: 4.0,
      ),
      body: new ListBody(),
    );
  }
}
