import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/update_mahasiswa_controller.dart';

class UpdateMahasiswaView extends GetView<UpdateMahasiswaController> {
  const UpdateMahasiswaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve user data from arguments
    final Map<String, dynamic>? data = Get.arguments?["data"];
    final Map<String, dynamic>? data2 = Get.arguments?["data2"];

    // Check if data and data2 are not null
    if (data == null || data2 == null || data2['uid'] == null) {
      return Scaffold(
        body: Center(
          child: Text("Error: User data is missing"),
        ),
      );
    }

    // Assign user data to controller's text fields
    controller.statusMC.text = data['masuk']?['status'] ?? '';
    controller.statusKC.text = data['keluar']?['status'] ?? '';
    print(data2['uid']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('UPDATE PROFILE'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextField(controller.statusMC, "Status Masuk"),
              SizedBox(height: 20),
              buildTextField(controller.statusKC, "Status Keluar"),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                  // Check if uid and date are not null before updating
                  if (data2['uid'] != null && data['date'] != null) {
                    await controller.updateMasukStatus(
                      data2['uid'].toString(),
                      data['date'].toIso8601String(),
                    );
                    await controller.updateKeluarStatus(
                      data2['uid'].toString(),
                      data['date'].toIso8601String(),
                    );
                  } else {
                    // Handle the case where uid or date is null
                    // You can show an error message or log the issue
                    showErrorDialog("Error: uid or date is null", "");
                  }
                },
                child: Text(
                  controller.isLoading.value ? "LOADING" : "Update Status",
                ),
              ),
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

  void showErrorDialog(String title, String desc) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.error,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }
}
