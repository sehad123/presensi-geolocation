import 'package:get/get.dart';

import '../controllers/edit_detail_dosen_controller.dart';

class EditDetailDosenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditDetailDosenController>(
      () => EditDetailDosenController(),
    );
  }
}
