import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_ruangan_controller.dart';

class EditRuanganView extends GetView<EditRuanganController> {
  const EditRuanganView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> user = Get.arguments;

    controller.nomorC.text = user['nomor'];

    // Set an initial value for selectedStatus
    if (controller.selectedStatus.value.isEmpty) {
      controller.selectedStatus.value =
          user['status'] ?? controller.classes.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Ruangan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextField(controller.nomorC, "Nomor"),
              SizedBox(height: 20),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Ruangan', // Add your label here
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
                            value: controller.selectedStatus.value,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                // Update the selectedStatus value directly
                                controller.selectedStatus.value = newValue;
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
                        controller.updateRuangan(user['uid']);
                      }
                    },
                    child: Text(
                      controller.isLoading.isFalse ? "Edit Ruangan" : "LOADING",
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
      readOnly: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}
