import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController passC = TextEditingController();
  TextEditingController newPassC = TextEditingController();
  TextEditingController confPassC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword() async {
    if (passC.text.isNotEmpty &&
        newPassC.text.isNotEmpty && // Ganti passC.text menjadi newPassC.text
        confPassC.text.isNotEmpty) {
      // Ganti passC.text menjadi confPassC.text
      if (newPassC.text == confPassC.text) {
        // Ganti confPassC menjadi confPassC.text
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          // Sign in menggunakan password lama
          await auth.signInWithEmailAndPassword(
              email: emailUser, password: passC.text);

          // Update password
          await auth.currentUser!.updatePassword(newPassC.text);

          // Sign out dan sign in kembali untuk me-refresh token
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: emailUser, password: newPassC.text);

          Get.back();
          showSuccessDialog("BERHASIL", "Update Password Berhasil");
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            showErrorDialog("ERROR", "Password lama anda salah");
          } else {
            showErrorDialog("ERROR", "${e.code.toLowerCase()}");
          }
        } catch (e) {
          showErrorDialog("ERROR", "Tidak dapat update password");
        } finally {
          isLoading.value = false;
        }
      } else {
        showErrorDialog("ERROR", "Confirm password tidak sama");
      }
    } else {
      showErrorDialog("ERROR", "Semua Input harus diisi");
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
