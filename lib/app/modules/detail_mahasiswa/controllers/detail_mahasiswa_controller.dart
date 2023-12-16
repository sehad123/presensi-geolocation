import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presensi/app/routes/app_pages.dart';

class DetailMahasiswaController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser(String uid) {
    return firestore.collection("mahasiswa").doc(uid).snapshots();
  }

  Future<void> deleteUser(String uid) async {
    try {
      Get.defaultDialog(
        title: "Konfirmasi Hapus",
        content: Text("Apakah Anda yakin ingin hapus data mahasiswa?"),
        cancel: ElevatedButton(
          onPressed: () {
            Get.back(); // Menutup dialog
          },
          child: Text("Batal"),
        ),
        confirm: ElevatedButton(
          onPressed: () async {
            await firestore.collection("mahasiswa").doc(uid).delete();
            // Get.offAllNamed(Routes.LIST_MAHASISWA);
            Get.back();
            Get.back();
            Get.back();
            Get.snackbar(
              "Berhasil",
              "Berhasil menghapus data mahasiswa ",
              snackPosition: SnackPosition.TOP,
            );
          },
          child: Text("Ya"),
        ),
      );

      // You can also show a success message or navigate to another screen
    } catch (error) {
      Get.snackbar(
        "Error",
        "Failed to delete user: $error",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
