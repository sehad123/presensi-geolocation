import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateMahasiswaController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController statusMC = TextEditingController();
  TextEditingController statusKC = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateMasukStatus(String uid, String todayDocId) async {
    try {
      isLoading.value = true;

      CollectionReference<Map<String, dynamic>> collectionReference =
          firestore.collection("mahasiswa").doc(uid).collection("presensi");

      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await collectionReference.doc(todayDocId).get();

      if (todayDoc.exists) {
        await collectionReference.doc(todayDocId).update({
          "masuk.status": statusMC.text,
        });

        Get.back();
        showSuccessDialog("BERHASIL", "Berhasil ubah status kehadiran masuk");
      } else {
        showErrorDialog("Error", "Dokumen hari ini tidak ditemukan");
      }
    } catch (e) {
      showErrorDialog("Gagal", "Gagal ubah status kehadiran masuk: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateKeluarStatus(String uid, String todayDocId) async {
    try {
      isLoading.value = true;

      CollectionReference<Map<String, dynamic>> collectionReference =
          firestore.collection("mahasiswa").doc(uid).collection("presensi");

      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await collectionReference.doc(todayDocId).get();

      if (todayDoc.exists) {
        await collectionReference.doc(todayDocId).update({
          "keluar.status": statusKC.text,
        });

        Get.back();
        showSuccessDialog("BERHASIL", "Berhasil ubah status kehadiran keluar");
      } else {
        showErrorDialog("Error", "Dokumen hari ini tidak ditemukan");
      }
    } catch (e) {
      showErrorDialog("Gagal", "Gagal ubah status kehadiran keluar: $e");
    } finally {
      isLoading.value = false;
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
      btnOkOnPress: () {
        Get.back(
            result: true); // Use Get.back with result true to trigger refresh
      },
    ).show();
  }
}
