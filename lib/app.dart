import 'package:flutter/material.dart';

// pages
import 'package:cat/pages/sign_up.dart';
import 'package:cat/pages/welcome.dart';
import 'package:cat/router/cat_route.dart';
import 'package:cat/pages/login.dart';
import 'package:cat/cats/cats.dart';

///
/// 判断登录前还是登录后
///
class CatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textSelectionColor:CatColors.globalTintColor),
      title: "SIGNUP",
      home: Welcome(),
      // 设置路由
      routes: <String, WidgetBuilder>{
        WELCOME_ROUTE: (BuildContext context) => Welcome(),
        SIGN_UP_ROUTE: (BuildContext context) => SignIn(),
        LOGIN_ROUTE: (BuildContext context) => Login(),
      },
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
      ],
    );
  }
}
