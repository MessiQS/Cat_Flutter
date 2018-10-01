import 'package:flutter/material.dart';
import 'package:cat/cats/cats.dart';

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
                TextField(
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
                  cursorColor: CatColors.textFieldCursorColor,
                ),

                /// Password
                TextField(
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
                  cursorColor: CatColors.textFieldCursorColor,
                ),
              ],
            )));
  }
}
