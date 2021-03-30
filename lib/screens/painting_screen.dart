import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_paint/controllers/paintController.dart';
import 'package:flutter_custom_paint/screens/paint_page.dart';
import 'package:flutter_custom_paint/widgets/mobile_canvas.dart';
import 'package:flutter_custom_paint/widgets/painting_bar_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_custom_paint/models/path.dart';
import '../main.dart';

class PaintingPage extends StatefulWidget {
  final Controller controller;
  final int index;
  @override
  PaintingPage(this.controller, this.index);
  @override
  _PaintingPageState createState() => _PaintingPageState(controller, index);
}

class _PaintingPageState extends State<PaintingPage> {
  Controller controller;
  int index;
  _PaintingPageState(this.controller, this.index);
  Color selectedColor;
  double strokeWidth;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  List<Widget> listColor() {
    return [
      PaintingBar(selectedColor).colorContainer(
        Colors.black,
        () {
          selectedColor = Colors.black;
          finalColor = selectedColor;
          setState(() {});
        },
      ),
      Padding(
        padding: EdgeInsets.all(5),
      ),
      PaintingBar(selectedColor).colorContainer(
        Colors.blue,
        () {
          selectedColor = Colors.blue;
          finalColor = selectedColor;
          setState(() {});
        },
      ),
      Padding(
        padding: EdgeInsets.all(5),
      ),
      PaintingBar(selectedColor).colorContainer(
        Colors.red,
        () {
          selectedColor = Colors.red;
          finalColor = selectedColor;
          setState(() {});
        },
      )
    ];
  }

  List<Widget> listChosingBar(width, height) {
    return [
      Padding(padding: EdgeInsets.all(5)),
      InkWell(
          onTap: () {},
          child: Container(
            height: 30,
            width: 30,
            child: Image.asset('assets/images/eraser.png'),
          )),
      Padding(padding: EdgeInsets.all(5)),
      InkWell(
          onTap: () {
            dialogPenchose(width, height);
          },
          child: Container(
            height: 30,
            width: 30,
            child: Image.asset('assets/images/pendr.png'),
          )),
      //* button +
      IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () {
            this.setState(() {
              PaintPage.mylist
                  .add(PaintingPage(Controller(), PaintPage.mylist.length - 1));
            });
          }),
      IconButton(
          icon: Icon(
            Icons.save,
            color: Colors.black,
          ),
          onPressed: () async {}),
    ];
  }

  Widget buttonBackward(height, width) {
    return index != PaintPage.mylist.length - 1 //* nút phải
        ? Padding(
            padding: EdgeInsets.only(top: height * 0.4, left: width * 0.95),
            child: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  finalindex++;
                  index = finalindex;
                  for (int i = 0;
                      i <
                          PaintPage.mylist[finalindex - 1].controller.filepath
                              .length;
                      i++) {
                    FilePath _filre =
                        PaintPage.mylist[finalindex - 1].controller.filepath[i];
                    PaintPage.mylist[finalindex].controller.paintss
                        .add(new Paint()
                          ..color = _filre.color
                          ..style = PaintingStyle.stroke
                          ..strokeJoin = StrokeJoin.round
                          ..strokeCap = StrokeCap.round
                          ..strokeWidth = _filre.strokeWidth);
                    Path path = Path();
                    path.lineTo(_filre.startPoint, _filre.endPoint);
                    PaintPage.mylist[finalindex].controller.paths.add(path);
                  }
                  controllerPaintPage.update();
                  setState(() {});
                }))
        : Container();
  }

  // cont.paintss.add(new Paint()
  //     ..color = Colors.black
  //     ..style = PaintingStyle.stroke
  //     ..strokeJoin = StrokeJoin.round
  //     ..strokeCap = StrokeCap.round
  //     ..strokeWidth = finalSize);
  //   //
  //   Path path = Path();
  //   path.lineTo(20, 50);
  //   cont.paths.add(path);
  //   //
  //   mylist.add(MyHomePage(cont, 2));

  Widget buttonForWard(height, width) {
    return index != 0 //* nút trái
        ? Padding(
            padding: EdgeInsets.only(top: height * 0.4, left: width * 0),
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  finalindex--;
                  index = finalindex;
                  controllerPaintPage.update();
                  setState(() {});
                }))
        : Container();
    //* Số Trang
  }

  final ControllerPaintPage controllerPaintPage =
      Get.put(ControllerPaintPage());
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //* Vùng dùng để vẽ
                Container(
                  width: width,
                  height: height,
                  child: GetBuilder<ControllerPaintPage>(
                    builder: (_) {
                      return CanvasPainting(
                          PaintPage.mylist[finalindex].controller);
                    },
                  ),
                ),
              ],
            ),
          ),
          //* nút chuyển trang mới
          buttonBackward(height, width),
          buttonForWard(height, width),
          Container(
            margin: EdgeInsets.only(left: width * 0.05, top: height * 0.05),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Text(
              '${(index + 1).toString()}/${PaintPage.mylist.length.toString()}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          //* thanh trên đầu
          Padding(
            padding: EdgeInsets.only(left: width * 0.65, top: height * 0.02),
            child: Container(
              width: width * 0.5,
              height: height * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Row(children: listColor() + listChosingBar(width, height)),
            ),
          ),
        ],
      ),
    );
  }

  //* Menu kích cỡ nét viết
  dialogPenchose(double width, double height) {
    showDialog(
        context: context,
        builder: (builder) {
          return Container(
            width: width * 0.9,
            child: Padding(
              padding:
                  EdgeInsets.only(left: width * 0.75, bottom: height * 0.5),
              child: Dialog(
                backgroundColor: Colors.white,
                child: Container(
                  height: height * 0.9,
                  width: width * 0.7,
                  color: Colors.white,
                  child: Column(
                    children: [
                      penitem(selectedColor, 2),
                      penitem(selectedColor, 5),
                      penitem(selectedColor, 7),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget penitem(Color color, double size) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          // strokeWidth = size;
          finalSize = size;
          Navigator.of(context).pop();
        },
        child: Container(
          height: 20,
          child: Center(
            child: Container(
              height: size,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
