import 'dart:convert';

import 'package:flutter/material.dart';

class FilePath {
  Color color;
  PaintingStyle paintingStyle = PaintingStyle.stroke;
  StrokeJoin strokeJoin = StrokeJoin.round;
  StrokeCap strokeCap = StrokeCap.round;
  double strokeWidth;
  double startPoint;
  double endPoint;

  FilePath({
    @required this.color,
    this.strokeWidth = 0.0,
    this.startPoint = 0.0,
    this.endPoint = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'color': color.value,
      'strokeWidth': strokeWidth,
      'startPoint': startPoint,
      'endPoint': endPoint,
    };
  }

  factory FilePath.fromMap(Map<String, dynamic> map) {
    return FilePath(
      color: Color(map['color']),
      strokeWidth: map['strokeWidth'],
      startPoint: map['startPoint'],
      endPoint: map['endPoint'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FilePath.fromJson(String source) =>
      FilePath.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FilePath(color: $color, strokeWidth: $strokeWidth, startPoint: $startPoint, endPoint: $endPoint)';
  }
}
