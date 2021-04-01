import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_paint/configs/config_theme.dart';
import 'package:flutter_custom_paint/controllers/paint_controller.dart';
import 'package:flutter_custom_paint/main.dart';
import 'package:flutter_custom_paint/models/doc.dart';
import 'package:flutter_custom_paint/models/request_firebase.dart';
import 'package:flutter_custom_paint/widgets/eraser_widget.dart';
import 'package:flutter_custom_paint/widgets/mobile_canvas.dart';
import 'package:flutter_custom_paint/widgets/painting_bar_widget.dart';
import 'package:flutter_custom_paint/widgets/widget_show_notifi.dart';
import 'package:get/get.dart';

class PaintPage extends StatelessWidget {
  //* list các trang trong 1 doc
  static List<PaintingPage> mylist = [];
  static Doc doc;

  void initMylist() {
    PaintPage.mylist.clear();
    finalindex = 0;
    if (doc != null) {
      for (int i = 0; i < doc.page.length; ++i) {
        Controller controller = Controller();
        controller.setfilePath(doc.page[i]["listfilepath"]);
        PaintPage.mylist.add(PaintingPage(controller, i));
        PaintPage.mylist.last.controller.setPath();
      }
    } else {
      mylist = [PaintingPage(Controller(), 0)];
    }
  }

  @override
  Widget build(BuildContext context) {
    initMylist();
    SystemChrome.setEnabledSystemUIOverlays([]); //* ẩn navibar và noticationbar
    SystemChrome.setPreferredOrientations([
      //* chuyển màn hình ngang
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
      body: mylist[finalindex] ?? PaintingPage(Controller(), 0),
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
  double rightPadding = 0.60;
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
      }),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: PaintingBar(selectedColor).colorContainer(
          Colors.black,
          () {
            selectedColor = Colors.black;
            finalColor = selectedColor;
            finalSize = EraserWidget.finaltempSize;
            EraserWidget.isErasrering = false;
            setState(() {});
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: PaintingBar(selectedColor).colorContainer(
          Colors.blue,
          () {
            selectedColor = Colors.blue;
            finalColor = selectedColor;
            finalSize = EraserWidget.finaltempSize;
            EraserWidget.isErasrering = false;
            setState(() {});
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: PaintingBar(selectedColor).colorContainer(
          Colors.red,
          () {
            selectedColor = Colors.red;
            finalColor = selectedColor;
            finalSize = EraserWidget.finaltempSize;
            EraserWidget.isErasrering = false;
            setState(() {});
          },
        ),
      )
    ];
  }

  Widget menuRow() {
    return Row(
      children: [
        //* button pen
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
              onTap: () {
                dialogPenchose(context.width, context.height);
              },
              child: Container(
                height: 30,
                width: 30,
                child: Icon(
                  Icons.border_color,
                  size: 20,
                  color: Colors.white,
                ),
              )),
        ),
        //* button +
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onTap: () {
                this.setState(() {
                  PaintPage.mylist.add(
                      PaintingPage(Controller(), PaintPage.mylist.length - 1));
                });
              }),
        ),
        //* button lưu
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
              child: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onTap: addNew),
        ),
      ],
    );
  }

  void addNew() async {
    bool response;
    if (PaintPage.doc != null) {
      Map<String, dynamic> map = Controller()
          .setMap(name: PaintPage.doc.name, token: PaintPage.doc.token);
      response = await RequestFirebase.updateDoc(PaintPage.doc.id, map);
      print(PaintPage.doc.id);
    } else {
      GlobalKey<FormState> formkey = GlobalKey<FormState>();
      final controllerText = TextEditingController();
      String name = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Nhập tên :"),
          content: Form(
            key: formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controllerText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Chưa nhập nội dung !';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState.validate()) {
                          Navigator.of(context).pop(controllerText.text);
                        }
                      },
                      child: Text("Lưu"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: Text("Hủy Bỏ"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
      if (name != null || name.isEmpty) {
        Map<String, dynamic> map =
            Controller().setMap(name: name, token: "token");
        response = await RequestFirebase.addDoc(map);
      }
    }
    ShowNotifi.showToast(
        title: response == true
            ? "Lưu Thành Công !"
            : "Thất Bại ! Có Lỗi Gì Đó !");
  }

  List<Widget> listChosingBar(width, height) {
    return [
      //* button Xoá
      InkWell(
        onTap: () async {
          EraserWidget.eraserDialog(context, width, height, () {
            _key.currentState.update();
          });
        },
        child: Container(
          height: 28,
          width: 28,
          child: Image.asset(
            'assets/images/eraser.png',
            color: Colors.white,
          ),
        ),
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
        width: showMore ? 120 : 0,
        child: showMore ? menuRow() : Container(),
      ),
      //* button menu
      IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            showMore = !showMore;
            if (showMore)
              rightPadding = 0.51;
            else
              rightPadding = 0.60;
            setState(() {});
          }),
      IconButton(
          icon: Icon(Icons.ac_unit),
          onPressed: () async {
            print(await PathPainter.takePic(Size(width, height)));
            Image img = Image.memory(await PathPainter.takePic(Size(500, 800)));
            showDialog(
                context: context,
                child: Dialog(
                  child: img,
                ));
          }),
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

          //* button back
          Container(
              height: Get.height * 0.1,
              width: Get.width * 0.05,
              margin: EdgeInsets.only(left: width * 0.015, top: height * 0.03),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.arrow_back, size: 15, color: Colors.white),
                onPressed: () {
                  SystemChrome.setEnabledSystemUIOverlays(
                      [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                  Get.back();
                },
              )),
          //* nút chuyển trang mới
          buttonBackward(height, width),
          buttonForWard(height, width),
          //* SỐ TRANG
          Container(
            margin: EdgeInsets.only(left: width * 0.015, top: height * 0.9),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Text(
              '${(index + 1).toString()}/${PaintPage.mylist.length.toString()}',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          //* thanh trên đầu
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            margin: EdgeInsets.only(
                left: width * rightPadding,
                top: height * 0.02,
                right: width * 0.01),
            height: height * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: ConfigTheme.primaryColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: listColor() + listChosingBar(width, height),
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

  @override
  void dispose() {
    EraserWidget.isErasrering = false;
    finalColor = Colors.black;
    finalSize = 2;
    super.dispose();
  }
}
