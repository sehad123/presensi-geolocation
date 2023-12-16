import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve user data from arguments
    final Map<String, dynamic> user = Get.arguments;

    // Assign user data to controller's text fields
    controller.nimC.text = user['no hp'];
    // controller.nameC.text = user['name'];
    // controller.emailC.text = user['email'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('UPDATE PROFILE'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            Map<String, dynamic> user = snapshot.data!.data()!;
            // user['role'] == 'mahasiswa'?
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (user['role'] != 'admin')
                      buildTextField(controller.nimC, "No HP"),
                    SizedBox(height: 20),
                    Text("Foto Profile"),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GetBuilder<UpdateProfileController>(builder: (c) {
                          if (c.image != null) {
                            return ClipOval(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: Image.file(
                                  File(c.image!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            if (user['profile'] != null) {
                              return Column(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child: Image.network(
                                        user['profile'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      controller.deleteProfile(user['uid']);
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              );
                            } else {
                              return Text("no image ");
                            }
                          }
                        }),
                        TextButton(
                          onPressed: () {
                            controller.pickImage();
                          },
                          child: Text("Choose"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Obx(
                      () => ElevatedButton(
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
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      {bool readOnly = false}) {
    return TextField(
      readOnly: readOnly,
      autocorrect: false,
      keyboardType: TextInputType.number,
      maxLength: 12,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}
