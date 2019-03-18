import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'images/loader_background.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ImageRotate(),
                  Text(
                    "请稍后",
                    style: TextStyle(color: Colors.white, fontSize: 28.0),
                  ),
                  Text(
                    "我们正在加载任务",
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class ImageRotate extends StatefulWidget {
  @override
  _ImageRotateState createState() => new _ImageRotateState();
}

class _ImageRotateState extends State<ImageRotate>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 4),
    );

    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: animationController,
      child: new Container(
        height: 150.0,
        width: 150.0,
        child: new Image.asset('images/loader.png'),
      ),
      builder: (BuildContext context, Widget _widget) {
        return new Transform.rotate(
          angle: -animationController.value * 6.3,
          child: _widget,
        );
      },
    );
  }
}
