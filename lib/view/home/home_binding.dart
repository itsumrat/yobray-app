import 'package:get/get.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<HomeController>(() => HomeController());
    Get.put<HomeController>(HomeController());
  }
}
