import 'package:flutter/material.dart';
import 'package:cat/common/db/provider/question.dart';
import 'package:cat/cats/cats.dart';

class FeedbackPage extends StatefulWidget {
  final Question question;
  const FeedbackPage({this.question});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(title: Text("Send Feedback"), actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
            tooltip: 'send',
          ),
        ]),
        body: ListView(
          padding: EdgeInsets.all(24.0),
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
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
            TextField(
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
              cursorColor: CatColors.textFieldCursorColor,
            ),
          ],
        ));
  }
}
