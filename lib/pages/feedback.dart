import 'package:flutter/material.dart';
import 'package:cat/common/db/provider/question.dart';
import 'package:cat/cats/cats.dart';
import 'package:cat/common/services/feedback.dart';

class FeedbackPage extends StatefulWidget {
  final Question question;
  const FeedbackPage({this.question});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String _email;
  String _desc;
  final formKey = GlobalKey<FormState>();

  TextEditingController emailTEC = TextEditingController();
  TextEditingController feedbackTEC = TextEditingController();

  sendFeedbackOnPressed() {
    final form = formKey.currentState;
    if (form.validate()) {
      print('''
        _email: $_email
        _desc: $_desc
      ''');
    }

    print('''
    emailTEC:    ${emailTEC.text}
    feedbackTEC: ${feedbackTEC.text}
    ''');

    FeedBackService.sendFeedBack(emailTEC.text, feedbackTEC.text);
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: Text("Send Feedback"), actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.send),
          onPressed: sendFeedbackOnPressed,
          tooltip: 'send',
        ),
      ]),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(24.0),
          children: <Widget>[
            TextFormField(
              controller: feedbackTEC,
              validator: (value) =>
                  value.length < 10 ? 'Not a valid desc.' : null,
              onSaved: (val) => _desc = val,
              decoration: const InputDecoration(
                hintText: 'Tell us about content incorrect',
                hintStyle: const TextStyle(
                    color: CatColors.textFieldPlaceHolderColor, fontSize: 14.0),
                labelText: 'Describe Feedback',
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
              maxLines: 4,
            ),
            const SizedBox(height: 24.0),

            /// E-mail
            TextFormField(
              controller: emailTEC,
              validator: (value) =>
                  isEmail(value) == false ? 'Not a valid email.' : null,
              onSaved: (val) => _email = val,
              decoration: const InputDecoration(
                hintText: 'Your email address',
                hintStyle: const TextStyle(
                    color: CatColors.textFieldPlaceHolderColor, fontSize: 14.0),
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
              // cursorColor: CatColors.textFieldCursorColor,
            ),
          ],
        ),
      ),
    );
  }
}
