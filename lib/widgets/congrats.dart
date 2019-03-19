import 'package:flutter/material.dart';

class Congrats extends StatelessWidget {
  final VoidCallback goBack;
  Congrats({this.goBack});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Image.asset(
            'images/congrats.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
          Center(
              child: Container(
            margin: EdgeInsets.only(top: 300.0),
            child: FlatButton(
              child: const Text(
                '返回',
                style: TextStyle(fontSize: 14.0, color: Color(0xFFFF7B46)),
              ),
              onPressed: this.goBack,
            ),
          ))
        ],
      ),
    );
  }
}
