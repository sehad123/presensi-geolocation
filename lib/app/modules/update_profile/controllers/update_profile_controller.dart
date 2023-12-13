import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nimC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  final List<String> classes = [
    "D4 Statistika",
    "D4 Komputasi Statistik",
    "D3 Statistik"
  ];
  RxString selectedKelas = "".obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  XFile? image;

  void pickImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // proses upload image
    } else {}
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nameC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        Map<String, dynamic> data = {
          "name": nameC.text,
        };
        if (image != null) {
          //  proses upload image ke firebase
          File file = File(image!.path);
          String ext = image!.name.split(".").last;
          await storage.ref('$uid/profile.$ext').putFile(file);
          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();

          data.addAll({"profile": urlImage});
        }
        // Update data mahasiswa
        await firestore.collection("mahasiswa").doc(uid).update(data);
        image = null;

        Get.snackbar(
          "Sukses",
          "Profil berhasil diperbarui",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isLoading.value = false;

        Get.offAllNamed(Routes.PROFILE);
      } catch (e) {
        Get.snackbar(
          "Error",
          "Gagal memperbarui profil. Silakan coba lagi.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        "Peringatan",
        "Nama tidak boleh kosong",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void deleteProfile(String uid) async {
    try {
      firestore
          .collection("mahasiswa")
          .doc(uid)
          .update({"profile": FieldValue.delete()});
      update();
      // notifikasi
      Get.back();
      Get.snackbar(
        "Sukses",
        "Profil berhasil dihapus",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // notifikasi
      Get.snackbar(
        "Peringatan",
        "Tidak dapat delet profile",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } finally {
      update();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() {
    String uid = auth.currentUser!.uid;
    return firestore.collection("mahasiswa").doc(uid).snapshots();
  }
}
