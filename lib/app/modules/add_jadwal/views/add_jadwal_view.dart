import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_jadwal_controller.dart';

class AddJadwalView extends GetView<AddJadwalController> {
  const AddJadwalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final untuk = Get.arguments;
    controller.untukC.text = untuk;
    int maxValueJam = 24; // Nilai maksimum yang diizinkan
    int maxValueMenit = 60; // Nilai maksimum yang diizinkan
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Jadwal'),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView(
          padding: EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<String>(
              value: controller.selectedHari.value.isEmpty
                  ? null
                  : controller.selectedHari.value,
              onChanged: (value) {
                controller.selectedHari.value = value!;
              },
              items: [
                DropdownMenuItem(
                  value: 'Senin',
                  child: Text('Senin'),
                ),
                DropdownMenuItem(
                  value: 'Selasa',
                  child: Text('Selasa'),
                ),
                DropdownMenuItem(
                  value: 'Rabu',
                  child: Text('Rabu'),
                ),
                DropdownMenuItem(
                  value: 'Kamis',
                  child: Text('Kamis'),
                ),
                DropdownMenuItem(
                  value: 'Jumat',
                  child: Text('Jumat'),
                ),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Hari",
              ),
            ),
            SizedBox(height: 20),
            TextField(
              maxLength: 5,
              autocorrect: false,
              keyboardType: TextInputType.number,
              controller: controller.kodeC,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Kode Matkul",
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller.JamMC,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  int enteredValue = int.parse(value);
                  if (enteredValue > maxValueJam) {
                    controller.JamMC.text = maxValueJam.toString();
                  }
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Jam Mulai",
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller.menitMC,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  int enteredValue = int.parse(value);
                  if (enteredValue > maxValueMenit) {
                    controller.menitMC.text = maxValueMenit.toString();
                  }
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Menit Mulai",
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller.JamKC,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  int enteredValue = int.parse(value);
                  if (enteredValue > maxValueJam) {
                    controller.JamKC.text = maxValueJam.toString();
                  }
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Jam Selesai",
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller.menitKC,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  int enteredValue = int.parse(value);
                  if (enteredValue > maxValueMenit) {
                    controller.menitKC.text = maxValueMenit.toString();
                  }
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Menit Selesai",
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                if (controller.isLoading.isFalse) {
                  controller.addRuangan();
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  autocorrect: false,
                  controller: controller.RuanganC,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Ruangan",
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                if (controller.isLoading.isFalse) {
                  controller.addDosen();
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  autocorrect: false,
                  controller: controller.dosenC,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Dosen",
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: controller.selectedProdi.value.isEmpty
                  ? null
                  : controller.selectedProdi.value,
              onChanged: (value) {
                controller.selectedProdi.value = value!;
                controller.updateKelasDropdown();
              },
              items: [
                DropdownMenuItem(
                  value: 'D3 Statistik',
                  child: Text('D3 Statistik'),
                ),
                DropdownMenuItem(
                  value: 'D4 Statistik',
                  child: Text('D4 Statistik'),
                ),
                DropdownMenuItem(
                  value: 'D4 Komputasi Statistik',
                  child: Text('D4 Komputasi Statistik'),
                ),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Prodi",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              value: controller.selectedKelas.value.isEmpty
                  ? null
                  : controller.selectedKelas.value,
              onChanged: (value) {
                controller.selectedKelas.value = value!;
              },
              items: controller.getKelasDropdownItems(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Kelas",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              value: controller.selectedMatkul.value.isEmpty
                  ? null
                  : controller.selectedMatkul.value,
              onChanged: (value) {
                controller.selectedMatkul.value = value!;
              },
              items: controller.getMatkulDropdownItems(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Matkul",
              ),
            ),
            SizedBox(height: 20),
            TextField(
              autocorrect: false,
              readOnly: true,
              controller: controller.untukC,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Untuk ",
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.addPegawai();
                }
              },
              child: Text(
                controller.isLoading.isFalse ? "Add Jadwal" : "Loading ...",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
