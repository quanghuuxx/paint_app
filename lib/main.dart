import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/paintController.dart';
import 'screens/painting_screen.dart';

//* biến Global
int finalindex = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //* chuyển màn hình ngang
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static List<PaintingPage> mylist = [
    PaintingPage(Controller(), 0),
    PaintingPage(Controller(), 1),
  ];

  // List<PaintingPage> initList() {
  //   List<PaintingPage> _list;
  //   for (var i = 0; i < 2; i++) {
  //     Controller _controller = Controller();
  //     for (var i = 0; i < lenthPath; i++) {
  //       Path _path = new Path();
  //       _path.lineTo(pathx[i],pathx[i][0] )
  //       _controller.paths.add(_path);

  //     }
  //     _list.add(PaintingPage() , i)
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaintingPage(MyApp.mylist[0].controller, finalindex),
    );
  }
}

// cont.paintss.add(new Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.stroke
//       ..strokeJoin = StrokeJoin.round
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = finalSize);
//     //
//     Path path = Path();
//     path.lineTo(20, 50);
//     cont.paths.add(path);
