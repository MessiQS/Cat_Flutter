import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/services/sign_up.dart';
import 'dart:ui';
import 'dart:async';

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

  // captcha 验证码
  String captchaButtonText;
  Timer _timer;
  int _start = 60;

  void startTimer() {
    _start = 60;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start < 1) {
                timer.cancel();
              } else {
                _start = _start - 1;
              }
            }));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  captchaButtonOnPress() async {
    String phone = phoneTEC.text;
    if (phone.length < 11) {
      return;
    }
    GetCaptchaResponse response = await SignUpService.getCaptcha(phone);
    print(response.data);

    if (response.type == true) {
      startTimer();
      setState(() {});
    } else {
      showAlert(response.data);
    }
  }

  String numberValidator(String value) {
    if (value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" 不是个有效数字';
    }
    return null;
  }

  showAlert(String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('注册失败'),
          content: Text(content),
        );
      },
    );
  }

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
                  onChanged: (value) => SignUpService.phone = value,
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
                  maxLength: 11,
                ),

                /// Captcha
                Stack(
                  alignment: const Alignment(1.0, 0.7),
                  children: <Widget>[
                    TextField(
                      controller: captchaTEC,
                      onChanged: (value) => SignUpService.captcha = value,
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
                        width: 69.0, height: 24.0, child: getCaptchaButton()),
                  ],
                ),

                /// Password
                TextField(
                  controller: passwordTEC,
                  onChanged: (value) => SignUpService.password = value,
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
                  maxLength: 32,
                  onSubmitted: (term) {
                  },
                ),
              ],
            )));
  }

  getCaptchaButton() {
    if (_timer != null && _timer.isActive) {
      return Material(
          color: Colors.grey,
          elevation: 5.0,
          borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          child: Center(
            child: Text(
              "$_start",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ));
    } else {
      return CatBaseButton("获取验证码",
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 12.0,
          ),
          onPressed: this.captchaButtonOnPress);
    }
  }
}
