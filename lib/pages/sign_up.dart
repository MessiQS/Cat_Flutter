import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cat/cats/cats.dart';
import 'dart:math' as math;

///
/// 登录页面
///
class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double bgHeight = MediaQuery.of(context).size.height * (11.0 / 26.8);
    final double menuMarginTop = bgHeight - 81.0;
    final double menuWidth = MediaQuery.of(context).size.width - 48.0;
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
          Column(
            children: <Widget>[
              // 输入框菜单栏
              Container(
                  margin: edge,
                  width: menuWidth,
                  height: 162.0,
                  child: AccountMenuStatefulWidget()),
              // "SIGNUP" 按钮
              Container(
                  margin: EdgeInsets.all(24.0),
                  height: 50.0,
                  child: CatBaseButton(onPressed: () => {}, text: "SIGNUP")),
              // "Allready have an account? Login"
              Container(
                  child: new RichText(
                text: new TextSpan(
                  text: 'Allready have an account?',
                  style: TextStyle(fontSize: 14.0, color: Color(0xFFB9B9B9)),
                  children: <TextSpan>[
                    new TextSpan(
                        text: ' Login',
                        style: TextStyle(color: CatColors.globalTintColor),
                        recognizer: new TapGestureRecognizer()..onTap = () {}),
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

class AccountMenuStatefulWidget extends StatefulWidget {
  AccountMenuStatefulWidget({Key key, this.email, this.password})
      : super(key: key);
  // 邮箱
  String email;
  // 密码
  String password;

  @override
  _AccountMenuStatefulWidget createState() => _AccountMenuStatefulWidget();
}

class _AccountMenuStatefulWidget extends State<AccountMenuStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 8.0,
        color: Colors.white,
        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
        child: Container(
            padding: EdgeInsets.fromLTRB(32.0, 12.0, 32.0, .0),
            child: Column(
              children: <Widget>[
                /// E-mail
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Your email address',
                    hintStyle: const TextStyle(
                        color: CatColors.textFieldPalceHolderColor,
                        fontSize: 14.0),
                    labelText: 'E-mail',
                    labelStyle:
                        const TextStyle(color: CatColors.textFieldLabelColor),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                        color: CatColors.globalTintColor,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                        color: CatColors.textFieldUnderLineEnableColor,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                /// Password
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Your Password',
                    hintStyle: const TextStyle(
                        color: CatColors.textFieldPalceHolderColor,
                        fontSize: 14.0),
                    labelText: 'Password',
                    labelStyle:
                        const TextStyle(color: CatColors.textFieldLabelColor),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                        color: CatColors.globalTintColor,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                        color: CatColors.textFieldUnderLineEnableColor,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  maxLength: 16,
                ),
              ],
            )));
  }
}
