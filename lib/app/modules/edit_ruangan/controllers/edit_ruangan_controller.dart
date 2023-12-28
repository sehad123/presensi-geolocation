import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class EditRuanganController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nomorC = TextEditingController();
  final List<String> classes = [
    "ada",
    "Terpakai",
    "Booking",
  ];
  RxString selectedStatus = "".obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateRuangan(String uid) async {
    try {
      isLoading.value = true;
      Map<String, dynamic> data = {
        "status": selectedStatus.value,
      };
      await firestore.collection("ruangan").doc(uid).update(data);
      isLoading.value = false;
      Get.offAllNamed(Routes.PROFILE);
      showSuccessDialog("SUCCESS", "Ruangan berhasil diperbarui");
    } catch (e) {
      showErrorDialog('Error', 'Gagal memperbarui Ruangan.');
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
