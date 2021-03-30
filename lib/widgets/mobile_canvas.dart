import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_custom_paint/main.dart';

import '../controllers/paintController.dart';

class CanvasPainting extends StatefulWidget {
  final Controller controller;

  CanvasPainting(this.controller);

  @override
  _CanvasPaintingState createState() => _CanvasPaintingState(controller);
}

Color finalColor = Colors.black;
double finalSize = 2;

class _CanvasPaintingState extends State<CanvasPainting> {
  Controller controller;
  Path _path = new Path();
  bool _repaint = false;
  int back = 0;

  GlobalKey globalKey = GlobalKey();
  Color activeColor = finalColor;

  _CanvasPaintingState(this.controller) {
    controller.paths = [new Path()];

    Paint paint = new Paint()
      ..color = finalColor
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..strokeWidth = finalSize;
    controller.paintss.add(paint);
  }

  panDown(DragDownDetails details) {
    setState(() {
      _path = new Path();
      controller.paths.add(_path);
      RenderBox object = context.findRenderObject();
      Offset _localPosition = object.globalToLocal(details.globalPosition);
      controller.paths.last
          .moveTo(_localPosition.dx - 10, _localPosition.dy - 5);

      controller.paths.last
          .lineTo(_localPosition.dx - 10, _localPosition.dy - 5);

      Paint paint = new Paint()
        ..color = finalColor
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..strokeWidth = finalSize;
      controller.paintss.add(paint);

      _repaint = true;
    });
  }

  var fingerPostionY = 0.0, fingerPostionX = 0.0;
  double distanceBetweenTwoPoints(double x1, double y1, double x2, double y2) {
    double x = x1 - x2;
    x = x * x;
    double y = y1 - y2;
    y = y * y;

    double result = x + y;
    return sqrt(result);
  }

  panUpdate(DragUpdateDetails details) {
    RenderBox object = context.findRenderObject();
    Offset _localPosition = object.globalToLocal(details.globalPosition);

    if (fingerPostionY < 1.0) {
      // assigen for the first time to compare
      fingerPostionY = _localPosition.dy;
      fingerPostionX = _localPosition.dx;
    } else {
      // they use a lot of fingers
      double distance = distanceBetweenTwoPoints(
          _localPosition.dx, _localPosition.dy, fingerPostionX, fingerPostionY);

      // the distance between two fingers must be above 50
      // to disable multi touch
      if (distance > 50) {
        return;
      }
    }

    // update to use it in comparison
    fingerPostionY = _localPosition.dy;
    fingerPostionX = _localPosition.dx;

    setState(() {
      controller.paths.last.lineTo(fingerPostionX - 10.0, fingerPostionY - 5.0);
    });
  }

  panEnd(DragEndDetails details) {
    setState(() {
      fingerPostionY = 0.0;
//      _repaint = true;
    });
  }

  reset() {
    setState(() {
      _path = new Path();
      controller.paths = [new Path()];
      controller.paintss = [new Paint()];
      _repaint = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    controller = MyApp.mylist[finalindex].controller;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: GestureDetector(
          onPanDown: (DragDownDetails details) => panDown(details),
          onPanUpdate: (DragUpdateDetails details) => panUpdate(details),
          onPanEnd: (DragEndDetails details) => panEnd(details),
          child: RepaintBoundary(
            key: globalKey,
            child: Stack(
              children: <Widget>[
                CustomPaint(
                  painter: new PathPainter(
                      paths: controller.paths,
                      repaint: _repaint,
                      paints: controller.paintss),
                  size: Size.infinite,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  List<Path> paths;
  List<Paint> paints;
  bool repaint;
  int i = 0;
  PathPainter({this.paths, this.repaint, this.paints});

  @override
  void paint(Canvas canvas, Size size) {
    paths.forEach((path) {
      canvas.drawPath(path, paints[i]);
      ++i;
    });

    i = 0;
    repaint = false;
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => repaint;
}
