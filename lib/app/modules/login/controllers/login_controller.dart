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
                          Get.snackbar(
                              "Berhasil", "Berhasil mengirim email verifikasi");
                          isLoading.value = false;
                        } catch (e) {
                          isLoading.value = false;

                          Get.snackbar("ERROR",
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
          Get.snackbar("ERROR", "Password lama anda salah");
        } else if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi Kesalahan", "Email Mahasiswa Tidak terdaftar");
        } else {
          Get.snackbar("ERROR", "${e.code.toLowerCase()}");
        }
      } catch (e) {
        isLoading.value = false;

        Get.snackbar("Terjadi Kesalahan", "Tidak dapat login");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "email dan Password wajib di isi");
    }
  }
}
