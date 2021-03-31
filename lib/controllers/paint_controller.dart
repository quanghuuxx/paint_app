import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/screens/paint_page.dart';
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

  toArrayMap() {
    List<dynamic> filePaths = [];
    for (int i = 0; i < filepath.length; i++) {
      List<dynamic> line = [];
      for (int j = 0; j < filepath[i].length; j++) {
        line.add({
          "color": filepath[i][j].color.value,
          "strokeWith": filepath[i][j].strokeWidth,
          "startPoint": filepath[i][j].startPoint,
          "endPoint": filepath[i][j].endPoint
        });
      }
      filePaths.add({"line": line});
    }
    return filePaths;
  }

  setfilePath(List listFilePath) {
    for (int i = 0; i < listFilePath.length; i++) {
      List<FilePath> line = [];
      for (int j = 0; j < listFilePath[i]["line"].length; j++) {
        FilePath filePath = FilePath(
            color: Color(listFilePath[i]["line"][j]['color']),
            startPoint: listFilePath[i]["line"][j]['startPoint'],
            endPoint: listFilePath[i]["line"][j]['endPoint'],
            strokeWidth: listFilePath[i]["line"][j]['strokeWith']);
        line.add(filePath);
      }
      this.filepath.add(line);
    }
  }

  List getAllData() {
    List pages = [];
    for (int i = 0; i < PaintPage.mylist.length; i++) {
      pages.add({"listfilepath": PaintPage.mylist[i].controller.toArrayMap()});
    }
    return pages;
  }

  Map<String, dynamic> setMap() {
    return {
      "name": "bài mới",
      "page": getAllData(),
      "token": "3rf2f23t523423f23r2fd2d543"
    };
  }
}
