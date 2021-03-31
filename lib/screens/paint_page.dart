import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_paint/controllers/paint_controller.dart';
import 'package:flutter_custom_paint/main.dart';
import 'package:flutter_custom_paint/models/doc.dart';
import 'package:flutter_custom_paint/models/request_firebase.dart';
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
    if (doc != null) {
      for (int i = 0; i < doc.page.length; ++i) {
        Controller controller = Controller();
        controller.setfilePath(doc.page[i]["listfilepath"]);
        PaintPage.mylist.add(PaintingPage(controller, i));
        PaintPage.mylist.last.controller.setPath();
      }
    } else {
      finalindex = 0;
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

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
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
                          controller: PaintPage.mylist[finalindex].controller);
                    },
                  ),
                ),
              ],
            ),
          ),
          //* nút chuyển trang
          buttonForward(height, width),
          buttonBackWard(height, width),
          //* nút quay lại trang chủ
          Container(
              height: Get.height * 0.1,
              width: Get.width * 0.05,
              margin: EdgeInsets.only(left: width * 0.015, top: height * 0.03),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.arrow_back,
                  size: 15,
                ),
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
          //* SỐ TRANG
          Container(
            margin: EdgeInsets.only(left: width * 0.5, top: height * 0.03),
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
              padding: EdgeInsets.all(5),
              width: width * 0.5,
              height: height * 0.1,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.9),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child:
                  Row(children: listColor() + listChooseingBar(width, height)),
            ),
          ),
        ],
      ),
    );
  }

  //* Menu kích cỡ nét viết
  dialogPenSizeChoose(double width, double height) {
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
                      _penItem(selectedColor, 2),
                      _penItem(selectedColor, 5),
                      _penItem(selectedColor, 7),
                      _penItem(selectedColor, 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  //* Menu 3 màu
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
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: PaintingBar(selectedColor).colorContainer(
          Colors.blue,
          () {
            selectedColor = Colors.blue;
            finalColor = selectedColor;
            setState(() {});
          },
        ),
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

  //* nút sang phải
  Widget buttonForward(height, width) {
    return index != PaintPage.mylist.length - 1
        ? Padding(
            padding: EdgeInsets.only(top: height * 0.4, left: width * 0.95),
            child: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  finalindex++;
                  index = finalindex;
                  controllerPaintPage.update();
                  setState(() {});
                }))
        : Container();
  }

  //* nút sang trái
  Widget buttonBackWard(height, width) {
    return index != 0
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
  }

  Widget _penItem(Color color, double size) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
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

  List<Widget> listChooseingBar(width, height) {
    return [
      Padding(padding: EdgeInsets.all(5)),
      //* button Xoá
      InkWell(
          onTap: () {
            PaintPage.mylist[finalindex].controller.paths.clear();
            PaintPage.mylist[finalindex].controller.filepath.clear();
            PaintPage.mylist[finalindex].controller.paintss.clear();
            controllerPaintPage.update();
            setState(() {});
          },
          child: Container(
            height: 30,
            width: 30,
            child: Image.asset(
              'assets/images/eraser.png',
              color: Colors.grey,
            ),
          )),
      Padding(padding: EdgeInsets.all(5)),
      //* button PenSize
      InkWell(
          onTap: () {
            dialogPenSizeChoose(width, height);
          },
          child: Container(
            height: 30,
            width: 30,
            child: Icon(Icons.border_color),
          )),
      //* button thêm trang mới
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
      //* button Save
      IconButton(
        icon: Icon(
          Icons.save,
          color: Colors.black,
        ),
        onPressed: addNew,
      ),
    ];
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

  @override
  void dispose() {
    super.dispose();
  }
}
