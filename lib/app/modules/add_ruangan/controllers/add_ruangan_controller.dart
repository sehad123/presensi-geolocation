import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AddRuanganController extends GetxController {
  final uuid = Uuid();

  TextEditingController nomorC = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addRuangan() async {
    try {
      if (nomorC.text.isNotEmpty) {
        // Check if the nomor already exists
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
            .collection("ruangan")
            .where("nomor", isEqualTo: nomorC.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Nomor already exists, show error dialog
          showErrorDialog("Peringatan", "Nomor ruangan sudah ada.");
        } else {
          // Nomor doesn't exist, proceed to add ruangan
          String uniqueId = uuid.v4();
          await firestore.collection("ruangan").doc(uniqueId).set({
            "uid": uniqueId,
            "nomor": nomorC.text,
            "status": "ada",
            "createdAt": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          Get.back();
          Get.back();
          showSuccessDialog("SUCCESS", "Berhasil menambahkan ruangan");
        }
      } else {
        // Nomor is empty, show error dialog
        showErrorDialog("Peringatan", "Nomor harus diisi.");
      }
    } catch (e) {
      print("$e");
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
