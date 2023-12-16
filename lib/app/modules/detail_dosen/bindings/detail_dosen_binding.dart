import 'package:get/get.dart';

import '../controllers/detail_dosen_controller.dart';

class DetailDosenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailDosenController>(
      () => DetailDosenController(),
    );
  }
}
