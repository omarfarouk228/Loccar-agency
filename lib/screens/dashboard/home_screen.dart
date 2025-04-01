import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loccar_agency/models/user.dart';
import 'package:loccar_agency/models/user_stat.dart';
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
  UserStatModel? userStat;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getUserInfos());
  }

  Future<void> _getUserInfos() async {
    user = await SharedPreferencesHelper.getObject(
        "user", (json) => UserModel.fromJson2(json));
    userStat = await SharedPreferencesHelper.getObject(
        "user_stat", (json) => UserStatModel.fromJson(json));

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
                  child: FutureBuilder(
                      future: _getUserInfos(),
                      builder: (context, snapshot) {
                        if (user != null && userStat != null) {
                          return Column(
                            children: [
                              Card(
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
                                              user!.name,
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
                                                        user!.balance
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Dimensions
                                                          .horizontalSpacer(5),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Dimensions.horizontalSpacer(
                                                      10),
                                                  Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white)),
                                                      alignment:
                                                          Alignment.center,
                                                      child: FaIcon(
                                                        !showBalance
                                                            ? FontAwesomeIcons
                                                                .eye
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
                                  )),

                              Dimensions.verticalSpacer(10),
                              // Statistics Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatCard(
                                      userStat!.owners.toString(),
                                      'Propriétaires',
                                      FontAwesomeIcons.users,
                                      AppColors.primaryColor,
                                      const OwnersListScreen(),
                                      topLeftRadius: 10,
                                      bottomLeftRadius: 10),
                                  _buildStatCard(
                                      userStat!.cars.toString(),
                                      'Véhicules',
                                      FontAwesomeIcons.car,
                                      AppColors.secondaryColor,
                                      const CarsListScreen(),
                                      textColor: AppColors.primaryColor),
                                  _buildStatCard(
                                      userStat!.rents.toString(),
                                      'Locations',
                                      FontAwesomeIcons.rotateRight,
                                      Colors.green,
                                      const RentsListScreen(),
                                      topRightRadius: 10,
                                      bottomRightRadius: 10)
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
                                        userStat!.rentsPending,
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
                                        userStat!.breakdowns,
                                        const BreakdownsListScreen()),
                                    _buildDashboardCard(
                                        'Gestion de maintenances',
                                        AppAssets.maintenanceIcon,
                                        Colors.green,
                                        userStat!.maintenances,
                                        const MaintenancesListScreen()),
                                  ],
                                ),
                              ),

                              Dimensions.verticalSpacer(200),
                            ],
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          ));
                        }
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, IconData icon, Color color, Widget screen,
      {double topRightRadius = 0,
      double bottomRightRadius = 0,
      double topLeftRadius = 0,
      double bottomLeftRadius = 0,
      Color textColor = Colors.white}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        },
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
                style: TextStyle(
                  color: textColor,
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
                          FaIcon(icon, color: textColor, size: 12),
                          Dimensions.horizontalSpacer(5),
                          Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: textColor, fontSize: 11),
                          ),
                        ],
                      ))),
            ],
          ),
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
