import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../controllers/detail_dosen_controller.dart';

class DetailDosenView extends GetView<DetailDosenController> {
  const DetailDosenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> user = Get.arguments;
    if (user == null || user['uid'] == null) {
      return Scaffold(
        body: Center(
          child: Text("Error: User data is missing"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dosen'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(user['uid']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            Map<String, dynamic> user2 = snapshot.data!.data()!;
            String defaultImage =
                "https://ui-avatars.com/api/?name=${user['name']}";
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Colors.blue,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          user['profile'] != null
                              ? user['profile'] != ""
                                  ? user['profile']
                                  : defaultImage
                              : defaultImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Nama = ${user['name']}"),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.format_list_numbered),
                  title: Text("NIP = ${user['nip']}"),
                ),
                SizedBox(height: 14),
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text("matkul = ${user['matkul']}"),
                ),
                SizedBox(height: 14),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text("Email = ${user['email']}"),
                ),
                SizedBox(height: 14),
                ListTile(
                  leading: Icon(Icons.phone_android),
                  title: Text("No Hp = ${user['no hp']}"),
                ),
                SizedBox(height: 14),
                if (user['role'] != "dosen")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => Get.toNamed(Routes.EDIT_DETAIL_DOSEN,
                            arguments: user),
                        child: Text("Edit Dosen"),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.deleteUser(user['uid']),
                        child: Text("Hapus Dosen"),
                      ),
                    ],
                  ),
              ],
            );
          } else {
            return Center(
              child: Text("Tidak dapat memuat data"),
            );
          }
        },
      ),
    );
  }
}
