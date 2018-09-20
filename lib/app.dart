import 'dart:ui';
import 'package:flutter/material.dart';

class CatApp extends StatelessWidget {

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"title",
      home:Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text("title"),
          elevation: 4.0,
        ),
        body: new ListBody(),
      )
    );
  }
}

