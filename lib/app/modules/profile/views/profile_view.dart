import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/controllers/page_index_controller.dart';
import 'package:presensi/app/routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            // mendapatkan data user
            Map<String, dynamic> user = snapshot.data!.data()!;
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
                            color: Colors.blue), // Optional: Add a border
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
                          fit: BoxFit
                              .cover, // Optional: Adjust the fit of the image
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "${user['name']}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 5),
                Text(
                  user['role'] == 'admin'
                      ? "${user['email']}"
                      : user['role'] == 'mahasiswa'
                          ? "${user['nim']}"
                          : "${user['nip']}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                // if (user['kelas'] != null)
                user['kelas'] != null
                    ? Text(
                        "${user['kelas']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      )
                    : Text(
                        "${user['role']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),

                SizedBox(height: 10),
                if (user['role'] == "mahasiswa")
                  ListTile(
                    onTap: () =>
                        Get.toNamed(Routes.DETAIL_MAHASISWA, arguments: user),
                    leading: Icon(Icons.person),
                    title: Text("Detail Profile"),
                  ),
                if (user['role'] == "dosen")
                  ListTile(
                    onTap: () =>
                        Get.toNamed(Routes.DETAIL_DOSEN, arguments: user),
                    leading: Icon(Icons.person),
                    title: Text("Detail Profile"),
                  ),
                SizedBox(height: 10),
                ListTile(
                  onTap: () =>
                      Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                  leading: Icon(Icons.people_alt),
                  title: Text("Update Profile"),
                ),
                SizedBox(height: 10),
                ListTile(
                  onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                  leading: Icon(Icons.password),
                  title: Text("Update Password"),
                ),
                if (user['role'] == "admin")
                  ListTile(
                    onTap: () =>
                        Get.toNamed(Routes.LIST_MAHASISWA, arguments: user),
                    leading: Icon(Icons.person),
                    title: Text(" Data Mahasiswa"),
                  ),
                if (user['role'] == "admin")
                  ListTile(
                    onTap: () =>
                        Get.toNamed(Routes.LIST_DOSEN, arguments: user),
                    leading: Icon(Icons.person_2_outlined),
                    title: Text(" Data Dosen"),
                  ),
                SizedBox(height: 10),
                if (user['role'] == "admin")
                  ListTile(
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
                                  Get.toNamed(Routes.LIST_JADWAL,
                                      arguments: user);
                                },
                                child: Text("Jadwal Mahasiswa"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Get.toNamed(Routes.LIST_JADWAL_DOSEN,
                                      arguments: user);
                                },
                                child: Text("Jadwal Dosen"),
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
                    leading: Icon(Icons.list),
                    title: Text("jadwal"),
                  ),
                if (user['role'] == "mahasiswa")
                  ListTile(
                    onTap: () => Get.toNamed(Routes.LIST_JADWAL),
                    leading: Icon(Icons.list),
                    title: Text("jadwal"),
                  ),
                // SizedBox(height: 20),
                if (user['role'] == "dosen")
                  ListTile(
                    onTap: () => Get.toNamed(Routes.LIST_JADWAL_DOSEN),
                    leading: Icon(Icons.list),
                    title: Text("jadwal"),
                  ),
                // SizedBox(height: 20),
                SizedBox(height: 10),
                ListTile(
                  onTap: () => controller.logout(),
                  leading: Icon(Icons.logout),
                  title: Text("LogOut"),
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
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Presensi'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
