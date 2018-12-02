import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/services/sign_up.dart';

class LoginMenuStatefulWidget extends StatefulWidget {
  LoginMenuStatefulWidget({Key key, this.phone, this.password})
      : super(key: key);
  // 邮箱
  final String phone;
  // 密码
  final String password;

  @override
  _LoginMenuStatefulWidget createState() => _LoginMenuStatefulWidget();
}

class _LoginMenuStatefulWidget extends State<LoginMenuStatefulWidget> {
  TextEditingController phoneTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  showAlert() {}

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
                /// 电话号
                TextField(
                  controller: phoneTEC,
                  decoration: const InputDecoration(
                    hintText: '你的手机号',
                    hintStyle: const TextStyle(
                        color: CatColors.textFieldPlaceHolderColor,
                        fontSize: 14.0),
                    labelText: '手机号',
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
                  keyboardType: TextInputType.phone,
                  cursorColor: CatColors.textFieldCursorColor,
                ),

                /// Password
                TextField(
                  controller: passwordTEC,
                  decoration: const InputDecoration(
                    hintText: '你的密码',
                    hintStyle: const TextStyle(
                        color: CatColors.textFieldPlaceHolderColor,
                        fontSize: 14.0),
                    labelText: '密码',
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
                  cursorColor: CatColors.textFieldCursorColor,
                ),
              ],
            )));
  }
}
