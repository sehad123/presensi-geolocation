import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_dosen_controller.dart';

class AddDosenView extends GetView<AddDosenController> {
  const AddDosenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Dosen'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.nimC,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "NIP",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: controller.nameC,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Name",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            maxLength: 12,
            autocorrect: false,
            keyboardType: TextInputType.number,
            controller: controller.hpC,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "No Hp",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          DropdownButtonFormField<String>(
            value: controller.selectedMatkul.value.isEmpty
                ? null
                : controller.selectedMatkul.value,
            onChanged: (value) {
              controller.selectedMatkul.value = value ?? '';
            },
            items: [
              DropdownMenuItem(
                value: 'Data Mining',
                child: Text('Data Mining'),
              ),
              DropdownMenuItem(
                value: 'Interaksi Manusia dan Komputer',
                child: Text('Interaksi Manusia dan Komputer'),
              ),
              DropdownMenuItem(
                value: 'Sistem Jaringan',
                child: Text('Sistem Jaringan'),
              ),
              DropdownMenuItem(
                value: 'Big Data',
                child: Text('Big Data'),
              ),
              DropdownMenuItem(
                value: 'Official Statistik',
                child: Text('Official Statistik'),
              ),
              DropdownMenuItem(
                value: 'Machine Learning',
                child: Text('Machine Learning'),
              ),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Matkul",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.isLoading.isFalse) {
                controller.addPegawai();
              }
            },
            child: Text(
              controller.isLoading.isFalse ? "Add Dosen" : "Loading ...",
            ),
          ),
        ],
      ),
    );
  }
}
