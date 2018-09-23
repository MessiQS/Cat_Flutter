import 'package:flutter/material.dart';

// pages
import 'package:cat/pages/sign_up.dart';
import 'package:cat/pages/welcome.dart';

///
/// 判断登录前还是登录后
/// 
class CatApp extends StatelessWidget {

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"SIGNUP",
      home:Welcome(),
      // 设置路由
      routes: <String, WidgetBuilder> {
        WELCOME_ROUTE: (BuildContext context) => Welcome(),
        SIGN_UP_ROUTE: (BuildContext context) => SignIn(),
      },
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
      ],
    );
  }
}

