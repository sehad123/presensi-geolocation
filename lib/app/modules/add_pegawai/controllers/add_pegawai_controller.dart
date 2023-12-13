import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAdd = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nimC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();
  TextEditingController kelasC = TextEditingController();
  final List<String> classes = [
    "D4 Statistika",
    "D4 Komputasi Statistik",
    "D3 Statistik"
  ];
  RxString selectedKelas = "".obs;

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
          "uid": uid,
          "role": "mahasiswa",
          "createdAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        await mahasiswaCredential.user!.sendEmailVerification();
        await auth.signOut();

        Get.back();
        Get.back();
        Get.snackbar("SUCCESS", "Berhasil menambahkan Mahasiswa");
        isLoadingAdd.value = false;
      }
    } on FirebaseAuthException catch (e) {
      isLoadingAdd.value = false;
      if (e.code == 'weak-password') {
        Get.snackbar("Peringatan", "Password minimal 8 karakter");
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Peringatan", "Mahasiswa sudah terdaftar");
      } else if (e.code == "wrong-password") {
        Get.snackbar("Peringatan", "Admin Tidak dapat login, Password salah");
      } else {
        Get.snackbar("Peringatan", "${e.code}");
      }
    } catch (e) {
      isLoadingAdd.value = false;
      Get.snackbar("Peringatan", "Tidak dapat menambahkan mahasiswa");
    }
  }

  void addPegawai() async {
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        selectedKelas.isNotEmpty &&
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
              child:
                  Text(isLoadingAdd.isFalse ? "ADD MAHASISWA" : "LOADING ..."),
            ),
          )
        ],
      );
    } else {
      Get.snackbar("Peringatan", "Nama, NIM, dan Email harus diisi.");
    }
  }
}
