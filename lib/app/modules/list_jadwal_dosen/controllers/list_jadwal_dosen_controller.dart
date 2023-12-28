import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListJadwalDosenController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late RxList<Map<String, dynamic>> jadwalList;
  late RxList<Map<String, dynamic>> filteredJadwal;
  late RxString searchKeyword;
  late RxBool isLoading;
  late RxString selectedDay; // Add this line

  @override
  void onInit() {
    super.onInit();
    jadwalList = <Map<String, dynamic>>[].obs;
    filteredJadwal = <Map<String, dynamic>>[].obs;
    searchKeyword = ''.obs;
    selectedDay = ''.obs;
    isLoading = true.obs; // Set initial value to true

    selectedDay = 'hari'.obs; // Set default value
    fetchJadwal();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() {
    String uid = auth.currentUser!.uid;
    return firestore.collection("mahasiswa").doc(uid).snapshots();
  }

  void fetchJadwal() async {
    try {
      isLoading.value = true;
      isLoading.value = true;
      String uid = auth.currentUser!.uid;

      // Ambil dokumen pengguna
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await firestore.collection("mahasiswa").doc(uid).get();

      // Ambil prodi dari dokumen pengguna
      String nama = userDoc.data()?['name'] ?? '';
      String roles = userDoc.data()?['role'] ?? '';

      // Query jadwal berdasarkan role, nama, dll.
      if (roles == 'admin') {
        var querySnapshot = await firestore
            .collection("jadwal")
            .where('role', isEqualTo: 'dosen')
            .get();

        jadwalList.assignAll(querySnapshot.docs.map((doc) => doc.data()));
        filterJadwalByDay(selectedDay.value); // Filter initially
      } else {
        var querySnapshot = await firestore
            .collection("jadwal")
            .where('role', isEqualTo: 'dosen')
            .where('dosen', isEqualTo: nama)
            .get();

        jadwalList.assignAll(querySnapshot.docs.map((doc) => doc.data()));
        filterJadwalByDay(selectedDay.value); // Filter initially
      }
    } catch (e) {
      print("Error fetching jadwal: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterJadwal() {
    filteredJadwal.assignAll(jadwalList);

    // Filter by matkul
    if (searchKeyword.isNotEmpty) {
      filteredJadwal.assignAll(filteredJadwal
          .where((jadwal) => jadwal['matkul']
              .toLowerCase()
              .contains(searchKeyword.toLowerCase()))
          .toList());
    }

    // Filter by day
    if (selectedDay.isNotEmpty) {
      filteredJadwal.assignAll(filteredJadwal
          .where((jadwal) =>
              jadwal['hari'].toLowerCase() == selectedDay.toLowerCase())
          .toList());
    }
  }

  void filterJadwalByDay(String day) {
    if (day == 'hari' || day == 'Semua') {
      filteredJadwal.assignAll(jadwalList);
    } else {
      filteredJadwal.assignAll(
          jadwalList.where((mahasiswa) => mahasiswa['hari'] == day).toList());
    }
  }

  void searchJadwal(String keyword) {
    searchKeyword.value = keyword;
    filterJadwal();
  }

  Future<void> deleteJadwal(String uid) async {
    try {
      Get.defaultDialog(
        title: "Konfirmasi Hapus",
        content: Text("Apakah Anda yakin ingin hapus data jadwal ini?"),
        cancel: ElevatedButton(
          onPressed: () {
            Get.back(); // Menutup dialog
          },
          child: Text("Batal"),
        ),
        confirm: ElevatedButton(
          onPressed: () async {
            await firestore.collection("jadwal").doc(uid).delete();
            // Get.offAllNamed(Routes.LIST_MAHASISWA);
            Get.back();
            Get.back();
            Get.back();
            Get.snackbar(
              "Berhasil",
              "Berhasil menghapus data Jadwal ",
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
