import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('UPDATE PASSWORD'),
          centerTitle: true,
        ),
        body: ListView(padding: EdgeInsets.all(20), children: [
          TextField(
            autocorrect: false,
            obscureText: true,
            controller: controller.passC,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Current Password"),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            controller: controller.newPassC,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "New Password"),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            controller: controller.confPassC,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Confirm Password"),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(
            () => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    controller.updatePassword();
                  }
                  // Get.toNamed(Routes.ADD_PEGAWAI);
                },
                child: Text(
                    controller.isLoading.isFalse ? "SUBMIT" : "LOADING...")),
          ),
        ]));
  }
}
