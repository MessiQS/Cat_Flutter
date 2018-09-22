import 'package:flutter/material.dart';

class CatBaseButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final double fontSize;

  CatBaseButton({@required this.onPressed, this.text, this.fontSize})
      : assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.amber,
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
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: fontSize == null ? 14.0 : fontSize),
            ),
          ),
        ),
      ),
    );
  }
}
