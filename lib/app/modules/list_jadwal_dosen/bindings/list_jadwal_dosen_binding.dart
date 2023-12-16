import 'package:get/get.dart';

import '../controllers/list_jadwal_dosen_controller.dart';

class ListJadwalDosenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListJadwalDosenController>(
      () => ListJadwalDosenController(),
    );
  }
}
