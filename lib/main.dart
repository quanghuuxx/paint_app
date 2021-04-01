import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/configs/config_theme.dart';
import 'package:flutter_custom_paint/screens/home_page.dart';
import 'package:get/get.dart';

//* biến Global
int finalindex = 0;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
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
      Get.off(HomePage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: ConfigTheme.backgroundColor,
        appBarTheme: AppBarTheme(
            color: ConfigTheme.primaryColor,
            centerTitle: true,
            elevation: 0,
            textTheme: ThemeData.light().textTheme.copyWith(
                headline6:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.w500))),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
