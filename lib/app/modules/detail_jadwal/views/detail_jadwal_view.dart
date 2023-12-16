import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';
import '../controllers/detail_jadwal_controller.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

final DetailJadwalController controller = Get.find<DetailJadwalController>();
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class DetailJadwalView extends StatefulWidget {
  const DetailJadwalView({Key? key}) : super(key: key);

  @override
  _DetailJadwalViewState createState() => _DetailJadwalViewState();
}

class _DetailJadwalViewState extends State<DetailJadwalView> {
  final ValueNotifier<int> imageNotifier = ValueNotifier<int>(0);
  bool buttonClicked = false;
  bool absenLoading = false;
  bool izinLoading = false;
  DateTime? lastPresensiTime;
  bool jeda = false;
  DateTime now = DateTime.now();
  int currentHour = DateTime.now().hour;
  int currentMinute = DateTime.now().minute;

  final Map<String, dynamic>? data = Get.arguments?["data"];
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? user2 = Get.arguments?["data2"];
    String mapToIndonesianDay(int day) {
      switch (day) {
        case DateTime.monday:
          return 'Senin';
        case DateTime.tuesday:
          return 'Selasa';
        case DateTime.wednesday:
          return 'Rabu';
        case DateTime.thursday:
          return 'Kamis';
        case DateTime.friday:
          return 'Jumat';
        case DateTime.saturday:
          return 'Sabtu';
        case DateTime.sunday:
          return 'Minggu';
        default:
          return '';
      }
    }

