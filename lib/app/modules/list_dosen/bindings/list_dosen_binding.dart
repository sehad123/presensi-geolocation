import 'package:get/get.dart';

import '../controllers/list_dosen_controller.dart';

class ListDosenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListDosenController>(
      () => ListDosenController(),
    );
  }
}
