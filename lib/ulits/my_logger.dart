import 'package:get/get.dart';

void localLogWriter(String text, {bool isError = false}) {
  if (Get.isLogEnable) print(text.toString());
}
