import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class EditDetailDosenController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nameC = TextEditingController();
  final List<String> classes = [
    "Data mining",
    "Interaksi Manusia dan Komputer",
    "Sistem Jaringan",
    "Official Statistik",
    "Big Data",
    "Machine Learning",
  ];
  RxString selectedKelas = "".obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateProfile(String uid) async {
    if (nameC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        Map<String, dynamic> data = {
          "name": nameC.text,
          "matkul": selectedKelas.value,
        };

        // Update data dosen
        await firestore.collection("mahasiswa").doc(uid).update(data);

        isLoading.value = false;

        // Get.(Routes.LIST_dosen);
        // Get.back();
        Get.offAllNamed(Routes.PROFILE);

        showSuccessDialog("SUCCESS", "Profile berhasil diperbarui");
      } catch (e) {
        showErrorDialog('Error', 'Gagal memperbarui profile.');
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
