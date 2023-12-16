import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class UpdateMahasiswaController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController statusMC = TextEditingController();
  TextEditingController statusKC = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateMasukStatus(
    String uid,
    String todayDocId,
  ) async {
    showErrorDialog(
        "Updating masuk status for UID: $uid, Date: $todayDocId", "");

    CollectionReference<Map<String, dynamic>> collectionReference =
        await firestore.collection("mahasiswa").doc(uid).collection("presensi");

    await collectionReference.doc(todayDocId).update({
      "masuk.status": statusMC.text,
    });

    Get.back();
    showSuccessDialog("BERHASIL", "Berhasil ubah status kehadiran");
  }

  Future<void> updateKeluarStatus(
    String uid,
    String todayDocId,
  ) async {
    showErrorDialog(
        "Updating masuk status for UID: $uid, Date: $todayDocId", "");
    CollectionReference<Map<String, dynamic>> collectionReference =
        await firestore.collection("mahasiswa").doc(uid).collection("presensi");
    print("Uid = ${uid}");
    print("todau = ${todayDocId}");
    await collectionReference.doc(todayDocId).update({
      "keluar.status": statusKC.text,
    });
    print("Uid = ${uid}");
    print("todau = ${todayDocId}");

    Get.back();
    showSuccessDialog("BERHASIL", "Berhasil ubah status kehadiran");
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
