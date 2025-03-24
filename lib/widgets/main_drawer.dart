import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:loccar_agency/screens/auth/login_screen.dart';
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/preferences.dart';

class DrawerScreen extends StatefulWidget {
  final ValueSetter setIndex;
  const DrawerScreen({Key? key, required this.setIndex}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.primaryColor,
        body: Padding(
            padding: const EdgeInsets.only(top: 50, left: 10),
            child: ListView(padding: EdgeInsets.zero, children: [
              Row(children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(75.0))),
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 80,
                      )),
                )
              ]),
              const SizedBox(height: 10),
              Text(
                Constants.appName,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(height: 5),
              const Text(
                "Version 1.0.0",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: 14),
              ),
              const SizedBox(height: 20),
              const Text(
                "Mon compte",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  drawerList2(
                      FontAwesomeIcons.car, "Géolocalisations", const Center()),
                  const SizedBox(
                    width: 10,
                  ),
                  drawerList2(
                      FontAwesomeIcons.fileInvoice, "Factures", const Center()),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  drawerList2(
                      FontAwesomeIcons.carBurst, "Locations", const Center()),
                  const SizedBox(
                    width: 10,
                  ),
                  drawerList2(
                      FontAwesomeIcons.carTunnel, "Ventes", const Center()),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Paramètres & Support",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  drawerList2(
                      FontAwesomeIcons.gear, "Paramètres", const Center()),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _shareApp();
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Colors.white24,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: const FaIcon(
                            FontAwesomeIcons.shareNodes,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                            height: 25,
                            alignment: Alignment.topCenter,
                            child: const Text(
                              "Partager",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _showLogoutDialog("Déconnexion",
                      "Êtes-vous sûr de deconnecter votre compte ?");
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.lock,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Déconnexion",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ])));
  }

  Widget drawerList(String icon, String name, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Image.asset(
              icon,
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(height: 5),
          Container(
              height: 25,
              alignment: Alignment.topCenter,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              )),
        ],
      ),
    );
  }

  Widget drawerList2(IconData icon, String name, Widget screen) {
    return GestureDetector(
      onTap: () {
        ZoomDrawer.of(context)!.close();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: FaIcon(
              icon,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Container(
              height: 25,
              alignment: Alignment.topCenter,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              )),
        ],
      ),
    );
  }

  void _shareApp() {
    Share.share(
      (Platform.isAndroid)
          ? "Télécharger notre application via ce lien : https://play.google.com/store/apps/details?"
          : "Télécharger notre application via ce lien : https://apps.apple.com/app/",
      subject: "Partager SOGENUVO",
    );
  }

  void _showLogoutDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      left: 10, top: 20 + 20, right: 10, bottom: 10),
                  margin: const EdgeInsets.only(top: 47),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 10),
                            blurRadius: 10),
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        content,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: const Text('Non',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Constants.secondaryColor,
                              ),
                              child: const Text('Oui',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                SharedPreferencesHelper.setIntValue(
                                    "step_auth", 0);

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (Route<dynamic> route) => false);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40)),
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 60,
                        )),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
