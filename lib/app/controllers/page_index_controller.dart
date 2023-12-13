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
          Get.snackbar(" Lokasi anda saat ini",
              "${placemark[0].subLocality},${placemark[0].locality}");
// address stis = -6.2311945,106.8670893
          // cek jarak diantara 2 posisi
          double jarak = Geolocator.distanceBetween(
              -6.2311945, 106.8670893, position.latitude, position.longitude);

          // presensi
          await presensi(position, address, jarak);
        } else {
          Get.snackbar("ERROR", dataResponse['message']);
        }
        print("Asben BERHASiL ");

        break;
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(Position position, String address, double jarak) async {
    //
    String uid = auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> collectionReference =
        await firebaseFirestore
            .collection("mahasiswa")
            .doc(uid)
            .collection("presensi");
    QuerySnapshot<Map<String, dynamic>> snappresence =
        await collectionReference.get();

    DateTime now = DateTime.now();
    String todayDocId = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di luar area";
    if (jarak <= 200) {
      // didalam area kampus
      status = "Di Dalam area kampus";
    } else {
      Get.snackbar("TIDAK BISA ABSEN", "ANDA BERADA DI LUAR KAMPUS");
    }

    if (snappresence.docs.length == 0) {
      // belum pernah absen & set absen masuk pertama kalinya
      await Get.defaultDialog(
        title: "Peringatan",
        middleText: "Apakah kamu yakin akan mengisi daftar hadir sekarang ?",
        actions: [
          OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel")),
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
                    "jarak": jarak,
                  }
                });
                Get.back();
                Get.snackbar("berhasil", "ABSEN BERHASIL");
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
          Get.snackbar("PERINGATAN",
              "Kamu telah absen masuk & keluar. tidak dapat absen lagi dan tunggu besok");
        } else {
          // absen keluar
          await Get.defaultDialog(
            title: "Peringatan",
            middleText:
                "Apakah kamu yakin akan mengisi absen keluar sekarang ?",
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    await collectionReference.doc(todayDocId).update({
                      "keluar": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "jarak": jarak,
                      }
                    });
                    Get.back();
                    Get.snackbar("berhasil", "ABSEN BERHASIL");
                    Get.back();
                  },
                  child: Text("Iya"))
            ],
          );
        }
      } else {
        await Get.defaultDialog(
          title: "Peringatan",
          middleText: "Apakah kamu yakin akan mengisi daftar hadir sekarang ?",
          actions: [
            OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Cancel")),
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
                    }
                  });
                  Get.back();
                  Get.snackbar("berhasil", "ABSEN BERHASIL");
                },
                child: Text("Iya"))
          ],
        );
        // absen masuk
      }
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
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {"message": "Hidupkan GPS anda", "error": true};

      // Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {"message": "izin menggunakan GPS ditolak.", "error": true};
        // Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "settingan hp kamu tidak mengijinkan untuk mengakses GPS, ubah settingan hp kamu",
        "error": true
      };

      //  Future.error(
      // 'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device",
      "error": false
    };
  }
}
