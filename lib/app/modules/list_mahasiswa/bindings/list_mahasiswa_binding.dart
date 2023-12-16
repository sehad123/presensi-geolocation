import 'package:get/get.dart';

import '../controllers/list_mahasiswa_controller.dart';

class ListMahasiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListMahasiswaController>(
      () => ListMahasiswaController(),
    );
  }
}
