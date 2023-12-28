import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_ruangan_controller.dart';

class AddRuanganView extends GetView<AddRuanganController> {
  const AddRuanganView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AddRuanganView'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                autocorrect: false,
                controller: controller.nomorC,
                keyboardType: TextInputType.number,
                maxLength: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "nomor ruangan",
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  controller.addRuangan();
                },
                child: Text("Submit"))
          ],
        ));
  }
}
