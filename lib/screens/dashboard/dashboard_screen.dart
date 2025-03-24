import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:loccar_agency/utils/constants.dart';

import 'package:loccar_agency/widgets/main_drawer.dart';

import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final ZoomDrawerController z = ZoomDrawerController();
  int currentIndex = 0;
  int currentTab = 0;

  List<Widget> screens = const [HomeScreen(), Center(), HomeScreen()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        controller: z,
        borderRadius: 24,
        style: DrawerStyle.defaultStyle,
        showShadow: true,
        openCurve: Curves.fastOutSlowIn,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        duration: const Duration(milliseconds: 500),
        angle: 0.0,
        menuBackgroundColor: Constants.primaryColor,
        menuScreen: DrawerScreen(
          setIndex: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        mainScreen: screens[currentTab],
      ),
    );
  }
}
