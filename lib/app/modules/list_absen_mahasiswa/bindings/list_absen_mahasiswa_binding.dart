import 'package:get/get.dart';

import '../controllers/list_absen_mahasiswa_controller.dart';

class ListAbsenMahasiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListAbsenMahasiswaController>(
      () => ListAbsenMahasiswaController(),
    );
  }
}
