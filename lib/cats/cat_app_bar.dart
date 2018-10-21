import 'package:flutter/material.dart';

class GradientAppBar extends StatefulWidget implements PreferredSizeWidget {
  // AppBar properties - Add all you need to change
  final Widget title;
  final PreferredSizeWidget bottom;
  final Widget leading;

  final List<Widget> actions;

  @override
  final Size preferredSize;

  GradientAppBar({
    Key key,
    this.title,
    this.bottom,
    this.actions,
    this.leading,
  })  : preferredSize = new Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key); //appBar.preferredSize;

  @override
  _GradientAppBarState createState() => _GradientAppBarState();
}

class _GradientAppBarState extends State<GradientAppBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Material(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  colors: [Color(0xFFFF6961), Color(0xFFFF8D29)],
                  tileMode: TileMode.clamp),
            ),
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: widget.title,
          actions: widget.actions,
          leading: widget.leading,
        ),
      ],
    );
  }
}
