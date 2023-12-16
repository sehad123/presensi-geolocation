// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:presensi/app/routes/app_pages.dart';

// class NewPasswordController extends GetxController {
//   TextEditingController newPassC = TextEditingController();
//   FirebaseAuth auth = FirebaseAuth.instance;
//   void newPassword() async {
//     if (newPassC.text.isNotEmpty) {
//       if (newPassC.text != "sehad123") {
//         try {
//           auth.currentUser!.updatePassword(newPassC.text);
//           String email = auth.currentUser!.email!;
//           await auth.signOut();
//           await auth.signInWithEmailAndPassword(
//               email: email, password: newPassC.text);
//           Get.offAllNamed(Routes.HOME);
//         } on FirebaseAuthException catch (e) {
//           if (e.code == 'weak-password') {
//             Get.snackbar("Terjadi Kesalahan", "Password anda lemah");
//           }
//         } catch (e) {
//           Get.snackbar(
//               "ERROR", "tidak dapat membuat password baru hubungi admin");
//         }
//       } else {
//         Get.snackbar(
//             "ERROR", "PASSWORD BARU TIDAK BOLEH SAMA DENGAN YANG LAMA");
//       }
//     } else {
//       Get.snackbar("ERROR", "PASSWORD BARU HARUS DIISI");
//     }
//   }
// }

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isEmpty) {
      showErrorDialog("ERROR", "PASSWORD BARU HARUS DIISI");
      return;
    }

    if (newPassC.text == "sehad123") {
      showErrorDialog(
          "ERROR", "PASSWORD BARU TIDAK BOLEH SAMA DENGAN YANG LAMA");
      return;
    }

    try {
      await auth.currentUser?.updatePassword(newPassC.text);
      String email = auth.currentUser!.email!;
      await auth.signOut();
      await auth.signInWithEmailAndPassword(
          email: email, password: newPassC.text);
      Get.offAllNamed(Routes.HOME);
      showSuccessDialog("SUCESS ", "Password anda berhasil diperbarui");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorDialog("Terjadi Kesalahan", "Password Anda terlalu lemah");
      } else {
        showErrorDialog("Terjadi Kesalahan", "Gagal mengganti password");
      }
    } catch (e) {
      showErrorDialog(
          "ERROR", "Tidak dapat membuat password baru. Hubungi admin.");
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
