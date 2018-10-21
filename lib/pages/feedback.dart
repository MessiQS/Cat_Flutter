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
        appBar: AppBar(
            backgroundColor: CatColors.globalTintColor,
            title: Text("Send Feedback"),
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {},
                tooltip: 'send',
              ),
            ]),
        body: Container());
  }
}
