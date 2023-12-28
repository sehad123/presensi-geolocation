import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditJadwalController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController dosenC = TextEditingController();
  TextEditingController JamMC = TextEditingController();
  TextEditingController menitMC = TextEditingController();
  TextEditingController JamKC = TextEditingController();
  TextEditingController menitKC = TextEditingController();
  TextEditingController ruanganC = TextEditingController();

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

  final List<String> classesKS = [
    "3SI3",
    "3SI1",
    "3SI2",
    "3SD1",
    "3SD2",
    "3SD3",
  ];
  final List<String> classesST = [
    "3SK3",
    "3SK1",
    "3SK2",
    "3SE1",
    "3SE2",
    "3SE3",
  ];
  final List<String> classesD3 = [
    "3D31",
    "3D32",
    "3D33",
    "3D34",
  ];
  final List<String> day = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
  ];
  RxString selectedDay = "".obs;
  RxString selectedKelas = "".obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateProfile(String uid) async {
    if (dosenC.text.isNotEmpty &&
        ruanganC.text.isNotEmpty &&
        JamMC.text.isNotEmpty &&
        JamKC.text.isNotEmpty &&
        menitMC.text.isNotEmpty &&
        menitKC.text.isNotEmpty &&
        selectedDay.value.isNotEmpty) {
      try {
        isLoading.value = true;
        Map<String, dynamic> data = {
          "hari": selectedDay.value,
          "kelas": selectedKelas.value,
          "jam_mulai": JamMC.text,
          "menit_mulai": menitMC.text,
          "jam_akhir": JamKC.text,
          "menit_akhir": menitKC.text,
          "ruangan": ruanganC.text,
          "dosen": dosenC.text,
        };

        // Update data mahasiswa
        await firestore.collection("jadwal").doc(uid).update(data);

        isLoading.value = false;

        // Get.(Routes.LIST_MAHASISWA);
        Get.back();
        Get.back();
        showSuccessDialog("SUCCESS", "Jadwal berhasil diperbarui");
      } catch (e) {
        showErrorDialog('Error', 'Gagal memperbarui Jadwal.');
      } finally {
        isLoading.value = false;
      }
    } else {
      showErrorDialog('Error', 'Nama tidak boleh kosong');
    }
  }

  Future<void> updateDosen(String uid) async {
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
      showErrorDialog('Error', 'Nama tidak boleh kosong');
    }
  }

  Future<void> updateRuangan(String uid) async {
    if (ruanganC.text.isEmpty || ruanganC.text.isNotEmpty) {
      // Call fetchRuangan to get the list of ruangan numbers
      List<String> ruanganList = await fetchRuangan();

      // Update the ruanganDropdownItems with the fetched ruangan numbers
      ruanganDropdownItems.value = ruanganList.map((nomor) {
        return DropdownMenuItem(value: nomor, child: Text(nomor));
      }).toList();

      // Show the dropdown dialog
      showRuanganDropdown();
    } else {
      showErrorDialog('Error', 'Nama tidak boleh kosong');
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

  void showRuanganDropdown() {
    Get.defaultDialog(
      title: 'Pilih Ruangan',
      content: Container(
        width: Get.width * 0.7,
        child: DropdownButtonFormField<String>(
          value: null,
          onChanged: (value) {
            ruanganC.text = value!;
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
}
