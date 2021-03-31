import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/widgets/mobile_canvas.dart';

class EraserWidget {
  static int selectedIndex = 0;
  static BuildContext context;
  static var clearFuntion;
  static double finaltempSize = 2;
  static List<Widget> listChosen = [
    Container(
      color: Colors.blue,
      height: 30,
      child: Center(
        child: Text('Chọn phương thức tẩy'),
      ),
    ),
    InkWell(
      onTap: () {
        clearFuntion();
        Navigator.of(context).pop();
      },
      child: Container(
        height: 30,
        child: Center(
          child: Text('Tẩy cả trang'),
        ),
      ),
    ),
    colorContainer(context, Colors.white, 20, 20, 0),
    colorContainer(context, Colors.white, 30, 30, 1),
    colorContainer(context, Colors.white, 40, 40, 2),
  ];
  static eraserDialog(context, width, height, Function() clearFun) {
    EraserWidget.context = context;
    clearFuntion = clearFun;
    showDialog(
        context: context,
        builder: (builder) {
          return Container(
            width: width * 0.3,
            height: height * 0.7,
            child: Padding(
              padding:
                  EdgeInsets.only(left: width * 0.70, bottom: height * 0.1),
              child: Dialog(
                backgroundColor: Colors.white,
                child: Container(
                  // height: height * 0.9,
                  width: width * 0.7,
                  color: Colors.white,
                  child: Column(
                    children: listChosen,
                  ),
                ),
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
          finaltempSize = finalSize;
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
