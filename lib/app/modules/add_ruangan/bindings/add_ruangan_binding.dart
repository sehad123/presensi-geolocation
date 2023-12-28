import 'package:get/get.dart';

import '../controllers/add_ruangan_controller.dart';

class AddRuanganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddRuanganController>(
      () => AddRuanganController(),
    );
  }
}
