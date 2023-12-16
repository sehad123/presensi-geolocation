import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ListAbsenMahasiswaController extends GetxController {
  DateTime? start;
  DateTime end = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPresensi(String uid) async {
    if (start == null) {
      // get seluruh presensi sampai saat ini
      return await firestore
          .collection("mahasiswa")
          .doc(uid)
          .collection("presensi")
          .where("date", isLessThan: end.toIso8601String())
          .orderBy("date", descending: true)
          .get();
    } else {
      return await firestore
          .collection("mahasiswa")
          .doc(uid)
          .collection("presensi")
          .where("date", isGreaterThan: start!.toIso8601String())
          .where("date",
              isLessThan: end.add(Duration(days: 1)).toIso8601String())
          .orderBy("date", descending: true)
          .get();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser(String uid) {
    return firestore.collection("mahasiswa").doc(uid).snapshots();
  }

  void pickDate(DateTime pickStart, DateTime pickEnd) {
    start = pickStart;
    end = pickEnd;
    update();
    Get.back();
  }
}
