import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_detail_dosen_controller.dart';

class EditDetailDosenView extends GetView<EditDetailDosenController> {
  const EditDetailDosenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> user = Get.arguments;

    controller.nameC.text = user['name'];

    // Set an initial value for selectedKelas
    if (controller.selectedKelas.value.isEmpty) {
      controller.selectedKelas.value =
          user['matkul'] ?? controller.classes.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Dosen'),
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
                      'Mata Kuliah yang diampu', // Add your label here
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
                            items: controller.classes
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
