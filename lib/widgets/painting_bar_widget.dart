import 'package:flutter/material.dart';

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
}
