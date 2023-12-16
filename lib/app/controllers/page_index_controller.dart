import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    print('index $i');
    switch (i) {
      case 1:
        print("Asben");
        Map<String, dynamic> dataResponse = await _determinePosition();
        if (dataResponse['error'] != true) {
          Position position = dataResponse['position'];
          List<Placemark> placemark = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          String address =
              "${placemark[0].subLocality}, ${placemark[0].locality}";
          // "${placemark[0].name},${placemark[0].subLocality},${placemark[0].locality}";

          await updatePosition(position, address);

          double jarak = Geolocator.distanceBetween(
              -6.2311945, 106.8670893, position.latitude, position.longitude);
          DateTime now = DateTime.now();
          int currentHour = now.hour;
          // presensi
          if (currentHour < 7 || currentHour > 18) {
            showErrorDialog("ERROR",
                "anda tidak bisa melakukan presensi di luar jam kerja ");
          } else if (now.weekday == DateTime.saturday ||
              now.weekday == DateTime.sunday) {
            showErrorDialog("TIDAK BISA ABSEN", "Hari ini adalah hari libur");
          } else {
            await presensi(position, address, jarak);
          }
        } else {
          showErrorDialog("ERROR", dataResponse['message']);
        }
        print("Asben BERHASiL ");
        // showSuccessDialog("berhasil", "ABSEN BERHASIL");

        break;
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(Position position, String address, double jarak) async {
    String uid = auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> collectionReference =
        await firebaseFirestore
            .collection("mahasiswa")
            .doc(uid)
            .collection("presensi");

    // String status = "Di luar area";

    if (jarak <= 50000) {
      // didalam area kampus

      // Absensi sesuai kondisi di atas
      QuerySnapshot<Map<String, dynamic>> snappresence =
          await collectionReference.get();
      DateTime now = DateTime.now();
      String todayDocId = DateFormat.yMd().format(now).replaceAll("/", "-");

      if (snappresence.docs.length == 0) {
        // belum pernah absen & set absen masuk pertama kalinya
        await Get.defaultDialog(
          title: "Peringatan",
          middleText:
              "Apakah kamu yakin akan mengisi daftar hadir pertama sekarang ?",
          actions: [
            OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Cancel")),
            ElevatedButton(
                onPressed: () async {
                  DateTime now = DateTime.now();
                  int currentHour = now.hour;
                  int currentMinute = now.minute;
                  // presensi
                  if (currentHour == 7 &&
                      currentMinute >= 0 &&
                      currentMinute <= 30) {
                    await collectionReference.doc(todayDocId).set({
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": "Hadir",
                        "jarak": jarak,
                      }
                    });
                    Get.back();
                    showSuccessDialog("BERHASIL", "Anda berhasil absen");
                  } else if (currentHour == 7 &&
                      currentMinute > 30 &&
                      currentHour <= 8) {
                    await collectionReference.doc(todayDocId).set({
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": "Terlambat",
                        "jarak": jarak,
                      }
                    });
                    Get.back();
                    showWarningDialog("WARNING", "Anda terlambat absen");
                  } else {
                    await collectionReference.doc(todayDocId).set({
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": "Tidak Hadir",
                        "jarak": jarak,
                      }
                    });
                    Get.back();
                    showWarningDialog("WARNING",
                        "Anda absen diluar jam ketentuan jadi dianggap Tidak Hadir harap lapor ke BAAK");
                  }
                },
                child: Text("Iya"))
          ],
        );
      } else {
        //  sudah pernah absen -> cek hari ini apakah udah absen masuk / keluar
        DocumentSnapshot<Map<String, dynamic>> todayDoc =
            await collectionReference.doc(todayDocId).get();
        if (todayDoc.exists == true) {
          //  tinggal absen keluar / sudah absen masuk & keluar
          Map<String, dynamic>? dataPresensiToday = todayDoc.data();
          if (dataPresensiToday?['keluar'] != null) {
            //  sudah absen masuk & keluar
            showErrorDialog("PERINGATAN",
                "Kamu telah absen masuk & pulang. tidak dapat absen lagi dan tunggu besok");
          } else {
            // absen keluar
            await Get.defaultDialog(
              title: "Peringatan",
              middleText:
                  "Apakah kamu yakin akan mengisi absen Pulang sekarang ?",
              actions: [
                OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Cancel")),
                ElevatedButton(
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      int currentHour = now.hour;
                      int currentMinute = now.minute;
                      if (currentHour < 15) {
                        Get.back();
                        showWarningDialog(
                            "WARNING", "anda belum bisa absen pulang sekarang");
                      } else if (currentHour == 15 &&
                          currentMinute > 0 &&
                          currentHour <= 16) {
                        await collectionReference.doc(todayDocId).update({
                          "keluar": {
                            "date": now.toIso8601String(),
                            "lat": position.latitude,
                            "long": position.longitude,
                            "address": address,
                            "status": "hadir",
                            "jarak": jarak,
                          }
                        });
                        Get.back();
                        showSuccessDialog(
                            "berhasil", "Anda berhasil absen pulang");
                      } else if (currentHour > 16) {
                        Get.back();
                        showErrorDialog("WARNING",
                            "anda absen diluar jam kerja harap besok besok jangan lupa absen pulang");
                        await collectionReference.doc(todayDocId).update({
                          "keluar": {
                            "date": now.toIso8601String(),
                            "lat": position.latitude,
                            "long": position.longitude,
                            "address": address,
                            "status": "hadir",
                            "jarak": jarak,
                          }
                        });
                      }
                    },
                    child: Text("Iya"))
              ],
            );
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
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    int currentHour = now.hour;
                    int currentMinute = now.minute;
                    // presensi
                    if (currentHour == 7 &&
                        currentMinute >= 0 &&
                        currentMinute <= 30) {
                      await collectionReference.doc(todayDocId).set({
                        "date": now.toIso8601String(),
                        "masuk": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": "hadir",
                          "jarak": jarak,
                        }
                      });
                      Get.back();
                      showSuccessDialog(
                          "BERHASUK", "Anda berhasil melakukan absen");
                      Get.back();
                    } else if (currentHour == 7 &&
                        currentMinute > 30 &&
                        currentHour <= 8) {
                      await collectionReference.doc(todayDocId).set({
                        "date": now.toIso8601String(),
                        "masuk": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": "terlambat",
                          "jarak": jarak,
                        }
                      });
                      Get.back();
                      showWarningDialog("WARNING", "Anda terlambat absen");
                    } else {
                      await collectionReference.doc(todayDocId).set({
                        "date": now.toIso8601String(),
                        "masuk": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": "tidak hadir",
                          "jarak": jarak,
                        }
                      });
                      Get.back();
                      showWarningDialog("WARNING",
                          "anda dianggap tidak hadir segera lapor ke BAAK");
                    }
                  },
                  child: Text("Iya"))
            ],
          );
          // absen masuk
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
