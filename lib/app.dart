// base lib
import 'package:cat/cats/cats.dart';
import 'package:flutter/material.dart';
import 'package:cat/router/cat_route.dart';
import 'package:cat/common/services/login.dart';

// pages
import 'package:cat/pages/phone/sign_up.dart';
import 'package:cat/pages/welcome.dart';
import 'package:cat/pages/phone/login.dart';
import 'package:cat/pages/statistics.dart';
import 'package:cat/pages/select_subject.dart';
import 'package:cat/pages/select_subject_second.dart';
import 'package:cat/pages/select_subject_third.dart';
import 'package:cat/pages/answer.dart';
import 'package:cat/pages/feedback.dart';

///
/// 判断登录前还是登录后
///
class CatApp extends StatelessWidget {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return MaterialApp(
      theme: ThemeData(
        textSelectionColor: CatColors.globalTintColor,
        cursorColor: CatColors.globalTintColor,
      ),
      title: "注册",
      home: FutureBuilder(
          future: LoginService.isLogin(),
          builder: (context, snapshot) {
            if (snapshot.data) {
              return Statistics();
            } else {
              return Welcome();
            }
          }),
      // 设置路由
      routes: <String, WidgetBuilder>{
        WELCOME_ROUTE: (BuildContext context) => Welcome(),
        SIGN_UP_ROUTE: (BuildContext context) => SignUp(),
        LOGIN_ROUTE: (BuildContext context) => Login(),
        STATISTICS_ROUTE: (BuildContext context) => Statistics(),
        SElECT_SUBJECT_ROUTE: (BuildContext context) => SelectSubject(),
        SElECT_SUBJECT_SECOND_ROUTE: (BuildContext context) =>
            SelectSubjectSecond(),
        SElECT_SUBJECT_THIRD_ROUTE: (BuildContext context) =>
            SelectSubjectThird(),
        ANSWER_ROUTE: (BuildContext context) => Answer(),
        FEEDBACK_ROUTE: (BuildContext context) => FeedbackPage(),
      },
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
      ],
    );
  }
}
