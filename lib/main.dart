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
  static List<MyHomePage> mylist = [
    MyHomePage(Controller(), 0),
    // MyHomePage(Controller(), 1),
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(MyApp.mylist[0].controller, finalindex),
    );
  }
}
