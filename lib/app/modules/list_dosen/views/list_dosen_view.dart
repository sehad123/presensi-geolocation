import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../controllers/list_dosen_controller.dart';

class ListDosenView extends GetView<ListDosenController> {
  const ListDosenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> user = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Dosen'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: 300,
              height: 50,
              child: TextField(
                onChanged: (value) {
                  controller.searchMahasiswa(value);
                },
                decoration: InputDecoration(
                  hintText: 'Cari Dosen...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<ListDosenController>(
              builder: (c) => Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.filteredMahasiswa.isEmpty) {
                  return SizedBox(
                    height: 150,
                    child: Center(
                      child: Text("Belum ada data Dosen"),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  itemCount: controller.filteredMahasiswa.length,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data =
                        controller.filteredMahasiswa[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Material(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () {
                            // Menampilkan dialog saat card di-tap
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Pilih Aksi"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Get.toNamed(Routes.DETAIL_DOSEN,
                                            arguments: data);
                                      },
                                      child: Text("Detail Dosen"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Get.toNamed(Routes.LIST_ABSEN_MAHASISWA,
                                            arguments: data);
                                      },
                                      child: Text("Detail Absensi Dosen"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Get.toNamed(Routes.EDIT_DETAIL_DOSEN,
                                            arguments: data);
                                      },
                                      child: Text("Edit Data Dosen"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        controller.deleteUser(data['uid']);
                                      },
                                      child: Text("Hapus Data Dosen"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "${data['name']}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "NIP : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${data['nip']}"),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${data['email']}"),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Matkul : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${data['matkul']}"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          if (user['role'] == 'admin')
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.add,
                      size: 40,
                    ),
                    onPressed: () => Get.toNamed(Routes.ADD_DOSEN),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
