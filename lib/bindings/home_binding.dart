import 'package:get/get.dart';
import 'package:native_youtube_download_manager/controllers/home_controllers.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
