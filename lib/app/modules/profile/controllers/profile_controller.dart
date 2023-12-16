import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() {
    String uid = auth.currentUser!.uid;
    return firestore.collection("mahasiswa").doc(uid).snapshots();
  }

  void logout() async {
    // Menampilkan konfirmasi menggunakan Get.dialog
    Get.defaultDialog(
      title: "Konfirmasi Logout",
      content: Text("Apakah Anda yakin ingin logout?"),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back(); // Menutup dialog
        },
        child: Text("Batal"),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          await auth.signOut();
          Get.offAllNamed(Routes.LOGIN);
        },
        child: Text("Logout"),
      ),
    );
  }
}
