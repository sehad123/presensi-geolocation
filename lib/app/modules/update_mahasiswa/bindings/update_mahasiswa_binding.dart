import 'package:get/get.dart';

import '../controllers/update_mahasiswa_controller.dart';

class UpdateMahasiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateMahasiswaController>(
      () => UpdateMahasiswaController(),
    );
  }
}
