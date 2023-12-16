import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          child: Text(
            "Selamat datang di SIPADU ",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _init();
  }

  Future<void> _init() async {
    // Menunggu durasi splash screen (dalam contoh ini, 3 detik)
    await Future.delayed(Duration(seconds: 3));

    // Pindah ke rute home jika pengguna sudah login
    if (FirebaseAuth.instance.currentUser != null) {
      Get.offAllNamed(
          Routes.HOME); // Sesuaikan dengan rute home yang Anda gunakan
    } else {
      // Jika pengguna belum login, pindah ke rute login
      Get.offAllNamed(
          Routes.LOGIN); // Sesuaikan dengan rute login yang Anda gunakan
    }
  }
}
