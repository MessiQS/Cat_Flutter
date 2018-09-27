import 'package:flutter/material.dart';

class CatBaseButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final TextStyle textStyle;
  final String data;

  CatBaseButton(
    this.data, {
    @required this.onPressed,
    this.textStyle = const TextStyle(
        color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14.0),
  }) : assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.accents.first,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                colors: [Color(0xFFFF6961), Color(0xFFFF8D29)],
                tileMode: TileMode.clamp),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
            boxShadow: [
              new BoxShadow(
                color: Colors.grey[500],
                blurRadius: 20.0,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: Center(
              child: Text(
            data,
            textAlign: TextAlign.center,
            style: textStyle,
          )),
        ),
      ),
    );
  }
}
