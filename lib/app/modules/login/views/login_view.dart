import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  double getSmallerDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;
  double getBigrDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Positioned(
            right: -getSmallerDiameter(context) / 3,
            top: -getSmallerDiameter(context) / 3,
            child: Container(
              width: getSmallerDiameter(context),
              height: getSmallerDiameter(context),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Color(0xFFB226B2), Colors.lightBlue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
          ),
          Positioned(
            left: -getBigrDiameter(context) / 4,
            top: -getBigrDiameter(context) / 4,
            child: Container(
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(left: 30, top: 60),
                  child: Text(
                    "SIPADU STIS",
                    style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 30,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              width: getBigrDiameter(context),
              height: getBigrDiameter(context),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Color(0xFFB226B2), Colors.lightBlue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
          ),
          Positioned(
            right: -getBigrDiameter(context) / 4,
            bottom: -getBigrDiameter(context) / 4,
            child: Container(
                width: getBigrDiameter(context),
                height: getBigrDiameter(context),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[200])),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: Align(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage("assets/images/stis.png"),
                // image: AssetImage("../assets/images/stis.png"),
                width: 120,
                height: 120,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  margin: EdgeInsets.fromLTRB(20, 450, 20, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 25),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller.emailC,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFF4891))),
                            labelText: "Email : ",
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                      TextField(
                        controller: controller.passC,
                        obscureText: true,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.key,
                              color: Colors.blue,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFF4891))),
                            labelText: "Password : ",
                            labelStyle: TextStyle(color: Colors.black)),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.FORGET_PASSWORD),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 20),
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.88,
                        height: 40,
                        child: Container(
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              splashColor: Colors.amber,
                              onTap: () {
                                controller.login();
                              },
                              child: Center(
                                child: Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  colors: [Color(0xFFB226B2), Colors.lightBlue],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