    if (data == null || data?['uid'] == null) {
      return Scaffold(
        body: Center(
          child: Text("Error: User data is missing"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Jadwal'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(data?['uid']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            Map<String, dynamic> user = snapshot.data!.data()!;

            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Center(
                  child: Text(
                    getFormattedDate(data?['hari']),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 14),
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text("Matkul = ${data?['matkul']} "),
                ),
                SizedBox(height: 14),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(user['role'] == 'dosen'
                      ? "Kelas = ${user['kelas']}"
                      : "Dosen = ${user['dosen']}"),
                ),
                if (user['role'] == 'admin')
                  ListTile(
                    leading: Icon(Icons.code),
                    title: Text("Kode Matkul = ${user['kode']} "),
                  ),
                SizedBox(height: 14),
                ListTile(
                  leading: Icon(Icons.door_front_door),
                  title: Text("Ruangan = ${user['ruangan']}"),
                ),
                SizedBox(height: 14),
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text(
                      "${user['jam_mulai'].toString()}.${user['menit_mulai'].toString()} - ${user['jam_akhir'].toString()}.${user['menit_akhir'].toString()}"),
                ),
                SizedBox(height: 14),
                if (user2?['role'] == 'admin')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => controller.deleteUser(user['uid']),
                        child: Text("Hapus Jadwal"),
                      ),
                    ],
                  ),
                if (user2?['role'] != 'admin')
                  Container(
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              absenLoading = true;
                            });
                            // Get.offAllNamed(Routes.HOME);
                            String mapToIndonesianDay(int day) {
                              switch (day) {
                                case DateTime.monday:
                                  return 'Senin';
                                case DateTime.tuesday:
                                  return 'Selasa';
                                case DateTime.wednesday:
                                  return 'Rabu';
                                case DateTime.thursday:
                                  return 'Kamis';
                                case DateTime.friday:
                                  return 'Jumat';
                                case DateTime.saturday:
                                  return 'Sabtu';
                                case DateTime.sunday:
                                  return 'Minggu';
                                default:
                                  return '';
                              }
                            }

                            if (!buttonClicked) {
                              DateTime attendanceStartTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  int.parse(data?['jam_mulai']),
                                  int.parse(data?['menit_mulai']));
                              DateTime attendanceEndTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  int.parse(data?['jam_mulai']),
                                  int.parse(data?['menit_mulai']) + 15);

                              DateTime attendanceTelatTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  int.parse(data?['jam_mulai']),
                                  int.parse(data?['menit_mulai']) + 40);
                              DateTime attendanceTidakHadirTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  int.parse(data?['jam_mulai']) + 2,
                                  int.parse(data?['menit_mulai']) + 50);

                              String dayName = mapToIndonesianDay(now.weekday);
                              // if (dayName == data?['hari'])
                              if (dayName == "${data?['hari']}") {
                                if (now.isAfter(attendanceStartTime) &&
                                    now.isBefore(attendanceEndTime)) {
                                  absen("hadir", "",
                                      int.parse(data?['jam_mulai']));
                                } else if (now.isAfter(attendanceStartTime) &&
                                    now.isBefore(attendanceTelatTime)) {
                                  absen("terlambat ", "",
                                      int.parse(data?['jam_mulai']));
                                } else if (now.isAfter(attendanceTelatTime) &&
                                    now.isBefore(attendanceTidakHadirTime)) {
                                  absen("tidak hadir", "",
                                      int.parse(data?['jam_mulai']));
                                } else {
                                  showErrorDialog("ERROR",
                                      "Anda belum bisa melakukan presensi ");
                                }
                              } else {
                                showErrorDialog("Gagal",
                                    "Absen Matkul ${data?['matkul']} hanya bisa dilakukan di hari ${data?['hari']}");
                              }
                            } else {
                              showErrorDialog("Perhatian",
                                  "Anda sudah melakukan presensi sebelumnya.");
                            }
                          },
                          child: absenLoading
                              ? CircularProgressIndicator(
                                  // Atur warna
                                  )
                              : Text("Absen"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              izinLoading = true;
                            });
                            if (!buttonClicked) {
                              DateTime attendanceStartTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  int.parse(data?['jam_mulai']),
                                  int.parse(data?['menit_mulai']));
                              DateTime attendanceIzinTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  int.parse(data?['jam_akhir']),
                                  int.parse(data?['menit_akhir']));
                              String dayName = mapToIndonesianDay(now.weekday);
                              // if (dayName == data?['hari'])
                              if (dayName == "${data?['hari']}") {
                                if (now.isAfter(attendanceStartTime) &&
                                    now.isBefore(attendanceIzinTime)) {
                                  await _showIzinDialog(context);
                                } else {
                                  showErrorDialog("Gagal",
                                      "Anda tidak bisa melakukan Izin diluar jam mata kuliah harap lapor ke BAAK");
                                }
                              } else {
                                showErrorDialog("Gagal",
                                    "Izin Matkul ${data?['matkul']} hanya bisa dilakukan di hari ${data?['hari']}");
                              }
                            } else {
                              showErrorDialog("Perhatian",
                                  "Anda sudah melakukan izin sebelumnya.");
                            }
                          },
                          child: izinLoading
                              ? CircularProgressIndicator(
                                  value:
                                      null, // Atur ke null untuk memulai putaran tanpa batas
                                  strokeWidth: 5.0, // Atur lebar garis
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue), // Atur warna
                                )
                              : Text("Izin"),
                        ),
                      ],
                    ),
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

  Future<void> _showIzinDialog(BuildContext context) async {
    TextEditingController alasanController = TextEditingController();
    XFile? imageFile;

    Future<void> _pickImage() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        imageFile = XFile(pickedFile.path);
        imageNotifier.value++;
      }
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return IzinDialog(
          alasanController: alasanController,
          imageFile: imageFile,
          imageNotifier: imageNotifier,
          pickImage: _pickImage,
          onSubmitted: () {
            String alasan = alasanController.text;
            Navigator.of(context).pop();
            absen("izin", alasan, int.parse(data?['jam_mulai']));
            // showSuccessDialog("Selamat", "Anda berhasil melakukan Izin");
          },
        );
      },
    );
  }

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

  void absen(String status, String alasan, int jam) async {
    Map<String, dynamic> dataResponse = await _determinePosition();
    if (dataResponse['error'] != true) {
      Position position = dataResponse['position'];
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String address = "${placemark[0].subLocality}, ${placemark[0].locality}";

      await updatePosition(position, address);

      double jarak = Geolocator.distanceBetween(
          -6.2311945, 106.8670893, position.latitude, position.longitude);
      DateTime now = DateTime.now();
      int currentHour = now.hour;

      // presensi
      if (currentHour < 6 || currentHour > 18) {
        showErrorDialog(
            "ERROR", "Anda tidak bisa melakukan presensi di luar jam kerja ");
      } else {
        if (!jeda) {
          await presensi(position, address, jarak, status, alasan, jam);
          lastPresensiTime = DateTime.now();
          jeda = true;
        } else {
          showErrorDialog("ERROR",
              "Anda tidak bisa melakukan presensi dalam jeda waktu yang ditentukan.");
        }
      }
    } else {
      showErrorDialog("ERROR", dataResponse['message']);
    }
    print("Asben BERHASIL ");
  }

  Future<void> presensi(Position position, String address, double jarak,
      String status, String alasan, int jam) async {
    String uid = auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> collectionReference =
        await firebaseFirestore
            .collection("mahasiswa")
            .doc(uid)
            .collection("presensi");

    if (jarak <= 50000) {
      QuerySnapshot<Map<String, dynamic>> snappresence =
          await collectionReference.get();
      String todayDocId = DateFormat.yMd().format(now).replaceAll("/", "-");

      if (snappresence.docs.length == 0) {
        await Get.defaultDialog(
          title: "Peringatan",
          middleText:
              "Apakah kamu yakin akan mengisi daftar hadir pertama sekarang ?",
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await collectionReference.doc(todayDocId).set({
                  "date": now.toIso8601String(),
                  "masuk": {
                    "date": now.toIso8601String(),
                    "lat": position.latitude,
                    "long": position.longitude,
                    "address": address,
                    "status": status,
                    "matkul": data?['matkul'],
                    "jarak": jarak,
                    "alasan_izin": alasan,
                    "jam": now.hour, // Tambahkan jam ke data masuk
                  }
                });
                lastPresensiTime = now;
                Get.offAllNamed(Routes.HOME);
                showSuccessDialog("BERHASIL", "status anda ${status}");
              },
              child: Text("Iya"),
            )
          ],
        );
      } else {
        DocumentSnapshot<Map<String, dynamic>> todayDoc =
            await collectionReference.doc(todayDocId).get();
        if (todayDoc.exists == true) {
          Map<String, dynamic>? dataPresensiToday = todayDoc.data();
          if (dataPresensiToday?['sesi'] != null) {
            showErrorDialog("PERINGATAN",
                "Kamu telah absen semua mata kuliah di hari ini tunggu besok lagi");
          } else {
            if (dataPresensiToday?['keluar'] != null) {
              await Get.defaultDialog(
                title: "Peringatan",
                middleText: "Apakah kamu yakin akan mengisi absen sekarang ?",
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      int jamMasuk = dataPresensiToday?['masuk']
                          ['jam']; // Ambil jam masuk dari data yang sudah ada
                      int jamSekarang = now.hour;

                      if (jamSekarang - jamMasuk >= 3) {
                        // Tambahkan logika jeda waktu di sini
                        await collectionReference.doc(todayDocId).update({
                          "sesi": {
                            "matkul": data?['matkul'],
                            "date": now.toIso8601String(),
                            "lat": position.latitude,
                            "long": position.longitude,
                            "address": address,
                            "status": status,
                            "alasan_izin": alasan,
                            "jarak": jarak,
                            "jam": now.hour, // Tambahkan jam ke data sesi
                          }
                        });
                        lastPresensiTime = now;
                        Get.offAllNamed(Routes.HOME);
                        showSuccessDialog("BERHASIL", "status anda ${status}");
                      } else {
                        Get.back();
                        showErrorDialog(
                            "ERROR", "Anda tadi sudah melakukan presensi.");
                      }
                    },
                    child: Text("Iya"),
                  )
                ],
              );
            } else {
              await Get.defaultDialog(
                title: "Peringatan",
                middleText: "Apakah kamu yakin akan mengisi absen sekarang ?",
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      int jamMasuk = dataPresensiToday?['masuk']
                          ['jam']; // Ambil jam masuk dari data yang sudah ada
                      int jamSekarang = now.hour;

                      if (jamSekarang - jamMasuk >= 3) {
                        // Tambahkan logika jeda waktu di sini
                        await collectionReference.doc(todayDocId).update({
                          "keluar": {
                            "matkul": data?['matkul'],
                            "date": now.toIso8601String(),
                            "lat": position.latitude,
                            "long": position.longitude,
                            "address": address,
                            "status": status,
                            "alasan_izin": alasan,
                            "jarak": jarak,
                            "jam": now.hour, // Tambahkan jam ke data keluar
                          }
                        });
                        lastPresensiTime = now;
                        Get.offAllNamed(Routes.HOME);
                        showSuccessDialog("BERHASIL", "status anda ${status}");
                      } else {
                        Get.back();
                        showErrorDialog(
                            "ERROR", "Anda tadi sudah melakukan presensi.");
                      }
                    },
                    child: Text("Iya"),
                  )
                ],
              );
            }
          }
        } else {
          await Get.defaultDialog(
            title: "Peringatan",
            middleText:
                "Apakah kamu yakin akan mengisi daftar hadir sekarang ?",
            actions: [
              OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await collectionReference.doc(todayDocId).set({
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "matkul": data?['matkul'],
                      "jarak": jarak,
                      "alasan_izin": alasan,
                      "jam": now.hour, // Tambahkan jam ke data masuk
                    }
                  });
                  lastPresensiTime = now;
                  Get.offAllNamed(Routes.HOME);
                  showSuccessDialog("BERHASIL", "status anda ${status}");
                },
                child: Text("Iya"),
              )
            ],
          );
        }
      }
    } else {
      showErrorDialog("TIDAK BISA ABSEN",
          "ANDA BERADA DI LUAR KAMPUS dengan jarak ${jarak.toString().split(".").first} meter");
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;
    await firebaseFirestore.collection("mahasiswa").doc(uid).update({
      "position": {"lat": position.latitude, "long": position.longitude},
      "address": address
    });
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {"message": "Hidupkan GPS anda", "error": true};
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {"message": "izin menggunakan GPS ditolak.", "error": true};
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "settingan hp kamu tidak mengijinkan untuk mengakses GPS, ubah settingan hp kamu",
        "error": true
      };
    }

    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device",
      "error": false
    };
  }

  void showErrorDialog(String title, String desc) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.error,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }

  void showSuccessDialog(String title, String desc) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.success,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }

  void showWarningDialog(String title, String desc) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.warning,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }
}

class IzinDialog extends StatelessWidget {
  const IzinDialog({
    Key? key,
    required this.alasanController,
    required this.imageFile,
    required this.imageNotifier,
    required this.pickImage,
    required this.onSubmitted,
  }) : super(key: key);

  final TextEditingController alasanController;
  final XFile? imageFile;
  final ValueNotifier<int> imageNotifier;
  final VoidCallback pickImage;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Izin'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: alasanController,
              decoration: InputDecoration(labelText: 'Alasan Izin'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pilih Foto Bukti Izin'),
            ),
            SizedBox(height: 16),
            ValueListenableBuilder<int>(
              valueListenable: imageNotifier,
              builder: (context, _, __) {
                return (imageFile != null)
                    ? Image.file(
                        File(imageFile!.path),
                        height: 100,
                      )
                    : Container();
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: onSubmitted,
          child: Text('Kirim Izin'),
        ),
      ],
    );
  }
}
