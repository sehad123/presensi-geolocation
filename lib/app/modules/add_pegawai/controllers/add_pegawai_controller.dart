import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAdd = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nimC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();
  TextEditingController hpC = TextEditingController();

  RxString selectedKelas = "".obs;
  RxString selectedProdi = "".obs;

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

        // Update data Mahasiswa
        await firestore.collection("mahasiswa").doc(uid).set({
          "nim": nimC.text,
          "name": nameC.text,
          "email": emailC.text,
          "kelas": selectedKelas.value, // Use the selected class here
          "prodi": selectedProdi.value, // Use the selected class here
          "no hp": hpC.text, // Use the selected class here
          "uid": uid,
          "role": "mahasiswa",
          "createdAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        await mahasiswaCredential.user!.sendEmailVerification();
        await auth.signOut();

        // Get.toNamed(Routes.PROFILE);
        Get.back();
        Get.back();
        showSuccessDialog("SUCCESS", "Berhasil menambahkan Mahasiswa");
        isLoadingAdd.value = false;
      }
    } on FirebaseAuthException catch (e) {
      isLoadingAdd.value = false;
      if (e.code == 'weak-password') {
        showErrorDialog("Peringatan", "Password minimal 8 karakter");
      } else if (e.code == 'email-already-in-use') {
        showErrorDialog("Peringatan", "Mahasiswa sudah terdaftar");
      } else if (e.code == "wrong-password") {
        showErrorDialog(
            "Peringatan", "Admin Tidak dapat login, Password salah");
      } else {
        showErrorDialog("Peringatan", "${e.code}");
      }
    } catch (e) {
      isLoadingAdd.value = false;
      showErrorDialog("Peringatan", "Tidak dapat menambahkan mahasiswa");
    }
  }

  void addPegawai() async {
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        hpC.text.isNotEmpty &&
        selectedKelas.isNotEmpty &&
        selectedProdi.isNotEmpty &&
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
              child: Text(
                isLoadingAdd.isFalse ? "ADD MAHASISWA" : "LOADING ...",
              ),
            ),
          )
        ],
      );
    } else {
      showErrorDialog("Peringatan", "Nama, NIM, dan Email harus diisi.");
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

  // Update the dropdown items based on the selected prodi
  List<DropdownMenuItem<String>> getKelasDropdownItems() {
    switch (selectedProdi.value) {
      case 'D3 Statistik':
        return [
          DropdownMenuItem(value: '3D31', child: Text('3D31')),
          DropdownMenuItem(value: '3D32', child: Text('3D32')),
          DropdownMenuItem(value: '3D33', child: Text('3D33')),
        ];
      case 'D4 Statistik':
        return [
          DropdownMenuItem(value: '3SK1', child: Text('3SK1')),
          DropdownMenuItem(value: '3SK2', child: Text('3SK2')),
          DropdownMenuItem(value: '3SK3', child: Text('3SK3')),
          DropdownMenuItem(value: '3SE1', child: Text('3SE1')),
          DropdownMenuItem(value: '3SE2', child: Text('3SE2')),
          DropdownMenuItem(value: '3SE3', child: Text('3SE3')),
        ];
      case 'D4 Komputasi Statistik':
        return [
          DropdownMenuItem(value: '3SI1', child: Text('3SI1')),
          DropdownMenuItem(value: '3SI2', child: Text('3SI2')),
          DropdownMenuItem(value: '3SI3', child: Text('3SI3')),
          DropdownMenuItem(value: '3SD1', child: Text('3SD1')),
          DropdownMenuItem(value: '3SD2', child: Text('3SD2')),
          DropdownMenuItem(value: '3SD3', child: Text('3SD3')),
        ];
      default:
        return [];
    }
  }

  // Reset the selectedKelas when Prodi changes
  void updateKelasDropdown() {
    selectedKelas.value = '';
  }
}
