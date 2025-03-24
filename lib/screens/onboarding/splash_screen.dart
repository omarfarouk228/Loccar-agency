import 'dart:async';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loccar_agency/screens/auth/login_screen.dart';
import 'package:loccar_agency/utils/assets.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/preferences.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 4000), () {
      _checkData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        bottomNavigationBar: Container(
          height: height * 0.15,
          alignment: Alignment.center,
          child: const Column(
            children: [
              Text(
                "Chargement en cours",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              SpinKitFadingCube(
                color: Colors.white,
                size: 40.0,
              )
            ],
          ),
        ),
        backgroundColor: Constants.primaryColor,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(height: height * 0.6),
            // headerWidget(height: height * 0.55),
            Positioned(
                bottom: height * 0.15,
                child: SizedBox(
                  width: 200,
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage(AppAssets.logoWithBlueBackground),
                          fit: BoxFit.cover,
                        )),
                  ),
                ))
          ],
        ));
  }

  _checkData() async {
    Future<int> stepAuth = SharedPreferencesHelper.getIntValue("step_auth");

    stepAuth.then((int value) async {
      if (value == 0) {
        int onboardingSeen =
            await SharedPreferencesHelper.getIntValue("onboarding_seen");
        if (onboardingSeen == 1) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const LoginScreen();
          }));
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const OnBoardingScreen();
          }));
        }
      }
    });
  }

  headerWidget({required double height}) {
    return Container(
      height: height,
      //color: Constants.primaryColor,
      padding: EdgeInsets.only(top: height * 0.2),
      alignment: Alignment.topCenter,
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 250);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 250);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
