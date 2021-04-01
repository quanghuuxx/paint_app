import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/main.dart';
import 'package:flutter_custom_paint/screens/paint_page.dart';

class PaintingBar {
  Color selectedColor;

  PaintingBar(this.selectedColor);

  Widget colorContainer(Color color, Function() ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: selectedColor == color ? 20 : 15,
        width: selectedColor == color ? 20 : 15,
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
            border: selectedColor == color
                ? Border.all(color: color, width: 2)
                : null,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }

  static Widget butonRedo(Function() paintPageUpdate) {
    return IconButton(
        icon: Icon(
          Icons.redo,
          color: Colors.white,
        ),
        onPressed: () {
          PaintPage.mylist[finalindex].controller.reDo();
          paintPageUpdate();
        });
  }

  static Widget butonUndo(Function() paintPageUpdate) {
    return IconButton(
        padding: const EdgeInsets.all(0),
        icon: Icon(
          Icons.undo,
          color: Colors.white,
        ),
        onPressed: () {
          PaintPage.mylist[finalindex].controller.undo();
          paintPageUpdate();
        });
  }
}
