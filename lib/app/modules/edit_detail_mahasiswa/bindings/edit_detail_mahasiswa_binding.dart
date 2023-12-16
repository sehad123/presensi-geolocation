import 'package:get/get.dart';

import '../controllers/edit_detail_mahasiswa_controller.dart';

class EditDetailMahasiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditDetailMahasiswaController>(
      () => EditDetailMahasiswaController(),
    );
  }
}
