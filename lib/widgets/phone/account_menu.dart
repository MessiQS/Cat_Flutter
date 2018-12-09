import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/services/sign_up.dart';

class AccountMenuStatefulWidget extends StatefulWidget {
  AccountMenuStatefulWidget({Key key, this.phone, this.password})
      : super(key: key);
  // 邮箱
  final String phone;
  // 密码
  final String password;

  @override
  _AccountMenuStatefulWidget createState() => _AccountMenuStatefulWidget();
}

class _AccountMenuStatefulWidget extends State<AccountMenuStatefulWidget> {
  TextEditingController phoneTEC = new TextEditingController();
  TextEditingController captchaTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  captchaButtonOnPress() async {
    String phone = phoneTEC.text;
    if (phone.length < 11) {
      return;
    }
    print("captchaButtonOnPress " + phone);
    GetCaptchaResponse response = await SignUpService.getCaptcha(phone);
    if (response.type == true) {


      
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('注册失败'),
            content: Text(response.data),
          );
        },
      );
    }
  }

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

                Stack(
                  alignment: const Alignment(1.0, 0.7),
                  children: <Widget>[
                    TextField(
                      controller: captchaTEC,
                      decoration: const InputDecoration(
                        hintText: '你的验证码',
                        hintStyle: const TextStyle(
                            color: CatColors.textFieldPlaceHolderColor,
                            fontSize: 14.0),
                        labelText: '验证码',
                        labelStyle: const TextStyle(
                            color: CatColors.textFieldLabelColor),
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
                    Container(
                        width: 69.0,
                        height: 24.0,
                        child: CatBaseButton("获取验证码",
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 12.0,
                            ),
                            onPressed: this.captchaButtonOnPress)),
                  ],
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
