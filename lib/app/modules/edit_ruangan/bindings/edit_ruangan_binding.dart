import 'package:get/get.dart';

import '../controllers/edit_ruangan_controller.dart';

class EditRuanganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditRuanganController>(
      () => EditRuanganController(),
    );
  }
}
