import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/main.dart';
import 'package:flutter_custom_paint/screens/paint_page.dart';
import 'package:flutter_custom_paint/widgets/mobile_canvas.dart';

class EraserWidget {
  static int selectedIndex = 0;
  static BuildContext context;
  static var clearFuntion;
  static double finaltempSize = 2;
  static bool isErasrering = false;
  static List<Widget> listChosen = [
    Container(
      color: Colors.blue,
      height: 30,
      child: Center(
        child: Text('Chọn phương thức tẩy'),
      ),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        colorContainer(context, Colors.white, 20, 20, 0),
        colorContainer(context, Colors.white, 30, 30, 1),
        colorContainer(context, Colors.white, 40, 40, 2),
        InkWell(
          onTap: () {
            PaintPage.mylist[finalindex].controller.setRemoveAllData();
            clearFuntion();
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(50)),
            height: 40,
            width: 40,
            child: Center(
              child: Text(
                'Tẩy Hết',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        ),
      ],
    ),
  ];
  static eraserDialog(context, width, height, Function() clearFun) {
    EraserWidget.context = context;
    clearFuntion = clearFun;
    showDialog(
        context: context,
        builder: (builder) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: Colors.white,
            child: Container(
              padding: EdgeInsets.all(5),
              width: width * 0.1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: listChosen,
              ),
            ),
          );
        });
  }

  static Widget colorContainer(
      context, Color color, double height, double width, index) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: InkWell(
        onTap: () {
          finalColor = Colors.white;
          if (isErasrering == false) {
            finaltempSize = finalSize;
          }
          isErasrering = true;
          finalSize = height;
          Navigator.of(context).pop();
        },
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}