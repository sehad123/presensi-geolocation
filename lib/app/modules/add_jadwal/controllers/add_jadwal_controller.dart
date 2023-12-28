import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddJadwalController extends GetxController {
  final uuid = Uuid();
  RxBool isLoading = false.obs;
  RxBool isLoadingAdd = false.obs;
  TextEditingController kodeC = TextEditingController();
  TextEditingController dosenC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();
  TextEditingController JamMC = TextEditingController();
  TextEditingController menitMC = TextEditingController();
  TextEditingController JamKC = TextEditingController();
  TextEditingController menitKC = TextEditingController();
  TextEditingController RuanganC = TextEditingController();
  TextEditingController untukC = TextEditingController();

  RxString selectedKelas = "".obs;
  RxString selectedProdi = "".obs;
  RxString selectedHari = "".obs;
  RxString selectedMatkul = "".obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<DropdownMenuItem<String>> dosenDropdownItems =
      <DropdownMenuItem<String>>[].obs;

  RxList<DropdownMenuItem<String>> ruanganDropdownItems =
      <DropdownMenuItem<String>>[].obs;

  Future<List<String>> fetchRuangan() async {
    try {
      isLoading.value = true;

      var querySnapshot = await firestore
          .collection("ruangan")
          .where('status', isEqualTo: 'ada')
          .get();

      List<String> ruanganList =
          querySnapshot.docs.map((doc) => doc['nomor'] as String).toList();

      return ruanganList;
    } catch (e) {
      print("$e");
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<String>> fetchDosen() async {
    try {
      isLoading.value = true;
      var querySnapshot = await firestore
          .collection("mahasiswa")
          .where('role', isEqualTo: 'dosen')
          .get();

      // Extract dosen names from the querySnapshot
      List<String> dosenList = querySnapshot.docs
          .map((doc) =>
              doc['name'] as String) // Assuming the field is named 'name'
          .toList();

      return dosenList;
    } catch (e) {
      print("$e");
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> prosesAddMahasiswa() async {
    try {
      isLoadingAdd.value = true;

      // Generate a random UID
      String uniqueId = uuid.v4();

      // Tambah Jadwal
      await firestore.collection("jadwal").doc(uniqueId).set({
        "kode": kodeC.text,
        "jam_mulai": JamMC.text,
        "menit_mulai": menitMC.text,
        "jam_akhir": JamKC.text,
        "menit_akhir": menitKC.text,
        "ruangan": RuanganC.text,
        "matkul": selectedMatkul.value,
        "dosen": dosenC.text,
        "kelas": selectedKelas.value,
        "prodi": selectedProdi.value,
        "hari": selectedHari.value,
        "role": untukC.text,
        "uid": uniqueId,
        // "role": "mahasiswa",
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await updateRuangan(RuanganC.text);

      Get.back();
      Get.back();
      showSuccessDialog("SUCCESS", "Berhasil menambahkan jadwal");
    } on FirebaseAuthException catch (e) {
      isLoadingAdd.value = false;
      print("$e");

      // Handle exceptions
    } catch (e) {
      isLoadingAdd.value = false;
      // Handle exceptions
      print("$e");
    } finally {
      isLoadingAdd.value = false;
    }
  }

  void addRuangan() async {
    if (RuanganC.text.isEmpty || RuanganC.text.isNotEmpty) {
      // Call fetchRuangan to get the list of ruangan numbers
      List<String> ruanganList = await fetchRuangan();

      // Update the ruanganDropdownItems with the fetched ruangan numbers
      ruanganDropdownItems.value = ruanganList.map((nomor) {
        return DropdownMenuItem(value: nomor, child: Text(nomor));
      }).toList();

      // Show the dropdown dialog
      showRuanganDropdown();
    } else {
      showErrorDialog("Peringatan", "Semua data harus diisi.");
    }
  }

  void addDosen() async {
    if (dosenC.text.isEmpty || dosenC.text.isNotEmpty) {
      // Call fetchDosen to get the list of dosen names
      List<String> dosenList = await fetchDosen();

      // Update the dosenDropdownItems with the fetched dosen names
      dosenDropdownItems.value = dosenList.map((name) {
        return DropdownMenuItem(value: name, child: Text(name));
      }).toList();

      // Show the dropdown dialog
      showDosenDropdown();
    } else {
      showErrorDialog("Peringatan", "Semua data harus diisi.");
    }
  }

  void addPegawai() async {
    if (dosenC.text.isNotEmpty &&
        RuanganC.text.isNotEmpty &&
        JamMC.text.isNotEmpty &&
        JamKC.text.isNotEmpty &&
        menitMC.text.isNotEmpty &&
        menitKC.text.isNotEmpty &&
        selectedMatkul.isNotEmpty &&
        selectedHari.isNotEmpty &&
        selectedKelas.isNotEmpty &&
        untukC.text.isNotEmpty &&
        selectedProdi.isNotEmpty &&
        kodeC.text.isNotEmpty) {
      isLoading.value = true;
      await updateRuangan(RuanganC.text);
      await prosesAddMahasiswa();
    } else {
      showErrorDialog("Peringatan", "Semua data harus diisi.");
    }
  }

  // Add an RxList to hold the dropdown items for dosen

  void showRuanganDropdown() {
    Get.defaultDialog(
      title: 'Pilih Ruangan',
      content: Container(
        width: Get.width * 0.7,
        child: DropdownButtonFormField<String>(
          value: null,
          onChanged: (value) {
            RuanganC.text = value!;
            Get.back();
          },
          items: ruanganDropdownItems,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Ruangan",
          ),
        ),
      ),
    );
  }

  Future<void> updateRuangan(String nomor) async {
    try {
      isLoading.value = true;
      Map<String, dynamic> data = {
        "status": "terpakai",
      };
      await firestore.collection("ruangan").doc(nomor).update(data);
      isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }

// Function to show the dosen dropdown
  void showDosenDropdown() {
    Get.defaultDialog(
      title: 'Pilih Dosen',
      content: Container(
        width: Get.width * 0.7,
        child: DropdownButtonFormField<String>(
          value: null,
          onChanged: (value) {
            dosenC.text = value!;
            Get.back();
          },
          items: dosenDropdownItems,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Dosen",
          ),
        ),
      ),
    );
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
  List<DropdownMenuItem<String>> getMatkulDropdownItems() {
    switch (selectedProdi.value) {
      case 'D3 Statistik':
        return [
          DropdownMenuItem(
              value: 'manajemen perkantoran',
              child: Text('manajemen perkantoran')),
          DropdownMenuItem(value: 'Psikologi', child: Text('Psikologi')),
          DropdownMenuItem(
              value: 'Latihan Survey', child: Text('Latihan Survey')),
        ];
      case 'D4 Statistik':
        return [
          DropdownMenuItem(
              value: 'Ekonommi Lanjutan', child: Text('Ekonommi Lanjutan')),
          DropdownMenuItem(
              value: 'Metode Penelitian', child: Text('Metode Penelitian')),
          DropdownMenuItem(
              value: 'Analisis Runtun Waktu',
              child: Text('Analisis Runtun Waktu')),
          DropdownMenuItem(
              value: 'Metode Penarikan Sampel',
              child: Text('Metode Penarikan Sampel')),
          DropdownMenuItem(
              value: 'Official Statistik ', child: Text('Official Statistik ')),
          DropdownMenuItem(
              value: 'Metode Sensus', child: Text('Metode Sensus')),
        ];
      case 'D4 Komputasi Statistik':
        return [
          DropdownMenuItem(value: 'Data Mining', child: Text('Data Mining')),
          DropdownMenuItem(
              value: 'Teknologi Big Data', child: Text('Teknologi Big Data')),
          DropdownMenuItem(
              value: 'Kecerdasan Buatan', child: Text('Kecerdasan Buatan')),
          DropdownMenuItem(
              value: 'Interaksi Komputer dan Manusia',
              child: Text('Interaksi Komputer dan Manusia')),
          DropdownMenuItem(
              value: 'Oficial Statistik Lanjutan',
              child: Text('Oficial Statistik Lanjutan')),
          DropdownMenuItem(
              value: 'Sistem Jaringan Keamanan',
              child: Text('Sistem Jaringan Keamanan')),
          DropdownMenuItem(
              value: 'Teknologi Perekayasaan Data ',
              child: Text('Teknologi Perekayasaan Data ')),
          DropdownMenuItem(
              value: 'Visualisasi Data dan Informasi',
              child: Text('Visualisasi Data dan Informasi')),
        ];
      default:
        return [];
    }
  }

  // Reset the selectedKelas when Prodi changes
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
