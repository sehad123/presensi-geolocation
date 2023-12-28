import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  DetailPresensiView({Key? key}) : super(key: key);
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Presensi'),
          centerTitle: true,
        ),
        body: ListView(padding: EdgeInsets.all(20), children: [
          Container(
            padding: EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Text(
                  "${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['date']))}",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['masuk']?['matkul'] != null
                        ? "( ${data['masuk']?['matkul']} )"
                        : " - ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                data['masuk']?['date'] == null
                    ? "Jam : -"
                    : "jam :  ${DateFormat.jms().format(DateTime.parse(data['masuk']['date']))}",
              ),
              Text(
                data['masuk']?['lat'] == null && data['masuk']?['long'] == null
                    ? "Posisi : -"
                    : "Posisi : ${data['masuk']!['lat']}, ${data['masuk']!['long']}",
              ),
              Text(
                data['masuk']?['status'] == null
                    ? "Status : -"
                    : "Status : ${data['masuk']?['status']}",
              ),
              Text(
                data['masuk']?['status'] == null
                    ? "Lokasi Absen : -"
                    : "Lokasi Absen : ${data['masuk']?['address']}",
              ),
              Text(
                data['masuk']?['status'] == null
                    ? "Jarak : -"
                    : "Jarak : ${data['masuk']?['jarak'].toString().split(".").first} meter",
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['keluar']?['matkul'] != null
                        ? "( ${data['keluar']?['matkul']} )"
                        : "- ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                data['keluar']?['date'] == null
                    ? "Jam : -"
                    : "jam : ${DateFormat.jms().format(DateTime.parse(data['keluar']['date']))}",
              ),
              Text(
                data['keluar']?['lat'] == null &&
                        data['keluar']?['long'] == null
                    ? "Posisi : -"
                    : "Posisi : ${data['keluar']!['lat']}, ${data['keluar']!['long']}",
              ),
              Text(
                data['keluar']?['status'] == null
                    ? "Status : -"
                    : "Status : ${data['keluar']?['status']}",
              ),
              Text(
                data['keluar']?['status'] == null
                    ? "Lokasi Absen : -"
                    : "Lokasi Absen : ${data['keluar']?['address']}",
              ),
              Text(
                data['keluar']?['status'] == null
                    ? "Jarak : -"
                    : "Jarak : ${data['keluar']?['jarak'].toString().split(".").first} meter",
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['sesi']?['matkul'] != null
                        ? "( ${data['sesi']?['matkul']} )"
                        : " - ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                data['sesi']?['date'] == null
                    ? "Jam : -"
                    : "Jam : ${DateFormat.jms().format(DateTime.parse(data['sesi']['date']))}",
              ),
              Text(
                data['sesi']?['lat'] == null && data['sesi']?['long'] == null
                    ? "Posisi : -"
                    : "Posisi : ${data['sesi']!['lat']}, ${data['sesi']!['long']}",
              ),
              Text(
                data['sesi']?['status'] == null
                    ? "Status : -"
                    : "Status : ${data['sesi']?['status']}",
              ),
              Text(
                data['sesi']?['status'] == null
                    ? "Lokasi Absen : -"
                    : "Lokasi Absen : ${data['sesi']?['address']}",
              ),
              Text(
                data['sesi']?['status'] == null
                    ? "Jarak : -"
                    : "Jarak : ${data['sesi']?['jarak'].toString().split(".").first} meter",
              ),
            ]),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20)),
          ),
        ]));
  }
}
