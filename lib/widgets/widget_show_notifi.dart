import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/configs/config_theme.dart';
import 'package:get/get.dart';

class ShowNotifi {
  static bool _isShow = false;
  static void showToast({@required String title}) {
    if (!_isShow) {
      _isShow = true;
      Get.snackbar(null, title ?? 'không có nội dung !',
          colorText: Colors.white,
          backgroundColor: ConfigTheme.primaryColor,
          borderRadius: 4,
          duration: Duration(seconds: 1),
          forwardAnimationCurve: Curves.ease,
          reverseAnimationCurve: Curves.ease,
          margin: EdgeInsets.only(
              bottom: Get.height * 0.1,
              left: Get.width * 0.05,
              right: Get.width * 0.05),
          snackPosition: SnackPosition.BOTTOM, snackbarStatus: (status) {
        if (status.index == 1) {
          _isShow = false;
        }
      });
    }
  }
}
