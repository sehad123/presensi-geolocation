import 'package:get/get.dart';

import '../controllers/list_jadwal_controller.dart';

class ListJadwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListJadwalController>(
      () => ListJadwalController(),
    );
  }
}
