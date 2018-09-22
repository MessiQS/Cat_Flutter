import 'package:flutter/material.dart';

// pages
import 'package:cat/pages/sign_in.dart';
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
        SIGN_IN_ROUTE: (BuildContext context) => SignIn(),
        WELCOME_ROUTE: (BuildContext context) => Welcome(),
      },
      supportedLocales: [
        const Locale('en'),
        const Locale('cn'),
      ],
    );
  }
}

