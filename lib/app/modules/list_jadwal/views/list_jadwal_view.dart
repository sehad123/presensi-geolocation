import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../controllers/list_jadwal_controller.dart';
import 'package:intl/intl.dart';

class ListJadwalView extends GetView<ListJadwalController> {
  const ListJadwalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? user = Get.arguments;
    String untuk = "mahasiswa";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Jadwal Anda'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilterDropdown(),
              ],
            ),
          ),
          Expanded(
            child: GetBuilder<ListJadwalController>(
              builder: (c) => Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.filteredJadwal.isEmpty) {
                  return SizedBox(
                    height: 150,
                    child: Center(
                      child: Text("Jadwal tidak ditemukan "),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  itemCount: controller.filteredJadwal.length,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data =
                        controller.filteredJadwal[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Material(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () {
                            if (user?['role'] == 'admin') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Pilih Aksi"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Get.toNamed(
                                            Routes.DETAIL_JADWAL,
                                            arguments: {
                                              "data": data,
                                              "data2": user
                                            },
                                          );
                                        },
                                        child: Text("Detail Jadwal"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Get.toNamed(Routes.EDIT_JADWAL,
                                              arguments: data);
                                        },
                                        child: Text("Ubah Jadwal"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          controller.deleteJadwal(data['uid']);
                                        },
                                        child: Text("Hapus Jadwal"),
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
                            } else {
                              Get.toNamed(
                                Routes.DETAIL_JADWAL,
                                arguments: {"data": data, "data2": user},
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            // margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    getFormattedDate(data?['hari']),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                    Text(
                                      "${data?['matkul']}",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                if (user?['role'] != 'dosen' &&
                                    user?['role'] != 'admin')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Dosen : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("${data?['dosen']}",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13))
                                    ],
                                  ),
                                if (user?['role'] == 'dosen')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Kelas : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("${data?['kelas']}",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13))
                                    ],
                                  ),
                                if (user?['role'] == 'admin')
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Kelas : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("${data?['kelas']}",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Dosen : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("${data?['dosen']}",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13))
                                        ],
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ruangan : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${data?['ruangan']}",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13))
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Jam : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        "${data?['jam_mulai'].toString()}.${data?['menit_mulai'].toString()} - ${data?['jam_akhir'].toString()}.${data?['menit_akhir'].toString()}",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13))
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
          if (user?['role'] == 'admin')
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
                    onPressed: () =>
                        Get.toNamed(Routes.ADD_JADWAL, arguments: untuk),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Function to format the date
  String getFormattedDate(String? day) {
    if (day != null) {
      DateTime now = DateTime.now();
      switch (day) {
        case 'Senin':
          return "Senin ${DateFormat('d MMMM yyyy').format(now)}";
        case 'Selasa':
          return "Selasa ${DateFormat('d MMMM yyyy').format(now.add(Duration(days: 1)))}";
        case 'Rabu':
          return "Rabu ${DateFormat('d MMMM yyyy').format(now.add(Duration(days: 2)))}";
        case 'Kamis':
          return "Kamis ${DateFormat('d MMMM yyyy').format(now.add(Duration(days: 3)))}";
        case 'Jumat':
          return "Jumat ${DateFormat('d MMMM yyyy').format(now.add(Duration(days: 4)))}";
        default:
          return "Hari tidak valid";
      }
    }
    return "Hari tidak valid";
  }
}

class FilterDropdown extends StatefulWidget {
  @override
  _FilterDropdownState createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  late String selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = Get.find<ListJadwalController>().selectedDay.value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedDay,
      hint: Text('Pilih Hari'),
      items: ['hari', 'Semua', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newSelectedDay) {
        if (newSelectedDay != null) {
          setState(() {
            selectedDay = newSelectedDay;
          });
          Get.find<ListJadwalController>().filterJadwalByDay(newSelectedDay);
        }
      },
    );
  }
}
