import 'package:get/get.dart';

import '../controllers/list_ruangan_controller.dart';

class ListRuanganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListRuanganController>(
      () => ListRuanganController(),
    );
  }
}
