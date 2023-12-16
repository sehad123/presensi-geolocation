import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class AddDosenController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAdd = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nimC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();
  TextEditingController kelasC = TextEditingController();
  TextEditingController hpC = TextEditingController();

  final List<String> matkul = [
    "Data mining",
    "Interaksi Manusia dan Komputer",
    "Sistem Jaringan",
    "Official Statistik",
    "Big Data",
    "Machine Learning",
  ];
  RxString selectedMatkul = "".obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddMahasiswa() async {
    try {
      isLoadingAdd.value = true;
      String emailAdmin = auth.currentUser!.email!;

      // Login admin
      await auth.signInWithEmailAndPassword(
        email: emailAdmin,
        password: passAdminC.text,
      );

      // Tambah Mahasiswa
      UserCredential mahasiswaCredential =
          await auth.createUserWithEmailAndPassword(
        email: emailC.text,
        password: "sehad123",
      );

      if (mahasiswaCredential.user != null) {
        String? uid = mahasiswaCredential.user?.uid;
        ;

        await firestore.collection("mahasiswa").doc(uid).set({
          "nim": null,
          "nip": nimC.text,
          "name": nameC.text,
          "email": emailC.text,
          "kelas": null, // Use the selected class here
          "prodi": null, // Use the selected class here
          "matkul": selectedMatkul.value, // Use the selected class here
          "no hp": hpC.text, // Use the selected class here
          "uid": uid,
          "role": "dosen",
          "createdAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        await mahasiswaCredential.user!.sendEmailVerification();
        await auth.signOut();

        Get.back();
        Get.back();
        showSuccessDialog("SUCCESS", "Berhasil menambahkan Dosen");
        isLoadingAdd.value = false;
      }
    } on FirebaseAuthException catch (e) {
      isLoadingAdd.value = false;
      if (e.code == 'weak-password') {
        showErrorDialog("Peringatan", "Password minimal 8 karakter");
      } else if (e.code == 'email-already-in-use') {
        showErrorDialog("Peringatan", "Dosen sudah terdaftar");
      } else if (e.code == "wrong-password") {
        showErrorDialog(
            "Peringatan", "Admin Tidak dapat login, Password salah");
      } else {
        showErrorDialog("Peringatan", "${e.code}");
      }
    } catch (e) {
      isLoadingAdd.value = false;
      showErrorDialog("Peringatan", "Tidak dapat menambahkan Dosen");
    }
  }

  void addPegawai() async {
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        hpC.text.isNotEmpty &&
        selectedMatkul.isNotEmpty &&
        nimC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: "Validasi Admin",
        content: Column(
          children: [
            Text("Masukkan Password validasi admin"),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: passAdminC,
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              isLoading.value = false;

              Get.back();
            },
            child: Text("CANCEL"),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (isLoadingAdd.isFalse) await prosesAddMahasiswa();
                isLoading.value = false;
              },
              child: Text(isLoadingAdd.isFalse ? "ADD DOSEN" : "LOADING ..."),
            ),
          )
        ],
      );
    } else {
      showErrorDialog("Peringatan", "semua data harus diisi.");
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
