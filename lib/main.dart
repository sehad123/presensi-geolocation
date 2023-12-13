import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi/app/controllers/page_index_controller.dart';
import 'package:presensi/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// convex button
  final pageC = Get.put(PageIndexController(), permanent: true);
  runApp(
    StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          print(snapshot.data);
          return GetMaterialApp(
            title: "Application",
            // session
            initialRoute: snapshot.data != null ? Routes.LOGIN : Routes.LOGIN,
            getPages: AppPages.routes,
          );
        }),
  );
}
