// base lib
import 'package:cat/cats/cats.dart';
import 'package:flutter/material.dart';
import 'package:cat/router/cat_route.dart';

// pages
import 'package:cat/pages/sign_up.dart';
import 'package:cat/pages/welcome.dart';
import 'package:cat/pages/login.dart';
import 'package:cat/pages/statistics.dart';
import 'package:cat/pages/select_subject.dart';
import 'package:cat/pages/select_subject_second.dart';

///
/// 判断登录前还是登录后
///
class CatApp extends StatelessWidget {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return MaterialApp(
      theme: ThemeData(textSelectionColor: CatColors.globalTintColor),
      title: "SIGNUP",
      home: Welcome(),
      // 设置路由
      routes: <String, WidgetBuilder>{
        WELCOME_ROUTE: (BuildContext context) => Welcome(),
        SIGN_UP_ROUTE: (BuildContext context) => SignIn(),
        LOGIN_ROUTE: (BuildContext context) => Login(),
        STATISTICS_ROUTE: (BuildContext context) => Statistics(),
        SElECT_SUBJECT_ROUTE: (BuildContext context) => SelectSubject(),
        SElECT_SUBJECT_SECOND_ROUTE: (BuildContext context) =>
            SelectSubjectSecond(),
      },
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
      ],
    );
  }
}
