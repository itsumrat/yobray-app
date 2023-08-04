import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void errorToast(String string) {
  Fluttertoast.showToast(
      msg: string,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void successToast(String string) {
  Fluttertoast.showToast(
      msg: string,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
}

void myShowDialog() {
  Get.defaultDialog(
    radius: 5,
    backgroundColor: Color(0xffF9F9F9),
    onWillPop: () => Future.value(false),
    title: "",
    titleStyle: TextStyle(fontSize: 18),
    content: Container(child: CircularProgressIndicator()),
  );
  // Get.dialog(
  //   Container(
  //     height: 100,
  //     width: 100,
  //     child: Center(child: CircularProgressIndicator()),
  //   ),
  //   barrierDismissible: true,
  //   useRootNavigator: true,

  // );
}
