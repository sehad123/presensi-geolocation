import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
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
  TextEditingController nimC = TextEditingController();

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
    if (nimC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        Map<String, dynamic> data = {
          "no hp": nimC.text,
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

        isLoading.value = false;

        Get.offAllNamed(Routes.PROFILE);
        showSuccessDialog("SUCESS", "profile berhasil diperbarui");
      } catch (e) {
        showErrorDialog('Error', 'gagal memperbarui profile.');
      } finally {
        isLoading.value = false;
      }
    } else {
      showErrorDialog('Error', 'nama tidak boleh kosong');
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
      showSuccessDialog("SUCCES", "Profile berhasil di hapus");
    } catch (e) {
      // notifikasi
      showErrorDialog('Error', 'tidak dapat delete profile.');
    } finally {
      update();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() {
    String uid = auth.currentUser!.uid;
    return firestore.collection("mahasiswa").doc(uid).snapshots();
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
