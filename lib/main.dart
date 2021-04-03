import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/configs/config_vaway.dart';
import 'package:flutter_custom_paint/models/user_profile.dart';
import 'package:flutter_custom_paint/screens/home_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaid/VAID.dart';

//* biến Global
int finalindex = 0;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(GetMaterialApp(
    home: Launch(),
  ));
}

class Launch extends StatefulWidget {
  @override
  _LaunchState createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    getUserProfile();
    Timer(Duration(milliseconds: 1500), () async {
      if (ConfigsVAWAY.token == null) {
        _onload();
      } else {
        _gotoHomePage();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      alignment: Alignment.center,
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        maxRadius: 32,
      ),
    );
  }

  _onload() async {
    // kiểm tra đăng nhập, nếu chưa đăng nhập thì hiển thị popup VAID
    VAID.auth(
      context: context,
      appdata: {
        'id': ConfigsVAWAY.appId,
        'key': ConfigsVAWAY.key,
        'secret': ConfigsVAWAY.secret
      },
      callback: (response) async {
        if (response != null) {
          if (response['success'] = true) {
            sharedPreferences.setString(
                ConfigsVAWAY.keyUserProfile, json.encode(response['results']));
            ConfigsVAWAY.token = response['results']['token'];
            print(ConfigsVAWAY.token);
            var profile = response['results']['profile'];
            print(profile);
            ConfigsVAWAY.userProfile = UserProfile.fromMap(profile);
            _gotoHomePage();
          }
        }
      },
      enableClose: false,
    );
  }

  void getUserProfile() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var _dataUser = sharedPreferences.getString(ConfigsVAWAY.keyUserProfile);
    if (_dataUser != null) {
      setState(() {
        var data = jsonDecode(_dataUser);
        //* khởi tạo thông tin ng dùng
        ConfigsVAWAY.token = data['token'];
        var profile = data['profile'];
        ConfigsVAWAY.userProfile = UserProfile.fromMap(profile);
      });
    }
    print(_dataUser);
  }

  void _gotoHomePage() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      // Navigator.pushAndRemoveUntil(
      //     currentContext,
      //     MaterialPageRoute(builder: (context) => HomePage(name: username)),
      //     (route) => false);
      Get.off(() => HomePage());
      timer?.cancel();
    });
  }
}
