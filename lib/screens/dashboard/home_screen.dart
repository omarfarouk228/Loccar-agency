import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/user.dart';
import 'package:loccar_agency/screens/dashboard/accidents/accidents_list_screen.dart';
import 'package:loccar_agency/screens/dashboard/breakdowns/breakdowns_list_screen.dart';
import 'package:loccar_agency/screens/dashboard/cars/cars_list_screen.dart';
import 'package:loccar_agency/screens/dashboard/maintenances/maintenances_list_screen.dart';
import 'package:loccar_agency/screens/dashboard/notifications_screen.dart';
import 'package:loccar_agency/screens/dashboard/owners/owners_list_screen.dart';
import 'package:loccar_agency/screens/dashboard/rents/rents_list_screen.dart';
import 'package:loccar_agency/utils/assets.dart';
import 'package:loccar_agency/utils/colors.dart';
import 'package:badges/badges.dart' as badges;
import 'package:loccar_agency/utils/constants.dart';
import 'package:loccar_agency/utils/dimensions.dart';
import 'package:loccar_agency/utils/preferences.dart';
import 'package:loccar_agency/widgets/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int alertNotifications = 0;
  bool showBalance = true;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getUser());
  }

  void _getUser() async {
    user = await SharedPreferencesHelper.getObject(
        "user", (json) => UserModel.fromJson2(json));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.thirdyColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 5),
          child: Image(
            image: AssetImage(AppAssets.logoWhiteLarge),
            width: 120.0,
          ),
        ),
        backgroundColor: AppColors.thirdyColor,
        centerTitle: true,
        elevation: 0.0,
        leading: const DrawerWidget(),
        actions: [
          Container(
              margin: const EdgeInsets.all(8),
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: alertNotifications > 0
                  ? badges.Badge(
                      badgeContent: Text(
                        alertNotifications.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      badgeStyle: badges.BadgeStyle(
                          badgeColor: AppColors.secondaryColor),
                      position: badges.BadgePosition.topEnd(top: -12, end: -5),
                      child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.bell,
                              size: 20, color: AppColors.primaryColor),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsScreen()),
                            ).then((value) {
                              setState(() {
                                alertNotifications = 0;
                              });
                            });
                          }),
                    )
                  : IconButton(
                      icon: FaIcon(FontAwesomeIcons.bell,
                          size: 20, color: AppColors.primaryColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationsScreen()),
                        ).then((value) {
                          setState(() {
                            alertNotifications = 0;
                          });
                        });
                      }))
        ],
      ),
      body: SizedBox(
        height: Dimensions.getScreenHeight(context),
        child: Stack(
          children: [
            Container(
              height: Dimensions.getScreenHeight(context) * 0.15,
              color: AppColors.thirdyColor,
            ),
            Positioned(
              right: 20,
              left: 20,
              top: 20,
              child: SizedBox(
                height: Dimensions.getScreenHeight(context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      user != null
                          ? Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Bienvenue,',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          user!.responsibleFullName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        showBalance
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    user!.balance.toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                      fontFamily: Constants
                                                          .secondFontFamily,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Dimensions.horizontalSpacer(
                                                      5),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: Text(
                                                      'F CFA',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                '*********',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontFamily: Constants
                                                      .secondFontFamily,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showBalance = !showBalance;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Solde du compte',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Dimensions.horizontalSpacer(10),
                                              Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  alignment: Alignment.center,
                                                  child: FaIcon(
                                                    !showBalance
                                                        ? FontAwesomeIcons.eye
                                                        : FontAwesomeIcons
                                                            .eyeSlash,
                                                    color: Colors.white,
                                                    size: 10,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        icon: Icon(Icons.add,
                                            color: AppColors.primaryColor),
                                        onPressed: () {},
                                      ),
                                    )
                                  ],
                                ),
                              ))
                          : Container(),

                      Dimensions.verticalSpacer(10),
                      // Statistics Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard('35', 'Propriétaires',
                              FontAwesomeIcons.users, AppColors.primaryColor,
                              topLeftRadius: 10, bottomLeftRadius: 10),
                          _buildStatCard('73', 'Véhicules',
                              FontAwesomeIcons.car, AppColors.secondaryColor),
                          _buildStatCard('28', 'Locations',
                              FontAwesomeIcons.rotateRight, Colors.green,
                              topRightRadius: 10, bottomRightRadius: 10),
                        ],
                      ),

                      // Dashboard Grid
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: [
                            _buildDashboardCard(
                                'Gestion des propriétaires',
                                AppAssets.ownersIcon,
                                Colors.purple,
                                0,
                                const OwnersListScreen()),
                            _buildDashboardCard(
                                'Gestion des Voitures',
                                AppAssets.carsIcon,
                                Colors.blue,
                                0,
                                const CarsListScreen()),
                            _buildDashboardCard(
                                'Gestion des locations',
                                AppAssets.rentsIcon,
                                Colors.red,
                                0,
                                const RentsListScreen()),
                            _buildDashboardCard(
                                'Gestion des accidents',
                                AppAssets.accidentsIcon,
                                Colors.red,
                                0,
                                const AccidentsListScreen()),
                            _buildDashboardCard(
                                'Gestion des pannes',
                                AppAssets.breakdownsIcon,
                                Colors.green,
                                0,
                                const BreakdownsListScreen()),
                            _buildDashboardCard(
                                'Gestion de maintenances',
                                AppAssets.maintenanceIcon,
                                Colors.green,
                                0,
                                const MaintenancesListScreen()),
                          ],
                        ),
                      ),

                      Dimensions.verticalSpacer(200),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color,
      {double topRightRadius = 0,
      double bottomRightRadius = 0,
      double topLeftRadius = 0,
      double bottomLeftRadius = 0}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRadius),
              topRight: Radius.circular(topRightRadius),
              bottomLeft: Radius.circular(bottomLeftRadius),
              bottomRight: Radius.circular(bottomRightRadius)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(icon, color: Colors.white, size: 12),
                        Dimensions.horizontalSpacer(5),
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String iconPath, Color color,
      int notifications, Widget screen) {
    return badges.Badge(
        badgeContent: Text(
          "$notifications",
          style: const TextStyle(color: Colors.white),
        ),
        showBadge: notifications > 0,
        badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.red, padding: EdgeInsets.all(8)),
        position: badges.BadgePosition.topEnd(top: -10, end: -5),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => screen));
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    // colorFilter: const ColorFilter.mode(
                    //   AppColors.colorBlack,
                    //   BlendMode.srcIn,
                    // ),
                    width: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
