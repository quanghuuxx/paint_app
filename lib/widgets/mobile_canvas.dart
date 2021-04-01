import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_paint/main.dart';
import 'package:flutter_custom_paint/models/path.dart';
import 'package:flutter_custom_paint/screens/paint_page.dart';
import 'package:flutter_custom_paint/widgets/eraser_widget.dart';
import 'package:get/get.dart';
import '../controllers/paint_controller.dart';

class CanvasPainting extends StatefulWidget {
  final Controller controller;

  const CanvasPainting({Key key, this.controller}) : super(key: key);

  @override
  CanvasPaintingState createState() => CanvasPaintingState(controller);
}

Color finalColor = Colors.black;
double finalSize = 2;

class CanvasPaintingState extends State<CanvasPainting> {
  Controller controller;
  Path _path = new Path();
  bool _repaint = false;
  int back = 0;
  double dxeraser = 0;
  double dyeraser = 0;

  Color activeColor = finalColor;

  CanvasPaintingState(this.controller);

  void update() {
    if (PaintPage.mylist[finalindex].controller.isOpened == false) {
      panDown(DragDownDetails());
      PaintPage.mylist[finalindex].controller.isOpened = true;
      PaintPage.mylist[finalindex].controller.paintss.removeLast();
      PaintPage.mylist[finalindex].controller.paths.removeLast();
      PaintPage.mylist[finalindex].controller.filepath.removeLast();
    } else {
      Get.find<ControllerPaintPage>().update();
    }
    //panEnd(DragEndDetails());
  }

  panDown(DragDownDetails details) {
    if (PaintPage.mylist[finalindex].controller.isView) return;
    setState(() {
      controller.filepath.add(List<FilePath>());
      _path = new Path();
      controller.paths.add(_path);
      RenderBox object = context.findRenderObject();
      Offset _localPosition = object.globalToLocal(details.globalPosition);
      controller.paths.last.moveTo(_localPosition.dx, _localPosition.dy);

      controller.paths.last.lineTo(_localPosition.dx, _localPosition.dy);

      Paint paint = new Paint()
        ..color = finalColor
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..strokeWidth = finalSize;
      controller.paintss.add(paint);
      //
      controller.filepath.last.add(FilePath(
          color: finalColor,
          startPoint: _localPosition.dx,
          endPoint: _localPosition.dy,
          strokeWidth: finalSize));

      _repaint = true;
      dxeraser = _localPosition.dx;
      dyeraser = _localPosition.dy;
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
    if (PaintPage.mylist[finalindex].controller.isView) return;
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
      controller.paths.last.lineTo(fingerPostionX, fingerPostionY);
      controller.filepath.last.add(FilePath(
          color: finalColor,
          startPoint: fingerPostionX,
          endPoint: fingerPostionY,
          strokeWidth: finalSize));
      dxeraser = fingerPostionX;
      dyeraser = fingerPostionY;
    });
  }

  panEnd(DragEndDetails details) {
    fingerPostionY = 0.0;
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
    controller = PaintPage.mylist[finalindex].controller;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: GestureDetector(
          onPanDown: (DragDownDetails details) => panDown(details),
          onPanUpdate: (DragUpdateDetails details) => panUpdate(details),
          onPanEnd: (DragEndDetails details) => panEnd(details),
          child: RepaintBoundary(
            child: Stack(
              children: <Widget>[
                CustomPaint(
                  painter: PathPainter(
                      dxeraser: dxeraser,
                      dyeraser: dyeraser,
                      paths: controller.paths,
                      repaint: _repaint,
                      paints: PaintPage.mylist[finalindex].controller.paintss),
                  size: Size.infinite,
                ),
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
  double dxeraser = 0;
  double dyeraser = 0;
  bool repaint;
  int i = 0;
  PathPainter(
      {this.paths, this.repaint, this.paints, this.dxeraser, this.dyeraser});

  @override
  void paint(Canvas canvas, Size size) {
    paths.forEach((path) {
      canvas.drawPath(path, paints[i]);
      ++i;
    });
    if (EraserWidget.isErasrering) {
      final pointMode = PointMode.points;
      final points = [
        Offset(dxeraser, dyeraser),
      ];
      final paint = Paint()
        ..color = Colors.grey[400]
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = finalSize;
      canvas.drawPoints(pointMode, points, paint);
    }
    i = 0;
    repaint = false;
  }

  static Future<Uint8List> takePic(Size size) async {
    List<Path> pa = PaintPage.mylist[0].controller.paths;
    PictureRecorder pictureRecorder = PictureRecorder();
    Canvas canvass = Canvas(pictureRecorder);
    int i = 0;
    pa.forEach((pa) {
      canvass.drawPath(pa, PaintPage.mylist[0].controller.paintss[i]);
      ++i;
    });
    Picture picture = pictureRecorder.endRecording();
    Image image =
        await picture.toImage(size.height.toInt(), size.width.toInt());

    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
    // return image;
  }

  static Future<Image> tinypng(bytearray) async {
    // copy from decodeImageFromList of package:flutter/painting.dart
    final codec = await instantiateImageCodec(bytearray);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => repaint;
}
