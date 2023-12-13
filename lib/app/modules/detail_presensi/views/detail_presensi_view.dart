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
                height: 20,
              ),
              Text("Masuk", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                "jam : ${DateFormat.jms().format(DateTime.parse(data['masuk']['date']))}",
              ),
              Text(
                "posisi : ${data['masuk']!['lat']}, ${data['masuk']!['long']}",
              ),
              Text(
                "status : ${data['masuk']?['status']}",
              ),
              Text(
                "Alamat : ${data['masuk']?['address']}",
              ),
              Text(
                "Jarak : ${data['masuk']?['jarak'].toString().split(".").first} meter",
              ),
              Text("Keluar", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                data['keluar']?['date'] == null
                    ? "Jam : -"
                    : "jam : ${DateFormat.jms().format(DateTime.parse(data['keluar']['date']))}",
              ),
              Text(
                data['keluar']?['lat'] == null &&
                        data['keluar']?['long'] == null
                    ? "posisi : -"
                    : "posisi : ${data['keluar']!['lat']}, ${data['keluar']!['long']}",
              ),
              Text(
                data['keluar']?['status'] == null
                    ? "status : -"
                    : "status : ${data['keluar']?['status']}",
              ),
              Text(
                data['keluar']?['status'] == null
                    ? "Alamat : -"
                    : "Alamat : ${data['keluar']?['address']}",
              ),
              Text(
                data['keluar']?['status'] == null
                    ? "Jarak : -"
                    : "Jarak : ${data['keluar']?['jarak'].toString().split(".").first} meter",
              ),
            ]),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20)),
          ),
        ]));
  }
}
