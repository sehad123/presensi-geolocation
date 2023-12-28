import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_jadwal_controller.dart';

class EditJadwalView extends GetView<EditJadwalController> {
  const EditJadwalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> user = Get.arguments;
    int maxValueJam = 24; // Nilai maksimum yang diizinkan
    int maxValueMenit = 60;

    controller.dosenC.text = user['dosen'];
    controller.JamMC.text = user['jam_mulai'];
    controller.JamKC.text = user['jam_akhir'];
    controller.menitMC.text = user['menit_mulai'];
    controller.menitKC.text = user['menit_akhir'];
    controller.ruanganC.text = user['ruangan'];

    // Set an initial value for selectedKelas
    if (controller.selectedKelas.value.isEmpty) {
      if (user['prodi'] == 'D4 Komputasi Statistik') {
        controller.selectedKelas.value =
            user['kelas'] ?? controller.classesKS.first;
      } else if (user['prodi'] == 'D4 Statistik') {
        controller.selectedKelas.value =
            user['kelas'] ?? controller.classesST.first;
      } else {
        controller.selectedKelas.value =
            user['kelas'] ?? controller.classesD3.first;
      }
    }

    if (controller.selectedDay.value.isEmpty) {
      controller.selectedDay.value = user['hari'] ?? controller.day.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Jadwal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "${user['matkul']}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (controller.isLoading.isFalse) {
                    controller.updateDosen(user['uid']);
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
                    controller.updateRuangan(user['uid']);
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    autocorrect: false,
                    controller: controller.ruanganC,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Ruangan",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Kelas', // Add your label here
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: double
                          .infinity, // Make the DropdownButton take up the full width
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Center the text
                        children: [
                          DropdownButton<String>(
                            value: controller.selectedKelas.value,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                // Update the selectedKelas value directly
                                controller.selectedKelas.value = newValue;
                              }
                            },
                            items: (user['prodi'] == 'D4 Komputasi Statistik')
                                ? controller.classesKS.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()
                                : (user['prodi'] == 'D4 Statistik')
                                    ? controller.classesST.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()
                                    : controller.classesD3.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Hari',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            value: controller.selectedDay.value,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.selectedDay.value = newValue;
                              }
                            },
                            items: controller.day
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Obx(() => ElevatedButton(
                    onPressed: () {
                      if (controller.isLoading.isFalse) {
                        controller.updateProfile(user['uid']);
                      }
                    },
                    child: Text(
                      controller.isLoading.isFalse
                          ? "Update Jadwal"
                          : "LOADING",
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}
