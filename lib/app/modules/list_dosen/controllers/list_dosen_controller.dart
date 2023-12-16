import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi/app/routes/app_pages.dart';

class ListDosenController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late RxList<Map<String, dynamic>> mahasiswaList;
  late RxList<Map<String, dynamic>> filteredMahasiswa;
  late RxString searchKeyword;
  late RxBool isLoading;

  @override
  void onInit() {
    super.onInit();
    mahasiswaList = <Map<String, dynamic>>[].obs;
    filteredMahasiswa = <Map<String, dynamic>>[].obs;
    searchKeyword = ''.obs;
    isLoading = true.obs; // Set initial value to true
    fetchMahasiswa();
  }

  void fetchMahasiswa() async {
    try {
      // Set isLoading to true before fetching data
      isLoading.value = true;

      var querySnapshot = await firestore
          .collection("mahasiswa")
          .where('role', isEqualTo: 'dosen')
          .get();

      mahasiswaList.assignAll(querySnapshot.docs.map((doc) => doc.data()));
      filterMahasiswa(); // Call the filter method after fetching data
    } catch (e) {
      print("Error fetching dosen: $e");
    } finally {
      // Set isLoading to false after fetching data (success or error)
      isLoading.value = false;
    }
  }

  void filterMahasiswa() {
    if (searchKeyword.isEmpty) {
      filteredMahasiswa.assignAll(mahasiswaList);
    } else {
      filteredMahasiswa.assignAll(mahasiswaList
          .where((mahasiswa) => mahasiswa['name']
              .toLowerCase()
              .contains(searchKeyword.toLowerCase()))
          .toList());
    }
  }

  void searchMahasiswa(String keyword) {
    searchKeyword.value = keyword;
    filterMahasiswa();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser(String uid) {
    return firestore.collection("mahasiswa").doc(uid).snapshots();
  }

  Future<void> deleteUser(String uid) async {
    try {
      Get.defaultDialog(
        title: "Konfirmasi Hapus",
        content: Text("Apakah Anda yakin ingin hapus data dosen?"),
        cancel: ElevatedButton(
          onPressed: () {
            Get.back(); // Menutup dialog
          },
          child: Text("Batal"),
        ),
        confirm: ElevatedButton(
          onPressed: () async {
            await firestore.collection("mahasiswa").doc(uid).delete();
            Get.offAllNamed(Routes.PROFILE);
            Get.snackbar(
              "Berhasil",
              "Berhasil menghapus data dosen ",
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
