import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class EditDetailMahasiswaController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nameC = TextEditingController();
  final List<String> classesKS = [
    "3SI3",
    "3SI1",
    "3SI2",
    "3SD1",
    "3SD2",
    "3SD3",
    "4SI3",
    "4SI1",
    "4SI2",
    "4SD1",
    "4SD2",
    "4SD3",
  ];
  final List<String> classesST = [
    "3SK3",
    "3SK1",
    "3SK2",
    "3SE1",
    "3SE2",
    "3SE3",
    "4SK3",
    "4SK1",
    "4SK2",
    "4SE1",
    "4SE2",
    "4SE3",
  ];
  final List<String> classesD3 = [
    "3D31",
    "3D32",
    "3D33",
    "3D34",
  ];
  RxString selectedKelas = "".obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateProfile(String uid) async {
    if (nameC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        Map<String, dynamic> data = {
          "name": nameC.text,
          "kelas": selectedKelas.value,
        };

        // Update data mahasiswa
        await firestore.collection("mahasiswa").doc(uid).update(data);

        isLoading.value = false;

        // Get.(Routes.LIST_MAHASISWA);
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
