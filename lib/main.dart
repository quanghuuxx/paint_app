import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_paint/configs/config_vaway.dart';
import 'package:flutter_custom_paint/screens/paint_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
  runApp(Launch());
}

class Launch extends StatefulWidget {
  @override
  _LaunchState createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  @override
  void initState() {
    Timer(Duration(milliseconds: 1500), () => Get.off(PaintPage()));
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
