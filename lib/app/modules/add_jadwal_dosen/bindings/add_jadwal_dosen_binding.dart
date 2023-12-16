import 'package:get/get.dart';

import '../controllers/add_jadwal_dosen_controller.dart';

class AddJadwalDosenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddJadwalDosenController>(
      () => AddJadwalDosenController(),
    );
  }
}
