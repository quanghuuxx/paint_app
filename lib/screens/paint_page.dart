import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/controllers/paint_controller.dart';
import 'package:flutter_custom_paint/main.dart';
import 'package:flutter_custom_paint/models/request_firebase.dart';
import 'package:flutter_custom_paint/widgets/eraser_widget.dart';
import 'package:flutter_custom_paint/widgets/mobile_canvas.dart';
import 'package:flutter_custom_paint/widgets/painting_bar_widget.dart';
import 'package:get/get.dart';

class PaintPage extends StatelessWidget {
  //* list các trang trong 1 doc
  static List<PaintingPage> mylist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // GetBuilder<ControllerPaintPage>(
          //   init: ControllerPaintPage(),
          //   initState: (_) {},
          //   builder: (_) {
          mylist[finalindex] ?? PaintingPage(Controller(), 0),
      // },
      // ),
    );
  }
}

//* các trang
class PaintingPage extends StatefulWidget {
  final Controller controller;
  final int index;

  @override
  PaintingPage(this.controller, this.index);

  @override
  _PaintingPageState createState() => _PaintingPageState(index);
}

class _PaintingPageState extends State<PaintingPage> {
  int index;
  _PaintingPageState(this.index);
  Color selectedColor;
  double strokeWidth;
  bool showMore = false;
  double leftPadding = 0.65;
  final GlobalKey<CanvasPaintingState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  List<Widget> listColor() {
    return [
      PaintingBar.butonUndo(() {
        _key.currentState.update();
      }),
      PaintingBar.butonRedo(() {
        _key.currentState.update();
        //controllerPaintPage.update();
      }),
      PaintingBar(selectedColor).colorContainer(
        Colors.black,
        () {
          selectedColor = Colors.black;
          finalColor = selectedColor;
          finalSize = EraserWidget.finaltempSize;
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
          finalSize = EraserWidget.finaltempSize;
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
          finalSize = EraserWidget.finaltempSize;
          setState(() {});
        },
      )
    ];
  }

  ///container animate
  Widget animatedContainer(
      bool condition, firstchild, secondchild, durationSecond) {
    return AnimatedCrossFade(
        firstCurve: Curves.easeInToLinear,
        secondCurve: Curves.easeInToLinear,
        duration: Duration(seconds: durationSecond),
        crossFadeState:
            condition ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: firstchild,
        secondChild: secondchild);
  }

  Widget menuRow() {
    return Row(
      children: [
        IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              showMore = !showMore;
              leftPadding = 0.65;
              setState(() {});
            }),
        // Padding(padding: EdgeInsets.all(5)),
        InkWell(
            onTap: () {
              dialogPenchose(context.width, context.height);
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
                PaintPage.mylist.add(
                    PaintingPage(Controller(), PaintPage.mylist.length - 1));
              });
            }),
        IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.black,
            ),
            onPressed: () async {
              Map<String, dynamic> map = Controller().setMap();
              RequestFirebase.addDoc(map);
            }),
      ],
    );
  }

  List<Widget> listChosingBar(width, height) {
    return [
      //* button Xoá
      InkWell(
          onTap: () {
            EraserWidget.eraserDialog(context, width, height, () {
              _key.currentState.update();
              //setState(() {});
            });
          },
          child: Container(
            height: 30,
            width: 30,
            child: Image.asset('assets/images/eraser.png'),
          )),
      animatedContainer(
          showMore,
          IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                showMore = !showMore;
                leftPadding = 0.5;
                setState(() {});
              }),
          Container(
            child: menuRow(),
          ),
          1)
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
                  _key.currentState.update();
                  setState(() {});
                }))
        : Container();
  }

  Widget buttonForWard(height, width) {
    return index != 0 //* nút trái
        ? Padding(
            padding: EdgeInsets.only(top: height * 0.4, left: width * 0),
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  finalindex--;
                  index = finalindex;
                  _key.currentState.update();
                  setState(() {});
                }))
        : Container();
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
                            key: _key,
                            controller:
                                PaintPage.mylist[finalindex].controller);
                      },
                    )),
              ],
            ),
          ),
          //* nút chuyển trang mới
          buttonBackward(height, width),
          buttonForWard(height, width),
          //* SỐ TRANG
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
            padding:
                EdgeInsets.only(left: width * leftPadding, top: height * 0.02),
            child: Container(
              width: width * 0.5,
              height: height * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Row(
                children: listColor() + listChosingBar(width, height),
              ),
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

  dialogEraser(width, height) {
    showDialog(
        context: context,
        builder: (builder) {
          return Container(
            width: width * 0.9,
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.7, bottom: height * 0.5),
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
}
