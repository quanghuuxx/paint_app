import 'dart:ui';

import 'package:get/get.dart';
import 'package:flutter_custom_paint/models/path.dart';

class ControllerPaintPage extends GetxController {}

class Controller {
  List<Path> paths = new List<Path>();
  List<Paint> paintss = new List<Paint>();
  List<List<FilePath>> filepath = [];

  setPath() {
    for (int i = 0; i < filepath.length; i++) {
      Path newPath = Path();
      Paint pain = Paint();
      pain.style = PaintingStyle.stroke;
      pain.strokeJoin = StrokeJoin.round;
      pain.strokeCap = StrokeCap.round;
      pain.color = filepath[i][0].color;

      pain.strokeWidth = filepath[i][0].strokeWidth;
      for (int j = 0; j < filepath[i].length; j++) {
        if (j == 0) {
          newPath.moveTo(filepath[i][j].startPoint, filepath[i][j].endPoint);
        }
        newPath.lineTo(filepath[i][j].startPoint, filepath[i][j].endPoint);
      }

      paintss.add(pain);
      paths.add(newPath);
    }
  }
}
