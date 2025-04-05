import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:loccar_agency/packages/elegant_nav_bar.dart';
import 'package:loccar_agency/screens/dashboard/history_screen.dart';
import 'package:loccar_agency/screens/dashboard/profile_screen.dart';
import 'package:loccar_agency/screens/dashboard/transactions_screen.dart';
import 'package:loccar_agency/services/rent_service_notification.dart';
import 'package:loccar_agency/utils/assets.dart';
import 'package:loccar_agency/utils/colors.dart' as loccar_app;

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
  final RentNotificationService _rentService = RentNotificationService();

  List<Widget> screens = const [
    HomeScreen(),
    HistoryScreen(),
    TransactionsScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    _checkRents();
  }

  Future<void> _checkRents() async {
    await _rentService.checkForNewRents();
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
          menuBackgroundColor: loccar_app.AppColors.primaryColor,
          menuScreen: DrawerScreen(
            setIndex: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          mainScreen: screens[currentIndex],
        ),
        bottomNavigationBar: ElegantBottomNavigationBar(
          backgroundColor: loccar_app.AppColors.primaryColor,
          indicatorColor: Colors.white,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedLabelStyle: const TextStyle(color: Colors.white),
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            NavigationItem(label: 'Accueil', icon: AppAssets.homeIcon),
            NavigationItem(label: 'Historique', icon: AppAssets.historyIcon),
            NavigationItem(
                label: 'Transactions', icon: AppAssets.transactionsIcon),
            NavigationItem(
                label: 'Mon compte',
                iconWidget: const CircleAvatar(
                  backgroundImage: AssetImage(AppAssets.defaultAvatar),
                )),
          ],
        ));
  }
}
