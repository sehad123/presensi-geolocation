import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/list_absen_mahasiswa_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

import 'package:intl/intl.dart';

class ListAbsenMahasiswaView extends GetView<ListAbsenMahasiswaController> {
  const ListAbsenMahasiswaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data2 = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Presensi'),
        centerTitle: true,
      ),
      body: GetBuilder<ListAbsenMahasiswaController>(
        builder: (c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: controller.getAllPresensi(data2['uid']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data?.docs.length == 0 || snapshot.data == null) {
                return SizedBox(
                  height: 150,
                  child: Center(
                    child: Text("Belum ada history presensi"),
                  ),
                );
              }
              return ListView.builder(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  itemCount: snapshot.data!.docs.length,
                  physics: AlwaysScrollableScrollPhysics(),
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
                            Get.toNamed(
                              Routes.UPDATE_MAHASISWA,
                              arguments: {"data": data, "data2": data2},
                            );
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "Sesi 1",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(data['masuk']?['date'] == null
                                    ? "jam absen : -"
                                    : "jam absen : ${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}"),
                                Text(
                                  "status : ${data['masuk']?['status']}",
                                ),
                                Text(
                                  "Jarak : ${data['masuk']?['jarak'].toString().split(".").first} meter",
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Sesi 2",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(data['keluar']?['date'] == null
                                    ? "jam absen : -"
                                    : "jam absen : ${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}"),
                                Text(
                                  data['keluar']?['status'] == null
                                      ? "Status : -"
                                      : "status : ${data['keluar']?['status']}",
                                ),
                                Text(
                                  data['keluar']?['jarak'] == null
                                      ? "Jarak : -"
                                      : "Jarak : ${data['keluar']?['jarak'].toString().split(".").first} meter",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(Dialog(
            child: Container(
              height: 400,
              padding: EdgeInsets.all(20),
              child: SfDateRangePicker(
                monthViewSettings:
                    DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                selectionMode: DateRangePickerSelectionMode.range,
                showActionButtons: true,
                onCancel: () => Get.back(),
                onSubmit: (obj) {
                  if (obj != null) {
                    if ((obj as PickerDateRange).endDate != null) {
                      controller.pickDate(obj.startDate!, obj.endDate!);
                    }
                  }
                },
              ),
            ),
          ));
        },
        child: Icon(Icons.format_list_bulleted_rounded),
      ),
    );
  }
}
