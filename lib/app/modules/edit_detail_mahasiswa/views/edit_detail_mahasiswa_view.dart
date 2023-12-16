import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_detail_mahasiswa_controller.dart';

class EditDetailMahasiswaView extends GetView<EditDetailMahasiswaController> {
  const EditDetailMahasiswaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> user = Get.arguments;

    controller.nameC.text = user['name'];

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Mahasiswa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextField(controller.nameC, "Name"),
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
              Obx(() => ElevatedButton(
                    onPressed: () {
                      if (controller.isLoading.isFalse) {
                        controller.updateProfile(user['uid']);
                      }
                    },
                    child: Text(
                      controller.isLoading.isFalse
                          ? "Update Profile"
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
