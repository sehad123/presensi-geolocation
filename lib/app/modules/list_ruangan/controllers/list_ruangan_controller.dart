import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListRuanganController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  RxList<Map<String, dynamic>> ruanganList = <Map<String, dynamic>>[].obs;
  RxString selectedStatus = 'Semua'.obs; // Default status yang dipilih

  @override
  void onInit() {
    super.onInit();
    // Panggil method untuk mengambil data ruangan saat controller diinisialisasi
    getRuanganList();
  }

  Future<void> getRuanganList() async {
    try {
      // Hapus data sebelumnya dari daftar ruangan
      ruanganList.clear();

      // Ambil data ruangan dari Firestore berdasarkan status
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      if (selectedStatus.value == 'Semua') {
        querySnapshot = await firestore.collection("ruangan").get();
      } else {
        querySnapshot = await firestore
            .collection("ruangan")
            .where("status", isEqualTo: selectedStatus.value)
            .get();
      }

      // Tambahkan data ruangan ke daftar
      ruanganList.addAll(querySnapshot.docs.map((doc) => doc.data()));

      // Update UI
      update();
    } catch (e) {
      print("$e");
    }
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    getRuanganList();
  }

  Future<void> deleteRuangan(String uid) async {
    try {
      // Hapus ruangan berdasarkan UID
      await firestore.collection("ruangan").doc(uid).delete();

      // Perbarui daftar ruangan setelah penghapusan
      await getRuanganList();

      // Tampilkan dialog sukses
      showSuccessDialog("SUCCESS", "Berhasil menghapus ruangan");
    } catch (e) {
      print("$e");
      // Tampilkan dialog error
      showErrorDialog("Error", "Gagal menghapus ruangan");
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
