import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditJadwalController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController dosenC = TextEditingController();
  TextEditingController JamMC = TextEditingController();
  TextEditingController menitMC = TextEditingController();
  TextEditingController JamKC = TextEditingController();
  TextEditingController menitKC = TextEditingController();

  TextEditingController ruanganC = TextEditingController();
  final List<String> classesKS = [
    "3SI3",
    "3SI1",
    "3SI2",
    "3SD1",
    "3SD2",
    "3SD3",
  ];
  final List<String> classesST = [
    "3SK3",
    "3SK1",
    "3SK2",
    "3SE1",
    "3SE2",
    "3SE3",
  ];
  final List<String> classesD3 = [
    "3D31",
    "3D32",
    "3D33",
    "3D34",
  ];
  final List<String> day = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
  ];
  RxString selectedDay = "".obs;
  RxString selectedKelas = "".obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateProfile(String uid) async {
    if (dosenC.text.isNotEmpty &&
        ruanganC.text.isNotEmpty &&
        JamMC.text.isNotEmpty &&
        JamKC.text.isNotEmpty &&
        menitMC.text.isNotEmpty &&
        menitKC.text.isNotEmpty &&
        selectedDay.value.isNotEmpty) {
      try {
        isLoading.value = true;
        Map<String, dynamic> data = {
          "hari": selectedDay.value,
          "kelas": selectedKelas.value,
          "jam_mulai": JamMC.text,
          "menit_mulai": menitMC.text,
          "jam_akhir": JamKC.text,
          "menit_akhir": menitKC.text,
          "ruangan": ruanganC.text,
          "dosen": dosenC.text,
        };

        // Update data mahasiswa
        await firestore.collection("jadwal").doc(uid).update(data);

        isLoading.value = false;

        // Get.(Routes.LIST_MAHASISWA);
        Get.back();
        Get.back();
        showSuccessDialog("SUCCESS", "Jadwal berhasil diperbarui");
      } catch (e) {
        showErrorDialog('Error', 'Gagal memperbarui Jadwal.');
      } finally {
        isLoading.value = false;
      }
    } else {
      showErrorDialog('Error', 'Nama tidak boleh kosong');
    }
  }

  void showErrorDialog(String title, String desc) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.error,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }

  void showSuccessDialog(String title, String desc) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.success,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }
}
