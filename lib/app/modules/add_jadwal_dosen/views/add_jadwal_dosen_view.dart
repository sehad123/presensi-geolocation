import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_jadwal_dosen_controller.dart';

class AddJadwalDosenView extends GetView<AddJadwalDosenController> {
  const AddJadwalDosenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddJadwalDosenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AddJadwalDosenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
