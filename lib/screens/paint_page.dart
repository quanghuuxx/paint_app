import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/controllers/paintController.dart';
import 'package:flutter_custom_paint/main.dart';
import 'package:flutter_custom_paint/screens/painting_screen.dart';

class PaintPage extends StatelessWidget {
  static List<PaintingPage> mylist = [
    PaintingPage(Controller(), 0),
    PaintingPage(Controller(), 1),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaintingPage(mylist[0].controller, finalindex),
    );
  }
}
