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
        icon: Icon(Icons.redo),
        onPressed: () {
          //lưu thông tin đã xóa để khôi phục
          if (PaintPage.mylist[finalindex].controller.paintss.length > 0) {
            PaintPage.mylist[finalindex].controller.removedPaths
                .add(PaintPage.mylist[finalindex].controller.paths.last);
            PaintPage.mylist[finalindex].controller.removedPaints
                .add(PaintPage.mylist[finalindex].controller.paintss.last);
            PaintPage.mylist[finalindex].controller.removedFilePaths
                .add(PaintPage.mylist[finalindex].controller.filepath.last);
            //xóa
            PaintPage.mylist[finalindex].controller.paintss.removeLast();
            PaintPage.mylist[finalindex].controller.paths.removeLast();
            PaintPage.mylist[finalindex].controller.filepath.removeLast();
            paintPageUpdate();
          }
        });
  }

  static Widget butonUndo(Function() paintPageUpdate) {
    return IconButton(
        icon: Icon(Icons.undo),
        onPressed: () {
          if (PaintPage.mylist[finalindex].controller.removedPaths.length > 0) {
            //khôi phục xóa từ thùng rác
            PaintPage.mylist[finalindex].controller.paintss.add(
                PaintPage.mylist[finalindex].controller.removedPaints.last);
            PaintPage.mylist[finalindex].controller.paths
                .add(PaintPage.mylist[finalindex].controller.removedPaths.last);
            PaintPage.mylist[finalindex].controller.filepath.add(
                PaintPage.mylist[finalindex].controller.removedFilePaths.last);
            //xóa trong mảng thùng rác
            PaintPage.mylist[finalindex].controller.removedPaints.removeLast();
            PaintPage.mylist[finalindex].controller.removedPaths.removeLast();
            PaintPage.mylist[finalindex].controller.removedFilePaths
                .removeLast();
            paintPageUpdate();
            print(PaintPage.mylist[finalindex].controller.paths.length);
          }
        });
  }
}
