import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/controllers/page_index_controller.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:presensi/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PageIndexController pageC =
      Get.put(PageIndexController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Application",
      home: SplashScreen(),
      getPages: AppPages.routes,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        navigateToNextScreen();
      },
    );
  }

  void navigateToNextScreen() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String initialRoute = currentUser != null ? Routes.HOME : Routes.LOGIN;

    // Get.offAll menangani navigasi ke halaman berikutnya setelah 3 detik
    Get.offAllNamed(initialRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/stis.png', // Ganti dengan path gambar splash Anda
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
