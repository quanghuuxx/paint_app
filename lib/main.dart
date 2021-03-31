import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_paint/controllers/paint_controller.dart';
import 'package:flutter_custom_paint/models/doc.dart';
import 'package:flutter_custom_paint/models/request_firebase.dart';
import 'package:flutter_custom_paint/screens/paint_page.dart';
import 'package:get/get.dart';

//* biến Global
int finalindex = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  //* chuyển màn hình ngang
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(Launch());
}

class Launch extends StatefulWidget {
  @override
  _LaunchState createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  @override
  void initState() {
    Timer(Duration(milliseconds: 1500), () async {
      Doc doc = await RequestFirebase.getDoc('TVTc0iskOtcx6lPknJBK');
      for (int i = 0; i < doc.page.length; i++) {
        Controller controller = Controller();
        controller.setfilePath(doc.page[i]["listfilepath"]);
        PaintPage.mylist.add(PaintingPage(controller, i));
        PaintPage.mylist.last.controller.setPath();
      }
      Get.to(PaintPage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: CircleAvatar(
          backgroundColor: Colors.blue,
          maxRadius: 32,
        ),
      ),
    );
  }
}
//     _onload() async {
//     // kiểm tra đăng nhập, nếu chưa đăng nhập thì hiển thị popup VAID
//     VAID.auth(
//       context: context,
//       appdata: {
//         'id': ConfigsVAWAY.appId,
//         'key': ConfigsVAWAY.key,
//         'secret': ConfigsVAWAY.secret
//       },
//       callback: (response) async {
//         if (response != null) {
//           if (response['success'] = true) {
//             SharedPerferencesFunction.setData(
//                 key: ConfigsVAWAY.keyUserInformation,
//                 value: json.encode(response['results']));
//             ConfigUser.token = response['results']['token'];
//             var profile = response['results']['profile'];
//             ConfigUser.userProfile = UserProfile.fromMap(profile);
//             _gotoHomePage();
//           }
//         }
//       },
//       enableClose: false,
//     );
//   }
// }
