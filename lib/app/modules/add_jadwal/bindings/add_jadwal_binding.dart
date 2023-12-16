import 'package:get/get.dart';

import '../controllers/add_jadwal_controller.dart';

class AddJadwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddJadwalController>(
      () => AddJadwalController(),
    );
  }
}
