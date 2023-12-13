import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  const AddPegawaiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Mahasiswa'),
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
              labelText: "NIM",
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
          DropdownButtonFormField<String>(
            value: controller.selectedKelas.value.isEmpty
                ? null
                : controller.selectedKelas.value,
            onChanged: (value) {
              controller.selectedKelas.value = value ?? '';
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
              labelText: "Kelas",
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
              controller.isLoading.isFalse ? "Add Mahasiswa" : "Loading ...",
            ),
          ),
        ],
      ),
    );
  }
}
