import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/controllers/page_index_controller.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final pageC = Get.find<PageIndexController>();
  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return "Selamat Pagi";
    } else if (hour < 15) {
      return "Selamat Siang";
    } else if (hour < 18) {
      return "Selamat Sore";
    } else {
      return "Selamat Malam";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME '),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE),
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;
              String defaultImage =
                  "https://ui-avatars.com/api/?name=${user['name'] ?? 'Default'}";

              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[200],
                          ),
                          // child: Center(child: Text("X")),
                          child: Image.network(
                            user['profile'] != null
                                ? user['profile']
                                : defaultImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getGreeting(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 160,
                            child: Text(
                              user['address'] != null
                                  ? "${user['address']}"
                                  : "Belum ada lokasi",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user['name']}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user['role'] == 'dosen' || user['role'] == 'admin'
                              ? "${user['nip']}"
                              : "${user['nim']}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user['kelas'] != null
                              ? "${user['kelas'].toString().toUpperCase()}"
                              : "${user['role'].toString().toUpperCase()}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 290,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller.streamTodayPresence(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          Map<String, dynamic>? dataToday =
                              snapshot.data?.data();
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Text(
                                  "${dataToday?['date'] != null ? DateFormat.yMMMEd().format(DateTime.parse(dataToday!['date'])) : DateFormat.yMMMEd().format(DateTime.now())}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                color: Colors.grey[300],
                                thickness: 2,
                              ),
                              Column(
                                children: [
                                  Text(
                                    dataToday?['masuk']?['matkul'] == null
                                        ? " "
                                        : " ( ${dataToday?['masuk']?['matkul']} )",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(dataToday?['masuk'] == null
                                      ? ""
                                      : "${DateFormat.jms().format(DateTime.parse(dataToday!['masuk']['date']))}"),
                                  Text(
                                    dataToday?['masuk']?['matkul'] == null
                                        ? " "
                                        : "  ${dataToday?['masuk']?['status']} ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: dataToday?['masuk']?['status'] ==
                                                'hadir'
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey[300],
                                thickness: 2,
                              ),
                              Column(
                                children: [
                                  Text(
                                    dataToday?['keluar']?['matkul'] == null
                                        ? " "
                                        : " ( ${dataToday?['keluar']?['matkul']} )",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(dataToday?['keluar'] == null
                                      ? " "
                                      : "${DateFormat.jms().format(DateTime.parse(dataToday!['keluar']['date']))}"),
                                  Text(
                                    dataToday?['keluar']?['matkul'] == null
                                        ? " "
                                        : "  ${dataToday?['keluar']?['status']} ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: dataToday?['keluar']
                                                    ?['status'] ==
                                                'hadir'
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey[300],
                                thickness: 2,
                              ),
                              Column(
                                children: [
                                  Text(
                                    dataToday?['sesi']?['matkul'] == null
                                        ? " "
                                        : " ( ${dataToday?['sesi']?['matkul']} )",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(dataToday?['sesi'] == null
                                      ? " "
                                      : "${DateFormat.jms().format(DateTime.parse(dataToday!['sesi']['date']))}"),
                                  Text(
                                    dataToday?['sesi']?['matkul'] == null
                                        ? " "
                                        : "  ${dataToday?['sesi']?['status']} ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: dataToday?['sesi']?['status'] ==
                                                'hadir'
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Last 5 day",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.ALL_PRESENSI);
                          },
                          child: Text("See more")),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller.streamLastPresence(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data?.docs.length == 0 ||
                            snapshot.data == null) {
                        } else {}
                        print(snapshot.data!.docs);
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data =
                                  snapshot.data!.docs[index].data();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Material(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.DETAIL_PRESENSI,
                                          arguments: data);
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        // color: Colors.grey[200],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey[300],
                                            thickness: 2,
                                          ),
                                          Text(
                                            data['masuk']?['matkul'] == null
                                                ? "   "
                                                : " ( ${data['masuk']?['matkul']} )",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(data['masuk']?['date'] == null
                                              ? " jam : -"
                                              : "jam : ${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}"),
                                          Text(
                                            "Status : ${data['masuk']?['status']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Divider(
                                            color: Colors.grey[300],
                                            thickness: 2,
                                          ),
                                          Text(
                                            data['keluar']?['matkul'] == null
                                                ? "  "
                                                : " ( ${data['keluar']?['matkul']} )",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(data['keluar']?['date'] == null
                                              ? "jam : -"
                                              : "jam : ${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}"),
                                          Text(
                                            data['keluar']?['date'] == null
                                                ? "Status : -  "
                                                : "Status : ${data['keluar']?['status']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Divider(
                                            color: Colors.grey[300],
                                            thickness: 2,
                                          ),
                                          Text(
                                            data['sesi']?['matkul'] == null
                                                ? "  "
                                                : "( ${data['sesi']?['matkul']} )",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(data['sesi']?['date'] == null
                                              ? "jam : -"
                                              : "jam : ${DateFormat.jms().format(DateTime.parse(data['sesi']!['date']))}"),
                                          Text(
                                            data['sesi']?['date'] == null
                                                ? "Status : -  "
                                                : "Status : ${data['sesi']?['status']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      })
                ],
              );
            } else {
              return Center(
                child: Text("tidak dapat memuat data user"),
              );
            }
          }),
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
