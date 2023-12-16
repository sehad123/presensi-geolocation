import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController passC = TextEditingController();
  TextEditingController nimC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential credential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);
        print(credential);

        if (credential.user != null) {
          isLoading.value = false;

          if (credential.user!.emailVerified == true) {
            Get.toNamed(Routes.HOME);
          } else {
            isLoading.value = true;
            Get.defaultDialog(
                title: "Belum Verifikasi",
                middleText: "Kamu belum verifikasi akun",
                actions: [
                  OutlinedButton(
                      onPressed: () {
                        isLoading.value = false;

                        Get.back();
                      },
                      child: Text("CANCEL")),
                  OutlinedButton(
                      onPressed: () {
                        if (passC.text == "sehad123") {
                          Get.offAllNamed(Routes.NEW_PASSWORD);
                        } else {
                          Get.toNamed(Routes.HOME);
                        }
                      },
                      child: Text("Lanjut")),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await credential.user!.sendEmailVerification();
                          Get.back();
                          showSuccessDialog(
                              "Berhasil", "Berhasil mengirim email verifikasi");
                          isLoading.value = false;
                        } catch (e) {
                          isLoading.value = false;

                          showErrorDialog("ERROR",
                              "Tidak dpaat mengirim email verifikasi hubungi admin");
                        }
                      },
                      child: Text("Kirim Ulang"))
                ]);
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;

        if (e.code == "wrong-password") {
          showErrorDialog("ERROR", "Password lama anda salah");
        } else if (e.code == 'user-not-found') {
          showErrorDialog(
              "Terjadi Kesalahan", "Email Mahasiswa Tidak terdaftar");
        } else {
          showErrorDialog("ERROR", "${e.code.toLowerCase()}");
        }
      } catch (e) {
        isLoading.value = false;

        showErrorDialog('Error', 'tidak dapat login');
      }
    } else {
      showErrorDialog('Error', 'email dan password wajib diisi.');
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
